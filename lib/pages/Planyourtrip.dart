import 'package:flutter/material.dart';
import 'package:tourismapp/widgets/app_layout.dart';

// --- Import your color constants
const Color primaryBackgroundLight = Color(0xFFF7F7F7);
const Color textDark = Color(0xFF333333);
const Color accentOrange = Color(0xFFD87848);

// --- Data Model for Info Cards ---
class InfoCardData {
  final String title;
  final String url;
  final String content;

  InfoCardData({
    required this.title,
    required this.url,
    required this.content,
  });
}

// --- Global Data for Info Cards ---
final List<InfoCardData> tripInfoCards = [
  InfoCardData(
    title: 'Visa Regulations',
    url: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_QRNHyP4M0qv1Bw_1wt_LY1XsMSWbAupAqg&s',
    content: 'Saudi Arabia offers a simple eVisa for many citizens. Ensure your passport is valid for at least six months from entry. The process is entirely digital and usually approved within 24 hours.',
  ),
  InfoCardData(
    title: 'Travel Guide',
    url: 'https://static.zawya.com/view/acePublic/alias/contentid/MmY3NDIzNDMtNmViNy00/59/1391369779.webp?f=3%3A2&q=0.75&w=3840',
    content: 'The best time to visit is from October to March. Respect local customs, dress modestly in public, and enjoy the legendary Saudi hospitality. Explore ancient heritage sites in AlUla and modern skyscrapers in Riyadh.',
  ),
  InfoCardData(
    title: 'Getting Around',
    url: 'https://i0.wp.com/www.touristsaudiarabia.com/wp-content/uploads/2023/05/shutterstock_1224851173.jpg?fit=1000%2C667&ssl=1',
    content: 'Major cities are well-connected by the Haramain High-Speed Railway. For local travel, ride-sharing apps like Uber and Careem are the most convenient. Car rentals are perfect for desert adventures.',
  ),
  InfoCardData(
    title: 'About Saudi',
    url: 'https://i.natgeofe.com/n/c450fb11-4030-4ea6-97a4-d155847e7aef/NationalGeographic_2611083.jpg',
    content: 'Discover a land where tradition meets transformation. Saudi Arabia is home to stunning coastlines on the Red Sea and vast, golden sand dunes in the Empty Quarter.',
  ),
];

class PlanYourTripPage extends StatelessWidget {
  // Add userId parameter if you want to integrate with user-specific trips
  final String? userId;

  const PlanYourTripPage({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: PlanYourTripBody(userId: userId),
    );
  }
}

// --- Plan Your Trip Body Widget ---
class PlanYourTripBody extends StatelessWidget {
  final String? userId;

  const PlanYourTripBody({super.key, this.userId});

  // Helper function for actions
  void _showAction(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$action clicked!'))
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildBannerSection(context),
          const SizedBox(height: 50),
          _buildContentSection(context),
          const SizedBox(height: 40),
          _buildCardSection(context),

          // Optional: Add a button to navigate to MyTrips page
          if (userId != null) ...[
            const SizedBox(height: 40),
            _buildMyTripsButton(context),
          ],

          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildBannerSection(BuildContext context) {
    return Container(
      height: 450,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const NetworkImage('https://scth.scene7.com/is/image/scth/dunes-of-arabia-banner-1:crop-1920x1080?defaultImage=dunes-of-arabia-banner-1&wid=1920&hei=1080'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
      ),
      child: const Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 40.0, bottom: 40.0),
          child: Text(
            'Plan your Trip',
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontFamily: 'Georgia',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.0),
      child: Column(
        children: [
          Text(
            'Know Before You Go',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: textDark,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Discover breathtaking destinations, rich culture, and exciting experiences.',
            style: TextStyle(
              fontSize: 16,
              color: textDark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCardSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 900
              ? 3
              : (constraints.maxWidth > 600 ? 2 : 1);
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 25.0,
              mainAxisSpacing: 25.0,
              childAspectRatio: 0.85,
            ),
            itemCount: tripInfoCards.length,
            itemBuilder: (context, index) =>
                _buildInfoCard(context, tripInfoCards[index]),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, InfoCardData data) {
    return InkWell(
      onTap: () => _showAction(context, data.title),
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  data.url,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, size: 50, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.content.length > 60 ? '${data.content.substring(0, 60)}...' : data.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InfoDetailPage(data: data),
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: accentOrange,
                    ),
                    child: const Text(
                      'Learn More',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Optional: Button to navigate to MyTrips page
  Widget _buildMyTripsButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Column(
        children: [
          const Text(
            'Ready to plan your trip?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: textDark,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Navigate to MyTripsPage if you have it
              _showAction(context, 'My Trips');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentOrange,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'View My Planned Trips',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Detail Page Widget for "Learn More" ---
class InfoDetailPage extends StatelessWidget {
  final InfoCardData data;

  const InfoDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundLight,
      appBar: AppBar(
        title: Text(
          data.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: textDark),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              data.url,
              width: double.infinity,
              height: 350,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 350,
                  color: Colors.grey[200],
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Image not available',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    data.content,
                    style: const TextStyle(
                      fontSize: 18,
                      color: textDark,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentOrange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      "Back to Plan Your Trip",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}