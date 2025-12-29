import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tourismapp/main.dart'; // For AppColors

class BookingFormPage extends StatefulWidget {
  final Map<String, dynamic>? preFilledData;
  const BookingFormPage({super.key, this.preFilledData});

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passportController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController travelersController = TextEditingController(text: "1");
  final TextEditingController phoneController = TextEditingController();

  // Validation flags
  bool isEmailValid = true;
  bool isPhoneValid = true;
  bool isPassportValid = true;

  String? destination;
  DateTime? travelDate;
  PlatformFile? selectedImage;
  bool isSubmitting = false;

  static const double borderRadius = 20.0;
  static const Color glassColor = Color(0xF2FFFFFF);

  // Phone number constants
  static const int maxPhoneLength = 20;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _applyPreFilledData();

    // Add listeners for real-time validation
    emailController.addListener(_validateEmail);
    phoneController.addListener(_validatePhone);
    passportController.addListener(_validatePassport);
  }

  @override
  void dispose() {
    emailController.removeListener(_validateEmail);
    phoneController.removeListener(_validatePhone);
    passportController.removeListener(_validatePassport);
    super.dispose();
  }

  void _applyPreFilledData() {
    // Apply pre-filled data if available
    if (widget.preFilledData != null) {
      final data = widget.preFilledData!;
      destination = data['destination'] as String?;

      if (data['travelers'] != null) {
        travelersController.text = data['travelers'].toString();
      }

      if (data['notes'] != null) {
        notesController.text = data['notes'] as String;
      }
    }
  }

  void _loadUserData() {
    final user = _auth.currentUser;
    if (user != null) {
      // Load user data from Firestore
      _firestore.collection('users').doc(user.uid).get().then((doc) {
        if (doc.exists && mounted) {
          final data = doc.data() as Map<String, dynamic>?;
          nameController.text = data?['displayName'] ?? '';
          emailController.text = user.email ?? '';
          phoneController.text = data?['phone'] ?? '';
          passportController.text = data?['passport'] ?? '';

          // Validate after loading
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _validateEmail();
            _validatePhone();
            _validatePassport();
          });
        }
      });
    }
  }

  // Email validation with comprehensive regex
  void _validateEmail() {
    if (emailController.text.isEmpty) {
      setState(() => isEmailValid = true);
      return;
    }

    final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );

    final isValid = emailRegex.hasMatch(emailController.text.trim());
    setState(() => isEmailValid = isValid);
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    // Check for disposable email domains
    final disposableDomains = [
      'tempmail.com', 'throwaway.com', 'mailinator.com',
      'guerrillamail.com', '10minutemail.com', 'fakeinbox.com'
    ];

    final domain = value.split('@').last.toLowerCase();
    if (disposableDomains.any((d) => domain.contains(d))) {
      return 'Please use a permanent email address';
    }

    return null;
  }

  // Phone validation for international numbers
  void _validatePhone() {
    if (phoneController.text.isEmpty) {
      setState(() => isPhoneValid = true);
      return;
    }

    // Remove all non-digit characters except +
    final digitsOnly = phoneController.text.replaceAll(RegExp(r'[^\d+]'), '');

    // Basic validation: at least 8 digits for international numbers
    final digitCount = digitsOnly.replaceAll('+', '').length;
    final hasCountryCode = digitsOnly.startsWith('+');

    setState(() => isPhoneValid = (hasCountryCode && digitCount >= 8 && digitCount <= 15) ||
        (!hasCountryCode && digitCount >= 10 && digitCount <= 15));
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Check total length (including formatting characters)
    if (value.length > maxPhoneLength) {
      return 'Phone number too long. Maximum $maxPhoneLength characters allowed.';
    }

    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^\d+]'), '');
    final digitCount = digitsOnly.replaceAll('+', '').length;

    // Check if it starts with +
    final hasCountryCode = digitsOnly.startsWith('+');

    if (hasCountryCode) {
      // International format: + followed by 8-15 digits
      if (!RegExp(r'^\+\d{8,15}$').hasMatch(digitsOnly)) {
        return 'Please enter a valid international phone number\nFormat: +[Country Code][Number]\n8-15 digits after +';
      }
    } else {
      // Local format: 10-15 digits
      if (!RegExp(r'^\d{10,15}$').hasMatch(digitsOnly)) {
        return 'Please enter a valid phone number (10-15 digits)';
      }

      // Suggest adding country code for better formatting
      if (digitsOnly.length == 10 && !value.contains('+')) {
        return 'For international use, include country code\nExample: +1XXXXXXXXXX';
      }
    }

    return null;
  }

  // Passport/ID validation
  void _validatePassport() {
    if (passportController.text.isEmpty) {
      setState(() => isPassportValid = true);
      return;
    }

    final text = passportController.text.trim().toUpperCase();
    final isValid = _isValidPassportNumber(text);
    setState(() => isPassportValid = isValid);
  }

  String? _passportValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Passport/ID number is required';
    }

    final text = value.trim().toUpperCase();

    // Check length
    if (text.length < 6 || text.length > 12) {
      return 'Passport/ID number must be 6-12 characters';
    }

    // Check if it's a valid format
    if (!_isValidPassportNumber(text)) {
      return '''
Invalid format. Acceptable formats:
• 9-digit US passport: e.g., 123456789
• 8-character UK passport: e.g., 12345678
• International: 1 letter + 7 digits: e.g., A1234567
• National ID: digits only, 6-12 characters
''';
    }

    return null;
  }

  bool _isValidPassportNumber(String text) {
    // Common passport formats:
    // 1. 9 digits (US passport)
    if (RegExp(r'^\d{9}$').hasMatch(text)) return true;

    // 2. 8 digits (UK passport)
    if (RegExp(r'^\d{8}$').hasMatch(text)) return true;

    // 3. 1 letter followed by 7 digits (international)
    if (RegExp(r'^[A-Z]\d{7}$').hasMatch(text)) return true;

    // 4. Alphanumeric 8-12 characters (various countries)
    if (RegExp(r'^[A-Z0-9]{8,12}$').hasMatch(text)) return true;

    // 5. National ID: digits only, 6-12 characters
    if (RegExp(r'^\d{6,12}$').hasMatch(text)) return true;

    return false;
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: isError ? Colors.redAccent.shade700 : AppColors.accentOrange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  Future<void> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,  // Changed from FileType.image
        allowMultiple: false,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        // Check file size (max 5MB)
        if (file.size > 5 * 1024 * 1024) {
          _showSnack('File size too large. Maximum 5MB allowed.', isError: true);
          return;
        }

        setState(() => selectedImage = file);
      }
    } catch (e) {
      _showSnack('Error picking image: $e', isError: true);
    }
  }

  Future<void> pickDate() async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.accentOrange, onPrimary: Colors.white),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => travelDate = picked);
  }

  Future<void> submitForm() async {
    // Validate all fields
    if (!_formKey.currentState!.validate()) {
      _showSnack('Please check for errors in the form', isError: true);
      return;
    }

    if (travelDate == null) {
      _showSnack('Travel date is required', isError: true);
      return;
    }

    if (selectedImage == null) {
      _showSnack('Passport/ID document is required', isError: true);
      return;
    }

    final user = _auth.currentUser;
    if (user == null) {
      _showSnack('Please sign in to book', isError: true);
      return;
    }

    // Check if travel date is at least 3 days in future
    final minTravelDate = DateTime.now().add(const Duration(days: 3));
    if (travelDate!.isBefore(minTravelDate)) {
      _showSnack('Travel date must be at least 3 days from now', isError: true);
      return;
    }

    setState(() => isSubmitting = true);

    try {
      // Generate booking ID
      final bookingId = _firestore.collection('bookings').doc().id;

      // Prepare booking data
      final bookingData = {
        'bookingId': bookingId,
        'userId': user.uid,
        'userEmail': emailController.text.trim(),
        'userName': nameController.text.trim(),
        'userPhone': phoneController.text.trim(),
        'passportNumber': passportController.text.trim().toUpperCase(),
        'destination': destination,
        'travelDate': travelDate!.toIso8601String(),
        'travelers': int.tryParse(travelersController.text) ?? 1,
        'notes': notesController.text.trim(),
        'documentName': selectedImage?.name,
        'documentSize': selectedImage?.size,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'totalPrice': 1000.0 * (int.tryParse(travelersController.text) ?? 1),
        'paymentStatus': 'unpaid',
        'validatedAt': FieldValue.serverTimestamp(),
      };

      // AUTO-CREATE: Save to bookings collection
      await _firestore.collection('bookings').doc(bookingId).set(bookingData);

      // AUTO-CREATE: Save to user's bookings subcollection in firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('bookings')
          .doc(bookingId)
          .set(bookingData);

      // Update user profile (user specific info) in firestore
      await _firestore.collection('users').doc(user.uid).update({
        'phone': phoneController.text.trim(),
        'passport': passportController.text.trim().toUpperCase(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _showSuccessDialog(bookingId);
    } catch (e) {
      _showSnack('Error: ${e.toString()}', isError: true);
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  void _showSuccessDialog(String bookingId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 30),
            SizedBox(width: 10),
            Text('Booking Confirmed!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Booking ID: $bookingId', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            const Text('Your booking has been submitted successfully.'),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'You will receive a confirmation email shortly.',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentOrange,
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  // Helper to format phone number as user types
  String _formatPhoneNumber(String input) {
    if (input.isEmpty) return input;

    // If starts with +, keep as is for international
    if (input.startsWith('+')) {
      final digits = input.replaceAll(RegExp(r'[^\d+]'), '');
      return digits;
    }

    // Format local numbers
    final digits = input.replaceAll(RegExp(r'[^\d]'), '');

    if (digits.length <= 3) {
      return digits;                                               //12 or 123
    } else if (digits.length <= 6) {
      return '${digits.substring(0, 3)}-${digits.substring(3)}';  //123-12
    } else {
      return '${digits.substring(0, 3)}-${digits.substring(3, 6)}-${digits.substring(6)}';  //123-123-12
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "BOOK EXPEDITION",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1473580044384-7ba9967e16a0?q=80&w=2070&auto=format&fit=crop',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.8)
                  ],
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 60),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: glassColor,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User Status
                        if (_auth.currentUser != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.account_circle, color: Colors.green),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Signed in', style: TextStyle(fontWeight: FontWeight.bold)),
                                      Text(
                                        _auth.currentUser!.email!,
                                        style: const TextStyle(fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const Text(
                          "Personal Details",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "Full Name",
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Full name is required';
                            if (val.length < 2) return 'Name must be at least 2 characters';
                            if (val.length > 50) return 'Name is too long';
                            if (RegExp(r'\d').hasMatch(val)) return 'Name cannot contain numbers';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email Address",
                            prefixIcon: const Icon(Icons.email),
                            suffixIcon: Icon(
                              isEmailValid ? Icons.check_circle : Icons.error,
                              color: isEmailValid ? Colors.green : Colors.red,
                              size: 20,
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: isEmailValid ? Colors.grey : Colors.red,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: isEmailValid ? AppColors.accentOrange : Colors.red,
                                width: 2,
                              ),
                            ),
                          ),
                          validator: _emailValidator,
                          onChanged: (value) => _validateEmail(),
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: maxPhoneLength,
                          buildCounter: (BuildContext context, {int? currentLength, int? maxLength, bool? isFocused}) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '$currentLength/$maxLength',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: currentLength == maxLength ? Colors.red : Colors.grey,
                                  ),
                                ),
                              ],
                            );
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[\d\+-]')),
                            LengthLimitingTextInputFormatter(maxPhoneLength),
                          ],
                          decoration: InputDecoration(
                            labelText: "Phone Number",
                            hintText: "+1 234 567 8900 or 123-456-7890",
                            prefixIcon: const Icon(Icons.phone),
                            suffixIcon: Icon(
                              isPhoneValid ? Icons.check_circle : Icons.error,
                              color: isPhoneValid ? Colors.green : Colors.red,
                              size: 20,
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: isPhoneValid ? Colors.grey : Colors.red,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: isPhoneValid ? AppColors.accentOrange : Colors.red,
                                width: 2,
                              ),
                            ),
                            errorMaxLines: 3,
                          ),
                          validator: _phoneValidator,
                          onChanged: (value) => _validatePhone(),
                        ),

                        const SizedBox(height: 30),
                        const Text(
                          "Trip Details",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),

                        DropdownButtonFormField<String>(
                          value: destination,
                          items: const ['Riyadh', 'AlUla', 'Makkah', 'Madinah', 'Jeddah']
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (v) => setState(() => destination = v),
                          decoration: InputDecoration(
                            labelText: "Destination",
                            prefixIcon: const Icon(Icons.place),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (v) => v == null ? 'Please select a destination' : null,
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: travelersController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2),
                                ],
                                decoration: InputDecoration(
                                  labelText: "Travelers",
                                  hintText: "1-10",
                                  prefixIcon: const Icon(Icons.people),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                validator: (val) {
                                  final num = int.tryParse(val ?? '');
                                  if (num == null || num < 1) return 'At least 1 traveler required';
                                  if (num > 10) return 'Maximum 10 travelers per booking';
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                onTap: pickDate,
                                child: Container(
                                  height: 56,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: travelDate == null ? Colors.grey : Colors.green,
                                      width: travelDate == null ? 1 : 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color: travelDate == null ? Colors.grey : AppColors.accentOrange,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          travelDate == null
                                              ? "Select Travel Date"
                                              : "${travelDate!.day}/${travelDate!.month}/${travelDate!.year}",
                                          style: TextStyle(
                                            color: travelDate == null ? Colors.grey[600] : Colors.black,
                                          ),
                                        ),
                                      ),
                                      if (travelDate != null)
                                        Icon(Icons.check, color: Colors.green, size: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),
                        const Text(
                          "Identification",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: passportController,
                          textCapitalization: TextCapitalization.characters,
                          maxLength: 12,
                          decoration: InputDecoration(
                            labelText: "Passport/ID Number",
                            hintText: "e.g., A1234567 or 123456789",
                            prefixIcon: const Icon(Icons.badge),
                            suffixIcon: Icon(
                              isPassportValid ? Icons.check_circle : Icons.error,
                              color: isPassportValid ? Colors.green : Colors.red,
                              size: 20,
                            ),
                            counterText: "",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: isPassportValid ? Colors.grey : Colors.red,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: isPassportValid ? AppColors.accentOrange : Colors.red,
                                width: 2,
                              ),
                            ),
                            errorMaxLines: 5,
                          ),
                          validator: _passportValidator,
                          onChanged: (value) => _validatePassport(),
                        ),
                        const SizedBox(height: 16),

                        InkWell(
                          onTap: pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedImage != null ? Colors.green : Colors.grey,
                                width: selectedImage != null ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      selectedImage != null ? Icons.check_circle : Icons.cloud_upload,
                                      color: selectedImage != null ? Colors.green : AppColors.accentOrange,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        selectedImage == null
                                            ? "Upload Passport/ID Document"
                                            : "✓ ${selectedImage!.name}",
                                        style: TextStyle(
                                          fontWeight: selectedImage != null ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (selectedImage != null)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 34, top: 8),
                                    child: Text(
                                      '${(selectedImage!.size / 1024).toStringAsFixed(1)} KB',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Supported: JPG, PNG, PDF (Max 5MB)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                        // Additional Notes
                        TextFormField(
                          controller: notesController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: "Additional Notes (Optional)",
                            hintText: "Special requirements, dietary restrictions, etc.",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),

                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: isSubmitting ? null : submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentOrange,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 3,
                              shadowColor: AppColors.accentOrange.withOpacity(0.5),
                            ),
                            child: isSubmitting
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                              "BOOK NOW",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}