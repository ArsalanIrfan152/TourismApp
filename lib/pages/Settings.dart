import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

// --- Import the main application file for AppColors and Theme ---
import 'package:tourismapp/main.dart';

// --- Imports for User's Existing Pages (Navigation Targets) ---
import 'Home.dart';
import 'Destination.dart';
import 'Planyourtrip.dart';
import 'Thingstodo.dart';
import 'Map.dart';
import 'BookNow.dart';
import 'Principles.dart';
import 'Terms.dart';
import 'Privacy.dart';
import 'Cookies.dart';
import 'Profile.dart';
import 'package:tourismapp/widgets/app_layout.dart'; // Import AppLayout
import 'package:tourismapp/services/notification_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService _notificationService = NotificationService();

  bool _pushNotifications = true;
  bool _emailUpdates = false;
  bool _locationServices = true;
  bool _autoSaveTrips = true;
  bool _dataSaving = false;

  String _selectedCurrency = "SAR - Saudi Riyal";


  List<String> currencies = [
    "SAR - Saudi Riyal",
    "USD - US Dollar",
    "EUR - Euro",
    "GBP - British Pound",
    "AED - UAE Dirham",
  ];


  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      // Load user settings from Firestore if logged in
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          setState(() {
            _pushNotifications = data['pushNotifications'] ?? true;
            _emailUpdates = data['emailUpdates'] ?? false;
            _locationServices = data['locationServices'] ?? true;
            _autoSaveTrips = data['autoSaveTrips'] ?? true;
            _dataSaving = data['dataSaving'] ?? false;
            _selectedCurrency = data['currency'] ?? "SAR - Saudi Riyal";
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          key: value,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint('Error saving setting: $e');
    }
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select Currency"),
        content: SizedBox(
          width: double.maxFinite,
          height: 250,
          child: ListView.builder(
            itemCount: currencies.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(currencies[index]),
                trailing: _selectedCurrency == currencies[index]
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () {
                  setState(() => _selectedCurrency = currencies[index]);
                  _saveSetting('currency', currencies[index]);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear Cache"),
        content: const Text("This will remove temporary files and free up storage space."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              // In a real app, you would clear actual cache
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Cache cleared successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text("Clear", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Export Data"),
        content: const Text("Your travel data will be exported as a JSON file."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Simulate export delay
              await Future.delayed(const Duration(milliseconds: 800));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Data exported successfully"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text("Export"),
          ),
        ],
      ),
    );
  }

  void _shareApp() {
    Share.share(
      'Check out Dunes of Arabia - The ultimate travel companion for exploring Saudi Arabia!',
      subject: 'Dunes of Arabia Travel App',
    );
  }

  void _rateApp() async {
    const appStoreUrl = 'https://apps.apple.com/app/id123456789';
    const playStoreUrl = 'https://play.google.com/store/apps/details?id=com.dunesofarabia';

    final url = Platform.isIOS ? appStoreUrl : playStoreUrl;

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not open app store")),
      );
    }
  }

  void _contactSupport() async {
    final email = Uri(
      scheme: 'mailto',
      path: 'support@dunesofarabia.com',
      queryParameters: {
        'subject': 'Dunes of Arabia App Support',
      },
    );

    if (await canLaunchUrl(email)) {
      await launchUrl(email);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Contact Support"),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Email: support@dunesofarabia.com"),
              SizedBox(height: 10),
              Text("Phone: +966 12 345 6789"),
              SizedBox(height: 10),
              Text("Hours: 9 AM - 6 PM (AST)"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        ),
      );
    }
  }

  void _showAppInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("App Information"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Dunes of Arabia", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 10),
              const Text("Version: 1.0.0"),
              const Text("Build: 2024.01"),
              const SizedBox(height: 10),
              const Text("© 2024 Saudi Tourism Authority"),
              const SizedBox(height: 10),
              const Text("All rights reserved."),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  const url = 'https://www.sauditourism.sa';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  }
                },
                child: const Text("Visit Official Website"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _copyUserId() {
    final user = _auth.currentUser;
    if (user != null) {
      Clipboard.setData(ClipboardData(text: user.uid));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User ID copied to clipboard"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _togglePushNotifications(bool value) {
    setState(() => _pushNotifications = value);
    _saveSetting('pushNotifications', value);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value ? "Push notifications enabled" : "Push notifications disabled"),
        backgroundColor: AppColors.accentOrange,
      ),
    );
  }

  void _toggleEmailUpdates(bool value) {
    setState(() => _emailUpdates = value);
    _saveSetting('emailUpdates', value);
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return AppLayout(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Header Banner ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 60),
              color: AppColors.primaryBackgroundLight,
              child: const Center(
                child: Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    fontFamily: 'Georgia',
                  ),
                ),
              ),
            ),

            // --- Content ---
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Account Info Section
                    if (user != null) ...[
                      _buildSectionTitle("Account Information", Icons.account_circle),
                      Card(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.email, color: AppColors.accentOrange, size: 20),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      user.email ?? "No email",
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.person, color: AppColors.accentOrange, size: 20),
                                  const SizedBox(width: 10),
                                  Text(
                                    user.displayName ?? "No display name",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.verified_user, color: AppColors.accentOrange, size: 20),
                                  const SizedBox(width: 10),
                                  Text(
                                    user.emailVerified ? "Email verified" : "Email not verified",
                                    style: TextStyle(
                                      color: user.emailVerified ? Colors.green : Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.fingerprint, color: AppColors.accentOrange, size: 20),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "User ID: ${user.uid.substring(0, 8)}...",
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.copy, size: 18),
                                    onPressed: _copyUserId,
                                    tooltip: "Copy User ID",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Personalization
                    _buildSectionTitle("Personalization", Icons.palette),
                    _buildSettingTile(
                      "Currency",
                      _selectedCurrency,
                      Icons.currency_exchange,
                      onTap: _showCurrencyDialog,
                    ),
                    const SizedBox(height: 25),

                    // Notifications
                    _buildSectionTitle("Notifications", Icons.notifications),
                    _buildSwitchTile(
                      "Push Notifications",
                      "Receive travel alerts and updates",
                      _pushNotifications,
                      _togglePushNotifications,
                    ),
                    _buildSwitchTile(
                      "Email Updates",
                      "Get newsletters and promotions",
                      _emailUpdates,
                      _toggleEmailUpdates,
                    ),
                    const SizedBox(height: 25),

                    // Privacy & Security
                    _buildSectionTitle("Privacy & Security", Icons.security),
                    _buildSwitchTile(
                      "Location Services",
                      "Allow access to your location",
                      _locationServices,
                          (value) {
                        setState(() => _locationServices = value);
                        _saveSetting('locationServices', value);
                      },
                    ),
                    _buildSwitchTile(
                      "Auto-save Trips",
                      "Automatically save trip history",
                      _autoSaveTrips,
                          (value) {
                        setState(() => _autoSaveTrips = value);
                        _saveSetting('autoSaveTrips', value);
                      },
                    ),
                    _buildSwitchTile(
                      "Data Saving",
                      "Reduce mobile data usage",
                      _dataSaving,
                          (value) {
                        setState(() => _dataSaving = value);
                        _saveSetting('dataSaving', value);
                      },
                    ),
                    const SizedBox(height: 25),

                    // App Management
                    _buildSectionTitle("App Management", Icons.settings_applications),
                    _buildActionTile(
                      "Clear Cache",
                      "Free up storage space",
                      Icons.delete_sweep,
                      onTap: _clearCache,
                      isDestructive: true,
                    ),
                    _buildActionTile(
                      "Export My Data",
                      "Download your travel history",
                      Icons.file_download,
                      onTap: _exportData,
                    ),
                    _buildActionTile(
                      "Share App",
                      "Tell friends about this app",
                      Icons.share,
                      onTap: _shareApp,
                    ),
                    _buildActionTile(
                      "Rate App",
                      "Rate us on the app store",
                      Icons.star,
                      onTap: _rateApp,
                    ),
                    const SizedBox(height: 25),

                    // Support
                    _buildSectionTitle("Support", Icons.help_outline),
                    _buildActionTile(
                      "Contact Customer Service",
                      "Get help from our support team",
                      Icons.headset_mic,
                      onTap: _contactSupport,
                    ),
                    _buildActionTile(
                      "App Information",
                      "Version, terms, and policies",
                      Icons.info,
                      onTap: _showAppInfo,
                    ),

                    // Legal
                    const SizedBox(height: 25),
                    _buildSectionTitle("Legal", Icons.gavel),
                    _buildActionTile(
                      "Terms & Conditions",
                      "Read our terms of service",
                      Icons.description,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsPage())),
                    ),
                    _buildActionTile(
                      "Privacy Policy",
                      "How we handle your data",
                      Icons.privacy_tip,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPage())),
                    ),
                    _buildActionTile(
                      "Cookie Policy",
                      "Learn about our cookie usage",
                      Icons.cookie,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CookiesPage())),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accentOrange, size: 22),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSettingTile(String title, String value, IconData icon, {VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.accentOrange),
        title: Text(title),
        subtitle: Text(value),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.accentOrange,
      ),
    );
  }

  Widget _buildActionTile(String title, String subtitle, IconData icon, {
    required VoidCallback onTap,
    bool isDestructive = false
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: isDestructive ? Colors.red : AppColors.accentOrange),
        title: Text(title, style: TextStyle(color: isDestructive ? Colors.red : null)),
        subtitle: Text(subtitle, style: TextStyle(color: isDestructive ? Colors.red : null)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}