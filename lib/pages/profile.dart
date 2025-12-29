import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourismapp/main.dart'; // For AppColors
import 'package:tourismapp/widgets/app_layout.dart';
import 'Destination.dart';
import 'Thingstodo.dart';
import 'Map.dart';
import 'BookNow.dart';
import 'Settings.dart';
import 'authenticate.dart';
import 'BookingHistory.dart';
import 'PrivacySecurity.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: ProfileBody(),
    );
  }
}

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    final user = _auth.currentUser;
    setState(() {
      _currentUser = user;
      _isLoading = false;
    });
  }

  Future<void> _signOut() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _auth.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthPage()),
                      (route) => false,
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error signing out: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _updateProfilePicture() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile picture update coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accentOrange),
      );
    }

    if (_currentUser == null) {
      return const AuthPage();
    }

    return Column(
      children: [
        _buildProfileHero(),

        // Profile Content
        Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 900),
            padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("My Journey"),
                _buildMenuItem(
                  context,
                  Icons.favorite_border,
                  "Saved Destinations",
                  "Your favorite places to visit",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavouritesPage(),
                    ),
                  ),
                ),
                _buildMenuItem(
                  context,
                  Icons.history,
                  "Booking History",
                  "Past and upcoming bookings",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingHistoryPage(userId: _currentUser!.uid),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
                _buildSectionTitle("Account"),
                _buildMenuItem(
                  context,
                  Icons.settings_outlined,
                  "Settings",
                  "Manage notifications and preferences",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  ),
                ),
                _buildMenuItem(
                  context,
                  Icons.lock_outline,
                  "Privacy & Security",
                  "Data and password management",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivacySecurityPage(userId: _currentUser!.uid),
                    ),
                  ),
                ),
                _buildMenuItem(
                  context,
                  Icons.help_outline,
                  "Help & Support",
                  "FAQ and contact support",
                  onTap: () => _showHelpDialog(),
                ),

                const SizedBox(height: 50),
                Center(
                  child: Column(
                    children: [
                      // Logout Button
                      OutlinedButton(
                        onPressed: _signOut,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.logout, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              "Log Out",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHero() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.secondaryBackgroundDark,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: _updateProfilePicture,
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: AppColors.accentOrange,
                  backgroundImage: _currentUser?.photoURL != null
                      ? NetworkImage(_currentUser!.photoURL!)
                      : null,
                  child: _currentUser?.photoURL == null
                      ? Text(
                    _currentUser?.displayName?.isNotEmpty == true
                        ? _currentUser!.displayName![0].toUpperCase()
                        : _currentUser?.email?[0].toUpperCase() ?? 'G',
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _updateProfilePicture,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.accentOrange,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.edit, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            _currentUser?.displayName?.isNotEmpty == true
                ? _currentUser!.displayName!
                : _currentUser?.email?.split('@')[0] ?? "Guest Traveler",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'Georgia',
            ),
          ),
          Text(
            _currentUser?.email ?? "traveler@example.com",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: () => _showEditProfileDialog(),
            icon: const Icon(Icons.edit_note, size: 16),
            label: const Text('Edit Profile'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.white.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 50,
            height: 3,
            color: AppColors.accentOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context,
      IconData icon,
      String title,
      String subtitle, {
        VoidCallback? onTap,
      }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.accentOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.accentOrange),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 13),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey,
        ),
        onTap: onTap ?? () {},
      ),
    );
  }

  void _showEditProfileDialog() {
    TextEditingController nameController = TextEditingController(
      text: _currentUser?.displayName ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Display Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Email:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(_currentUser?.email ?? 'No email'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty && _currentUser != null) {
                try {
                  await _currentUser!.updateDisplayName(
                    nameController.text.trim(),
                  );
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error updating profile: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need assistance?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('📧 Email: support@dunesofarabia.com'),
            SizedBox(height: 8),
            Text('📞 Phone: +966 123 456 789'),
            SizedBox(height: 8),
            Text('🕐 Hours: 9 AM - 6 PM (AST)'),
            SizedBox(height: 15),
            Text(
              'Frequently Asked Questions:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text('• How to book a trip?'),
            Text('• How to save destinations?'),
            Text('• How to update profile?'),
          ],
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
}