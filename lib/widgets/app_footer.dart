import 'package:flutter/material.dart';
import '../main.dart';
import '../pages/Principles.dart';
import '../pages/Terms.dart';
import '../pages/Privacy.dart';
import '../pages/Cookies.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build (BuildContext context) {
    final Map<String, Widget> footerPages = {
      'Principles of Secure Use': const PrinciplesPage(),
      'Terms and Conditions': const TermsPage(),
      'Privacy Policy': const PrivacyPage(),
      'Cookies': const CookiesPage(),
    };

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
      color: AppColors.secondaryBackgroundDark,
      child: Column(
        children: [
          Text(
            'Copyrights ©2024 All rights reserved. Saudi Tourism Authority',
            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 25.0,
            runSpacing: 8.0,
            children: footerPages.entries.map((entry) => TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => entry.value)),
              style: TextButton.styleFrom(foregroundColor: AppColors.textLight, padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: Text(entry.key, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            )).toList(),
          ),
        ],
      ),
    );
  }
}