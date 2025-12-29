import 'package:flutter/material.dart';
import 'package:tourismapp/main.dart'; // For AppColors
import 'package:tourismapp/widgets/app_layout.dart';
import 'Home.dart';
import 'Destination.dart';
import 'Planyourtrip.dart';
import 'Thingstodo.dart';
import 'BookNow.dart';
import 'Map.dart';
import 'Terms.dart';
import 'Principles.dart';
import 'Privacy.dart';
import 'Settings.dart';
import 'profile.dart';

class CookiesPage extends StatelessWidget {
  const CookiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(body: const CookiesContent());
  }
}

// --- Main Content Widget (without navigation, drawer, footer) ---
class CookiesContent extends StatelessWidget {
  const CookiesContent({super.key});

  // --- 2. Banner/Hero Section (Updated Image URL and Title) ---
  Widget _buildBannerSection(BuildContext context) {
    const String bannerImageUrl = 'https://scth.scene7.com/is/image/scth/women-walking-on-the-beach-new:crop-1920x768?defaultImage=women-walking-on-the-beach-new&wid=1500&hei=600';

    return Container(
      height: 450,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(bannerImageUrl),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 40.0, bottom: 40.0),
          child: Text(
            'Cookies',
            style: TextStyle(
              color: Colors.white, // Use textLight directly
              fontWeight: FontWeight.w700,
              fontSize: 60,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ),
    );
  }

  // --- 3. Main Content Section (Updated Content) ---
  Widget _buildContentSection(BuildContext context) {
    // Custom styles matching the previous pages for consistency
    const TextStyle bodyTextStyle = TextStyle(
      color: Color(0xFF555555), // Use textGrey directly
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 1.6,
      fontFamily: 'Roboto',
    );

    const TextStyle h2Style = TextStyle(
      color: Color(0xFF333333), // Use textDark directly
      fontWeight: FontWeight.w800,
      fontSize: 32,
      fontFamily: 'Roboto',
    );

    const TextStyle h3Style = TextStyle(
      color: Color(0xFF333333), // Use textDark directly
      fontWeight: FontWeight.w700,
      fontSize: 24,
      fontFamily: 'Roboto',
    );

    // Style for the strong text within the list items
    const TextStyle listItemStrongStyle = TextStyle(
      color: Color(0xFF333333), // Use textDark directly
      fontWeight: FontWeight.w700,
      fontSize: 16,
      fontFamily: 'Roboto',
      height: 1.6,
    );

    // Function to build a list item with bolded leading text
    Widget _buildListItem({required String title, required String description}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: RichText(
          text: TextSpan(
            style: bodyTextStyle.copyWith(height: 1.6), // Base style
            children: [
              TextSpan(text: '• ', style: listItemStrongStyle.copyWith(color: const Color(0xFF333333))),
              TextSpan(text: '$title: ', style: listItemStrongStyle),
              TextSpan(text: description, style: bodyTextStyle),
            ],
          ),
        ),
      );
    }

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 900),
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // H2: Understanding Cookies
            Text(
              'Understanding Cookies',
              style: h2Style,
            ),
            const SizedBox(height: 30),

            // --- Section 1: What Are Cookies? ---
            Text('What Are Cookies?', style: h3Style),
            const SizedBox(height: 10),
            Text(
              'Cookies are small text files stored on your device when you visit a website. They are designed to store specific information about your interaction with the site, such as login details, language preferences, and items in your shopping cart. Cookies play a vital role in enhancing the user experience by personalizing content and saving time during future visits.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 10),
            Text(
              'These files are completely safe and cannot execute any code or install malware on your device. They simply act as a bridge between the user and the website to create a more seamless browsing experience.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 30),

            // --- Section 2: Types of Cookies We Use ---
            Text('Types of Cookies We Use', style: h3Style),
            const SizedBox(height: 10),
            Text(
              'We utilize different types of cookies to ensure the website runs smoothly and effectively:',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 15),

            // Bulleted List - Types of Cookies
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildListItem(
                  title: 'Essential Cookies',
                  description: 'These are necessary for the core functionality of our website, such as logging in, navigating between pages, and accessing secure areas.',
                ),
                _buildListItem(
                  title: 'Performance Cookies',
                  description: 'These cookies collect information about how users interact with the website, helping us identify areas for improvement and optimize loading speeds.',
                ),
                _buildListItem(
                  title: 'Functionality Cookies',
                  description: 'These cookies remember your preferences, such as language settings or display options, to personalize your browsing experience.',
                ),
                _buildListItem(
                  title: 'Advertising Cookies',
                  description: 'We may use these cookies to deliver personalized ads based on your browsing history and preferences.',
                ),
              ],
            ),
            const SizedBox(height: 30),

            // --- Section 3: Why Cookies Are Important ---
            Text('Why Cookies Are Important', style: h3Style),
            const SizedBox(height: 10),
            Text(
              'Cookies are essential for creating a user-friendly browsing experience. They enable websites to function efficiently by remembering your actions and preferences, such as login details and previous interactions. This reduces the need to re-enter information every time you visit the site.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 10),
            Text(
              'In addition, cookies allow us to analyze website traffic and usage patterns, which helps improve our services and tailor them to better meet user needs.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 30),

            // --- Section 4: Managing Cookies ---
            Text('Managing Cookies', style: h3Style),
            const SizedBox(height: 10),
            Text(
              'You have complete control over the cookies stored on your device. Most web browsers allow you to block or delete cookies through their settings. While this option is available, please note that disabling cookies may impact your browsing experience and limit certain functionalities of our site.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 10),
            Text(
              'To manage cookies, consult your browser\'s help section for step-by-step instructions. We encourage users to periodically review their cookie settings to ensure they align with their privacy preferences.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 30),

            // --- Section 5: Your Privacy and Cookies ---
            Text('Your Privacy and Cookies', style: h3Style),
            const SizedBox(height: 10),
            Text(
              'Your privacy is of utmost importance to us. We use cookies responsibly and transparently, ensuring compliance with data protection laws. Any data collected through cookies is anonymized and used solely to enhance your experience and improve our services.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 10),
            Text(
              'If you have any concerns about how we use cookies or wish to learn more about our privacy practices, please contact us. We are committed to addressing your concerns and providing a secure browsing environment.',
              style: bodyTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Banner/Hero Section
          _buildBannerSection(context),

          // Main Content
          _buildContentSection(context),
        ],
      ),
    );
  }
}