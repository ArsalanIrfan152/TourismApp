import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourismapp/main.dart';

class PrivacySecurityPage extends StatefulWidget {
  final String userId;
  const PrivacySecurityPage({required this.userId, super.key});

  @override
  State<PrivacySecurityPage> createState() => _PrivacySecurityPageState();
}

class _PrivacySecurityPageState extends State<PrivacySecurityPage> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _locationTracking = false;
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers for password change
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Security'),
        backgroundColor: AppColors.accentOrange,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Data & Privacy'),
          _buildSwitchItem(
            'Email Notifications',
            'Receive booking confirmations and updates',
            _emailNotifications,
                (value) => setState(() => _emailNotifications = value),
          ),
          _buildSwitchItem(
            'Push Notifications',
            'Get alerts about deals and reminders',
            _pushNotifications,
                (value) => setState(() => _pushNotifications = value),
          ),
          _buildSwitchItem(
            'Location Tracking',
            'Allow app to access your location',
            _locationTracking,
                (value) => setState(() => _locationTracking = value),
          ),

          const SizedBox(height: 30),
          _buildSectionTitle('Account Security'),
          ListTile(
            leading: const Icon(Icons.password, color: AppColors.accentOrange),
            title: const Text('Change Password'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showChangePasswordDialog,
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showDeleteAccountDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSwitchItem(String title, String subtitle, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.accentOrange,
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                  hintText: 'At least 6 characters',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _changePassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentOrange,
            ),
            child: const Text('Update Password'),
          ),
        ],
      ),
    );
  }

  Future<void> _changePassword() async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Validation
    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showError('Please fill all fields');
      return;
    }

    if (newPassword.length < 6) {
      _showError('New password must be at least 6 characters');
      return;
    }

    if (newPassword != confirmPassword) {
      _showError('New passwords do not match');
      return;
    }

    final user = _auth.currentUser;
    if (user == null) {
      _showError('No user logged in');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);

      // Clear controllers
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      // Close dialog
      if (mounted) {
        Navigator.pop(context);
      }

      _showSuccess('Password updated successfully');
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'Current password is incorrect';
          break;
        case 'weak-password':
          errorMessage = 'New password is too weak';
          break;
        default:
          errorMessage = 'Failed to update password: ${e.message}';
      }
      _showError(errorMessage);
    } catch (e) {
      _showError('An error occurred: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning, color: Colors.red, size: 60),
              const SizedBox(height: 16),
              const Text(
                'This action cannot be undone!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'All your data including bookings, favorites, and profile information will be permanently deleted.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Enter your password to confirm',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _deleteAccount,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    final password = _currentPasswordController.text.trim();

    if (password.isEmpty) {
      _showError('Please enter your password to confirm');
      return;
    }

    final user = _auth.currentUser;
    if (user == null) {
      _showError('No user logged in');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      // First, delete user data from Firestore
      await _deleteUserData(user.uid);

      // Then delete the user account
      await user.delete();

      // Clear controllers
      _currentPasswordController.clear();

      // Close dialog and navigate to login/signup
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'Incorrect password';
          break;
        case 'requires-recent-login':
          errorMessage = 'Please log in again and try';
          break;
        default:
          errorMessage = 'Failed to delete account: ${e.message}';
      }
      _showError(errorMessage);
    } catch (e) {
      _showError('An error occurred: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteUserData(String userId) async {
    try {
      // Delete user document from Firestore
      await _firestore.collection('users').doc(userId).delete();

      // Delete user's bookings
      final bookingsSnapshot = await _firestore
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .get();

      for (final doc in bookingsSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete user's favorites
      final favoritesSnapshot = await _firestore
          .collection('favorites')
          .where('userId', isEqualTo: userId)
          .get();

      for (final doc in favoritesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Add any other user data collections you have

    } catch (e) {
      print('Error deleting user data: $e');
      // Continue with account deletion even if data deletion fails
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}