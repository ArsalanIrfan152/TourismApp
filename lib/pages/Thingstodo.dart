import 'package:flutter/material.dart';
import 'package:tourismapp/main.dart'; // For AppColors
import 'package:tourismapp/widgets/app_layout.dart';
import 'Home.dart';
import 'Destination.dart';
import 'Planyourtrip.dart';
import 'Map.dart';
import 'BookNow.dart';
import 'Principles.dart';
import 'Terms.dart';
import 'Privacy.dart';
import 'Cookies.dart';

// --- Color Constants (Defined here to make the file runnable in isolation) ---
const Color secondaryBackgroundDark = Color(0xFF1B1B1B);
const Color primaryBackgroundLight = Color(0xFFF7F7F7);
const Color accentOrange = Color(0xFFD87848);
const Color textDark = Color(0xFF333333);
const Color textLight = Colors.white;
const Color cardBackground = Colors.white;
const Color textGrey = Color(0xFF555555);


class ThingsToDoPage extends StatelessWidget {
  const ThingsToDoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Things To Do',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: primaryBackgroundLight,
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          // For H1 titles ("Guided Tours" & "Discover More")
          headlineLarge: TextStyle(
            color: textDark,
            fontWeight: FontWeight.w800,
            fontSize: 32,
          ),
          // For card titles (H2)
          titleLarge: TextStyle(
            color: textDark,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          // For card paragraphs (P)
          bodyMedium: TextStyle(
            color: textGrey,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        useMaterial3: true,
      ),
      home: AppLayout(body: const ThingsToDoContent()), // Use AppLayout
    );
  }
}

// --- Main Content Widget  ---
class ThingsToDoContent extends StatelessWidget {
  const ThingsToDoContent({super.key});

  // Helper function for placeholder actions
  void _showAction(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$action clicked!')));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Banner/Hero Section
          _buildBannerSection(context),

          // Guided Tours & Experiences Section
          const SizedBox(height: 50),
          _buildGuidedToursSection(context),

          // Discover More Categories Section
          const SizedBox(height: 50),
          _buildDiscoverMoreSection(context),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  // --- 2. Banner/Hero Section ---
  Widget _buildBannerSection(BuildContext context) {
    const String bannerImageUrl = 'https://media.istockphoto.com/id/498283106/photo/underwater-scuba-diver-explore-and-enjoy-coral-reef-sea-life.jpg?s=612x612&w=0&k=20&c=xOj00xaZTpy5-AtKvMvIHHfexz9miSSct_CXb6F9KVA=';

    return Container(
      height: 450,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(bannerImageUrl),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 40.0, bottom: 40.0),
          child: Text(
            'Things To Do',
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w700,
              color: textLight,
              fontFamily: 'Georgia',
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  // --- Guided Tour Card Widget ---
  Widget _buildTourCard({
    required BuildContext context,
    required String title,
    required String imageUrl,
    required String description,
  }) {
    return InkWell(
      onTap: () => _showAction(context, 'View $title Tour'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 380, // Larger card width
        margin: const EdgeInsets.only(right: 22), // spacing between cards
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE with padding inside the card
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  imageUrl,
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) => Container(
                    height: 260,
                    alignment: Alignment.center,
                    color: Colors.grey[200],
                    child: Text(title,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.grey)),
                  ),
                ),
              ),
            ),

            // TEXT AREA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // --- 3. Guided Tours & Experiences Section ---
  Widget _buildGuidedToursSection(BuildContext context) {
    final tours = [
      {
        'title': 'Al-Ahsa',
        'url': 'https://ncusar.org/wp-content/uploads/2025/02/IMG_2365-scaled.jpg',
        'desc': 'Unique Monuments in Al-Ahsa - 5 Days Trip'
      },
      {
        'title': 'KAEC',
        'url': 'https://lh6.googleusercontent.com/proxy/mJC0VJxkiqg38LdN8b7Au9VzRceOd4S5nHXTA6lrF3jlD06wYgkeHTA1rFv3WlVsLy0Y7qdk_5DCpbkD-GgNPWP7QgQpXdbmnduNlcHAo5rWthQyBu-HakcVmpG-D-maE8YUgx07cjIPkw',
        'desc': '2 Days All-Inclusive package-Enjoy King Abdullah Economic City with your loved ones'
      },
      {
        'title': 'Jeddah',
        'url': 'https://i0.wp.com/www.touristsaudiarabia.com/wp-content/uploads/2023/06/Desert-tour-with-jeep.jpg?fit=2500%2C1667&ssl=1',
        'desc': '4x4 Desert Safari in Jeddah: Dune Bashing and desert Activities with Dinner'
      },
      {
        'title': 'Al-Ahsa',
        'url': 'https://imgix-prod.sgs.com/-/media/sgscorp/images/health-and-nutrition/lettuce-field-in-the-sharon-region-israel-2.cdn.en-SA.1.jpg',
        'desc': 'A Breathtaking Visit to a Farm in Al Ahsa: Lemon Picking, Making Lemon Drinks, and Connecting with Nature'
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Guided Tours & Experiences',
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 30),

          SizedBox(
            height: 420, // Enough height for bigger cards
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tours.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final t = tours[index];
                return _buildTourCard(
                  context: context,
                  title: t['title']!,
                  imageUrl: t['url']!,
                  description: t['desc']!,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // --- Category Card Widget ---
  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required String imageUrl,
  }) {
    return InkWell(
      onTap: () => _showAction(context, 'Explore $title'),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(16.0),
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
              shadows: [
                Shadow(color: Colors.black, blurRadius: 4, offset: Offset(1, 1)),
              ]
          ),
        ),
      ),
    );
  }

  // --- 4. Discover More Categories Section ---
  Widget _buildDiscoverMoreSection(BuildContext context) {
    final categories = [
      {'title': 'Nature', 'url': 'https://media.istockphoto.com/id/1403500817/photo/the-craggies-in-the-blue-ridge-mountains.jpg?s=612x612&w=0&k=20&c=N-pGA8OClRVDzRfj_9AqANnOaDS3devZWwrQNwZuDSk='},
      {'title': 'Culture & History', 'url': 'https://media.istockphoto.com/id/153262551/photo/muslim-friday-mass-prayer-in-iran.jpg?s=612x612&w=0&k=20&c=-gAUsKSQJ7Dy1tD47fmwTqYG-k9JbK5XzKDDJUbpx50='},
      {'title': 'Entertainment', 'url': 'https://i.guim.co.uk/img/media/dde34f27410698639f9a3d54e092026232a18ce6/0_0_6500_4681/master/6500.jpg?width=465&dpr=1&s=none&crop=none'},
      {'title': 'Shopping', 'url': 'https://assets.timelinedaily.com/w/1203x902/2024/09/souq-al-zal-1-1500x844.jpg.webp'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Discover More', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 30),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1000 ? 4 : (constraints.maxWidth > 650 ? 2 : 1);
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                  childAspectRatio: 1.5,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return _buildCategoryCard(
                    context: context,
                    title: cat['title']!,
                    imageUrl: cat['url']!,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}