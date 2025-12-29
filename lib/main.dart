import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import '../pages/Home.dart';
import '../pages/authenticate.dart';
import '../services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// --- Custom Theme ---
class AppColors {
  static const Color secondaryBackgroundDark = Color(0xFF000000);
  static const Color primaryBackgroundLight = Color(0xFFF7F7F7);
  static const Color accentOrange = Color(0xFFD87848);
  static const Color textDark = Color(0xFF333333);
  static const Color textLight = Colors.white;
  static const Color cardBackground = Colors.white;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  // Optional: Setup Firestore settings
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );


  // Initialize notifications only on mobile
  if (Platform.isAndroid || Platform.isIOS) {
    try {
      await NotificationService().initNotifications();
      debugPrint('Notifications initialized successfully.');
    } catch (e) {
      debugPrint('Notification initialization error: $e');
    }
  } else {
    debugPrint('Notifications skipped: running on non-mobile platform');
  }

  runApp(const DunesOfArabiaApp());
}

class DunesOfArabiaApp extends StatelessWidget {
  const DunesOfArabiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dunes of Arabia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.primaryBackgroundLight,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
            fontSize: 32,
            letterSpacing: -0.5,
          ),
          bodyLarge: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

/// AuthWrapper decides whether to show the Auth page or Home page
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.accentOrange,
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          return const MainHomePage();
        }

        return const AuthPage();
      },
    );
  }
}
