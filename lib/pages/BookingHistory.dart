import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tourismapp/main.dart';
import 'dart:math';

class BookingHistoryPage extends StatelessWidget {
  final String userId;
  const BookingHistoryPage({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking History'),
        backgroundColor: AppColors.accentOrange,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Remove the orderBy from the query to avoid index requirement
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          // Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.accentOrange,
              ),
            );
          }

          // Handle errors
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 80, color: Colors.red),
                  const SizedBox(height: 20),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentOrange,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Check if there are no bookings
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'No bookings yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Your booking history will appear here',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Get bookings and sort them locally by createdAt in descending order
          final bookings = snapshot.data!.docs;
          bookings.sort((a, b) {
            final aCreatedAt = a['createdAt'] as Timestamp?;
            final bCreatedAt = b['createdAt'] as Timestamp?;

            // Handle null values by putting them at the end
            if (aCreatedAt == null && bCreatedAt == null) return 0;
            if (aCreatedAt == null) return 1;
            if (bCreatedAt == null) return -1;

            return bCreatedAt.compareTo(aCreatedAt); // Descending order
          });

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index].data() as Map<String, dynamic>;
              return _buildBookingCard(booking, context);
            },
          );
        },
      ),
    );
  }

  // Rest of the code remains exactly the same...
  Widget _buildBookingCard(Map<String, dynamic> booking, BuildContext context) {
    // ... [Keep all the existing _buildBookingCard code]
    String formatDate(String dateString) {
      try {
        final date = DateTime.parse(dateString);
        final monthNames = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        return '${monthNames[date.month - 1]} ${date.day}, ${date.year}';
      } catch (e) {
        return dateString;
      }
    }

    String formatDateTime(Timestamp timestamp) {
      try {
        final date = timestamp.toDate();
        final monthNames = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];

        String hour = date.hour.toString().padLeft(2, '0');
        String minute = date.minute.toString().padLeft(2, '0');
        String ampm = date.hour < 12 ? 'AM' : 'PM';

        int hour12 = date.hour % 12;
        if (hour12 == 0) hour12 = 12;

        return '${monthNames[date.month - 1]} ${date.day}, ${date.year} - $hour12:${minute.padLeft(2, '0')} $ampm';
      } catch (e) {
        return timestamp.toString();
      }
    }

    String formatFileSize(int bytes) {
      if (bytes <= 0) return "0 B";
      const suffixes = ["B", "KB", "MB", "GB", "TB"];
      int i = (bytes == 0) ? 0 : (log(bytes) / log(1024)).floor();
      return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
    }

    final travelDate = booking['travelDate'] != null
        ? formatDate(booking['travelDate'])
        : 'Not set';

    final createdAt = booking['createdAt'] != null
        ? formatDateTime(booking['createdAt'] as Timestamp)
        : '';

    Color statusColor = Colors.grey;
    String statusText = booking['status']?.toString() ?? 'pending';
    switch (statusText.toLowerCase()) {
      case 'confirmed':
      case 'completed':
        statusColor = Colors.green;
        break;
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        break;
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Booking ID: ${booking['bookingId'] ?? 'N/A'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    statusText.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _buildInfoRow(
              icon: Icons.place,
              label: 'Destination',
              value: booking['destination']?.toString() ?? 'Not specified',
            ),
            _buildInfoRow(
              icon: Icons.calendar_today,
              label: 'Travel Date',
              value: travelDate,
            ),
            _buildInfoRow(
              icon: Icons.people,
              label: 'Travelers',
              value: '${booking['travelers'] ?? 1} person(s)',
            ),

            if (booking['documentName'] != null && booking['documentName'].toString().isNotEmpty)
              _buildDocumentRow(
                documentName: booking['documentName'].toString(),
                documentSize: booking['documentSize'] ?? 0,
                bookingId: booking['bookingId'].toString(),
              ),

            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Price',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'SAR ${(booking['totalPrice'] ?? 0).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.accentOrange,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Booked on',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      createdAt,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            if (booking['notes'] != null && booking['notes'].toString().isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    'Notes:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    booking['notes'].toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showBookingDetails(context, booking);
                    },
                    icon: const Icon(Icons.remove_red_eye, size: 18),
                    label: const Text('View Details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.accentOrange,
                      side: BorderSide(color: AppColors.accentOrange),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (statusText.toLowerCase() == 'pending')
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showCancelDialog(context, booking);
                      },
                      icon: const Icon(Icons.cancel, size: 18),
                      label: const Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentRow({
    required String documentName,
    required int documentSize,
    required String bookingId,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.attach_file, size: 20, color: Colors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Document',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        documentName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatFileSize(documentSize),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    int i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  void _showBookingDetails(BuildContext context, Map<String, dynamic> booking) {
    String formatDateForDisplay(String dateString) {
      try {
        final date = DateTime.parse(dateString);
        final months = [
          'January', 'February', 'March', 'April', 'May', 'June',
          'July', 'August', 'September', 'October', 'November', 'December'
        ];
        final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

        final weekday = days[date.weekday % 7];
        final month = months[date.month - 1];

        return '$weekday, $month ${date.day}, ${date.year}';
      } catch (e) {
        return dateString;
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailItem('Booking ID', booking['bookingId']),
              _detailItem('Status', booking['status']),
              _detailItem('Destination', booking['destination']),
              _detailItem('Travel Date',
                  booking['travelDate'] != null
                      ? formatDateForDisplay(booking['travelDate'])
                      : 'Not set'
              ),
              _detailItem('Travelers', '${booking['travelers'] ?? 1}'),
              _detailItem('Passport Number', booking['passportNumber']),
              _detailItem('Total Price', 'SAR ${booking['totalPrice']?.toStringAsFixed(2) ?? "0.00"}'),
              _detailItem('Payment Status', booking['paymentStatus']),

              if (booking['documentName'] != null && booking['documentName'].toString().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Document',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.attach_file, size: 16, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  booking['documentName'].toString(),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  _formatFileSize(booking['documentSize'] ?? 0),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () => _downloadDocument(context, booking),
                            icon: const Icon(Icons.download, size: 16),
                            label: const Text('Download'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              backgroundColor: AppColors.accentOrange,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              _detailItem('User Email', booking['userEmail']),
              _detailItem('User Phone', booking['userPhone']),
              if (booking['notes'] != null && booking['notes'].toString().isNotEmpty)
                _detailItem('Notes', booking['notes']),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _detailItem(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value?.toString() ?? 'Not available',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadDocument(BuildContext context, Map<String, dynamic> booking) async {
    final String bookingId = booking['bookingId'].toString();
    final String documentName = booking['documentName'].toString();

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(color: AppColors.accentOrange),
              SizedBox(width: 16),
              Text('Downloading document...'),
            ],
          ),
        ),
      );

      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('documents/$bookingId/$documentName');

      final String downloadUrl = await ref.getDownloadURL();

      Navigator.pop(context);

      if (await canLaunch(downloadUrl)) {
        await launch(downloadUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot open download link'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on FirebaseException catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Firebase Error: ${e.message}'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error downloading document: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCancelDialog(BuildContext context, Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking?'),
        content: const Text('Are you sure you want to cancel this booking? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              _cancelBooking(booking['bookingId']);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _cancelBooking(String bookingId) {
    FirebaseFirestore.instance.collection('bookings').doc(bookingId).update({
      'status': 'cancelled',
      'cancelledAt': FieldValue.serverTimestamp(),
    });
  }
}