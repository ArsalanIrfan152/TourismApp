import 'package:flutter/material.dart';
import 'package:tourismapp/main.dart'; // For AppColors
import 'package:tourismapp/widgets/app_layout.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(body: const TermsContent());
  }
}

// --- Main Content Widget (without navigation, drawer, footer) ---
class TermsContent extends StatelessWidget {
  const TermsContent({super.key});

  // --- 2. Banner/Hero Section ---
  Widget _buildBannerSection(BuildContext context) {
    const String bannerImageUrl = 'https://scth.scene7.com/is/image/scth/brand-page-hero-1920-257:crop-1920x768?defaultImage=brand-page-hero-1920-257&wid=1500&hei=600';

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
            'Terms',
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
              // H2: Understanding Terms and Conditions
              Text(
                'Understanding Terms and Conditions',
                style: h2Style,
              ),
              const SizedBox(height: 30),

              // --- Section 1: Acceptance of Terms ---
              Text('Acceptance of Terms', style: h3Style),
              const SizedBox(height: 10),
              Text(
                'By using this website, you agree to comply with all the terms and conditions laid out in this document. It is important to read them carefully before proceeding. Failure to adhere to these terms may result in restricted access or termination of services provided by this website. If you do not agree with any part of these terms, you must refrain from using the website.',
                style: bodyTextStyle,
              ),
              const SizedBox(height: 30),

              // --- Section 2: Use of Content ---
              Text('Use of Content', style: h3Style),
              const SizedBox(height: 10),
              Text(
                'Content found on this website is protected by copyright laws. Unauthorized use of any material from this website is prohibited. Users are encouraged to contact us for permissions if they wish to use any part of the website\'s content. Reproduction or redistribution of content without consent may lead to legal actions against the violators.',
                style: bodyTextStyle,
              ),
              const SizedBox(height: 30),

              // --- Section 3: Changes to Terms ---
              Text('Changes to Terms', style: h3Style),
              const SizedBox(height: 10),
              Text(
                'We reserve the right to update or modify the terms at any time. Any changes will be reflected on this page, so please review it periodically. Substantial updates will be accompanied by notifications, but it is the user\'s responsibility to stay informed about the current terms. By continuing to use the site after changes, you accept the revised terms.',
                style: bodyTextStyle,
              ),
              const SizedBox(height: 30),

              // --- Section 4: User Responsibilities ---
              Text('User Responsibilities', style: h3Style),
              const SizedBox(height: 10),
              Text(
                'As a user, you are responsible for ensuring your use of this website complies with applicable laws and regulations. This includes not engaging in activities that could harm the website\'s integrity or disrupt its services. Misuse of the website, such as uploading malicious content, could result in immediate access revocation.',
                style: bodyTextStyle,
              ),
              const SizedBox(height: 10),
              Text(
                'We also encourage users to report any suspicious activity or unauthorized access to protect the community. By using the website responsibly, you contribute to a safe and efficient platform for everyone.',
                style: bodyTextStyle,
              ),
              const SizedBox(height: 30),

              // --- Section 5: Privacy Policy ---
              Text('Privacy Policy', style: h3Style),
              const SizedBox(height: 10),
              Text(
                'Your privacy is important to us. Please refer to our Privacy Policy for details on how we handle and protect your personal information. We are committed to ensuring that your data is stored securely and used in compliance with data protection laws.',
                style: bodyTextStyle,
              ),
              const SizedBox(height: 10),
              Text(
                'We collect only the necessary information to improve your experience on our platform. Users are encouraged to contact us if they have concerns about their data or wish to request its removal from our systems.',
                style: bodyTextStyle,
              ),
              const SizedBox(height: 30),

              // --- Section 6: Third-Party Links ---
              Text('Third-Party Links', style: h3Style),
              const SizedBox(height: 10),
              Text(
                'This website may contain links to third-party websites. We are not responsible for the content or practices of these external sites. These links are provided for user convenience, and inclusion does not imply endorsement.',
                style: bodyTextStyle,
              ),
              const SizedBox(height: 10),
              Text(
                'Users should review the privacy policies and terms of use of these third-party websites before engaging with their content. We do not guarantee the accuracy or reliability of the information on these external sites.',
                style: bodyTextStyle,
              ),
            ],
          ),
        )
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
