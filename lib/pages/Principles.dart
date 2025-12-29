import 'package:flutter/material.dart';
import 'package:tourismapp/main.dart'; // For AppColors
import 'package:tourismapp/widgets/app_layout.dart';

class PrinciplesPage extends StatelessWidget {
  const PrinciplesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(body: const PrinciplesContent());
  }
}

// --- Main Content Widget (without navigation, drawer, footer) ---
class PrinciplesContent extends StatelessWidget {
  const PrinciplesContent({super.key});

  // --- 2. Banner/Hero Section ---
  Widget _buildBannerSection(BuildContext context) {
    const String bannerImageUrl = 'https://scth.scene7.com/is/image/scth/tinhat-1:crop-1920x768?defaultImage=tinhat-1&wid=1500&hei=600';

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
            'Principles of Secure Use',
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
    // Custom body text style derived from the HTML/Image appearance
    const TextStyle bodyTextStyle = TextStyle(
      color: Color(0xFF555555), // A slightly darker grey for contrast
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 1.6,
      fontFamily: 'Roboto',
    );

    // Custom H2 and H3 styles to match the visual look (bold, slightly serif-like)
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
            // H2: Principles of Online Security
            Text(
              'Principles of Online Security',
              style: h2Style,
            ),
            const SizedBox(height: 30),

            // --- Section 1: Protecting Personal Data ---
            Text('Protecting Personal Data', style: h3Style),
            const SizedBox(height: 10),
            Text(
              'One of the fundamental principles of secure online usage is the **protection of personal data**. Users should create strong, unique passwords for each account and avoid sharing sensitive information, such as bank details, unless on verified and secure platforms. Regularly updating passwords and using **two-factor authentication** further enhances security.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 10),
            Text(
              'Be vigilant about the permissions granted to apps and websites. Sharing excessive personal details can lead to misuse or identity theft.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 30),

            // --- Section 2: Respecting Digital Privacy ---
            Text('Respecting Digital Privacy', style: h3Style),
            const SizedBox(height: 10),
            Text(
              'Respect for digital privacy extends beyond personal actions. Avoid sharing other people\'s information or media without their explicit consent. This includes refraining from tagging individuals in photos or posts they may not want to be associated with publicly.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 10),
            Text(
              'Additionally, respecting the **terms and conditions** of websites ensures that you comply with their privacy norms while using their services.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 30),

            // --- Section 3: Identifying and Avoiding Phishing Scams ---
            Text('Identifying and Avoiding Phishing Scams', style: h3Style),
            const SizedBox(height: 10),
            Text(
              '**Phishing scams** are one of the most common methods used by attackers to steal personal information. Always verify the authenticity of emails, links, and attachments before clicking or responding. Look for warning signs like generic greetings, spelling errors, or requests for immediate action involving sensitive data.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 10),
            Text(
              'Ensure the websites you interact with are secure by checking for **HTTPS** and verifying the legitimacy of the domain. Avoid providing sensitive information on suspicious or unverified platforms.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 30),

            // --- Section 4: Practicing Responsible Online Behavior ---
            Text('Practicing Responsible Online Behavior', style: h3Style),
            const SizedBox(height: 10),
            Text(
              'Engaging in **responsible online behavior** ensures a safer and more secure internet environment for everyone. This includes avoiding the use of pirated software, refraining from spreading misinformation, and reporting suspicious activity or content to appropriate authorities.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 10),
            Text(
              'By maintaining a respectful and secure online presence, users contribute to a more trustworthy digital ecosystem.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 30),

            // --- Section 5: Adopting Security Best Practices ---
            Text('Adopting Security Best Practices', style: h3Style),
            const SizedBox(height: 10),
            Text(
              'Users are encouraged to adopt best practices, such as keeping devices updated with the latest security patches and using antivirus software. Regularly backing up important data ensures that critical information is not lost in case of a cyberattack or technical failure.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 10),
            Text(
              'It is equally important to educate oneself and others about emerging online threats and evolving security practices to stay ahead of potential risks.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 30),

            // --- Section 6: Understanding Legal Implications ---
            Text('Understanding Legal Implications', style: h3Style),
            const SizedBox(height: 10),
            Text(
              'Online behavior is often governed by local and international laws. Users should be aware of legal frameworks related to online security, privacy, and content sharing. Violating these laws can result in serious legal consequences.',
              style: bodyTextStyle,
            ),
            const SizedBox(height: 10),
            Text(
              'Staying informed about intellectual property laws, data protection regulations, and cybersecurity guidelines helps users avoid unintended violations and ensures they operate responsibly in the digital space.',
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