import 'package:flutter/material.dart';
import 'package:tourismapp/main.dart'; // For AppColors
import 'package:tourismapp/widgets/app_layout.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(body: const PrivacyContent());
  }
}

// --- Main Content Widget (without navigation, drawer, footer) ---
class PrivacyContent extends StatelessWidget {
  const PrivacyContent({super.key});

  // --- 2. Banner/Hero Section ---
  Widget _buildBannerSection(BuildContext context) {
    const String bannerImageUrl = 'https://scth.scene7.com/is/image/scthacc/brand-page-hero-1920:crop-1920x768?defaultImage=brand-page-hero-1920&wid=1500&hei=600';

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
            'Privacy',
            style: TextStyle(
              color: Colors.white, // Use white directly
              fontWeight: FontWeight.w700,
              fontSize: 60,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ),
    );
  }

  // --- 3. Main Content Section ---
  Widget _buildContentSection(BuildContext context) {
    // Custom styles matching the PrinciplesOfSecureUsePage for consistency
    const TextStyle bodyTextStyle = TextStyle(
      color: Color(0xFF555555),
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

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 900),
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // H2: Our Commitment to Privacy
            Text(
              'Our Commitment to Privacy',
              style: h2Style,
            ),
            const SizedBox(height: 30),

            // --- Section 1: Protecting Your Information ---
            Text('Protecting Your Information', style: h3Style),
            const SizedBox(height: 10),
            Text(
              'We are dedicated to safeguarding the privacy of all users who visit our website. Your personal data is protected through robust security measures, including encryption and regular system checks to prevent unauthorized access. We are committed to maintaining the highest standards of data privacy.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 10),
            Text(
              'It is essential to understand that while we take every possible precaution to protect your data, no system is completely immune to breaches. Users are encouraged to use strong passwords and avoid sharing their login details with others for additional safety.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 30),

            // --- Section 2: Information We Collect ---
            Text('Information We Collect', style: h3Style),
            const SizedBox(height: 10),
            Text(
              'We collect personal details such as your name, email address, and browsing preferences to provide a seamless and personalized experience. This information allows us to improve our services and cater to user needs effectively. The collection process is transparent and aligns with legal guidelines.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 10),
            Text(
              'In addition to direct inputs, we may collect data through cookies and similar technologies to monitor user activity and optimize website performance. Users have the option to manage cookie preferences via their browser settings at any time.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 30),

            // --- Section 3: How We Use Your Information ---
            Text('How We Use Your Information', style: h3Style),
            const SizedBox(height: 10),
            Text(
              'Your data is utilized to improve website functionality, personalize content, and enhance the overall user experience. For example, we may use your preferences to recommend content or services that match your interests. All data usage complies with the purposes stated in this policy.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 10),
            Text(
              'Aggregated, non-identifiable information may be used for analytical purposes to understand trends and improve service delivery. Rest assured, this data cannot be traced back to individual users.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 30),

            // --- Section 4: Data Sharing ---
            Text('Data Sharing', style: h3Style),
            const SizedBox(height: 10),
            Text(
              'We prioritize the confidentiality of your personal information and only share it with trusted partners when necessary for operational purposes, such as payment processing or technical support. All third parties are required to adhere to strict confidentiality agreements.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 10),
            Text(
              'We will never sell or rent your personal information to external organizations. In rare cases, data may be shared to comply with legal obligations or in response to lawful requests by public authorities.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 30),

            // --- Section 5: User Rights ---
            Text('User Rights', style: h3Style),
            const SizedBox(height: 10),
            Text(
              'As a user, you have the right to access, update, and delete your personal information at any time. Simply contact our support team for assistance. We aim to process such requests promptly to ensure your satisfaction and compliance with privacy laws.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 10),
            Text(
              'If you believe your data has been mishandled, you can lodge a complaint, and we will investigate the matter thoroughly. Transparency and accountability are at the core of our privacy practices.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 30),

            // --- Section 6: Updates to Privacy Policy ---
            Text('Updates to Privacy Policy', style: h3Style),
            const SizedBox(height: 10),
            Text(
              'We reserve the right to modify this privacy policy at any time to reflect changes in legal requirements, technology, or business practices. Significant updates will be communicated clearly on this page or via email notifications where applicable.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 10),
            Text(
              'We encourage users to review this policy periodically to stay informed about how their information is being handled. Continued use of the website after updates indicates acceptance of the revised terms.',
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