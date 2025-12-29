import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tourismapp/widgets/app_layout.dart';
import 'package:tourismapp/pages/Profile.dart';
import 'package:tourismapp/pages/Settings.dart';
import 'package:tourismapp/main.dart'; // For AppColors
import 'Destination.dart';
import 'Thingstodo.dart';
import 'Planyourtrip.dart';
import 'Map.dart';
import 'BookNow.dart';
import 'Principles.dart';
import 'Terms.dart';
import 'Privacy.dart';
import 'Cookies.dart';

// --- 2. Main Page Widget ---
class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(23.8859, 45.0792); // Saudi Arabia center

  // Helper function for placeholder actions
  void _showAction(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$action clicked!')));
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // --- Hero Section ---
        _buildHeroSection(context),

        // --- Destinations Section ---
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 60, 28, 20),
          child: Text('Destinations', style: Theme
              .of(context)
              .textTheme
              .headlineLarge),
        ),
        _buildDestinationGrid(),

        // --- Things To Do Section ---
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 60, 28, 20),
          child: Text('Things To Do', style: Theme
              .of(context)
              .textTheme
              .headlineLarge),
        ),
        _buildThingsToDoGrid(),

        // --- Provinces/Map Section ---
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 60, 28, 20),
          child: Text('Provinces', style: Theme
              .of(context)
              .textTheme
              .headlineLarge),
        ),
        _buildMapContainer(context),
      ],
    );
  }

  // --- 4. Hero Section Widget (Cloned from Image 1) ---
  Widget _buildHeroSection(BuildContext context) {
    return Container(
      height: 450,
      decoration: BoxDecoration(
        image: DecorationImage(
          // image_557ea4.png (Hero Banner)
          image: const NetworkImage(
              'https://scth.scene7.com/is/image/scth/dunes-of-arabia-banner-1:crop-1920x1080?defaultImage=dunes-of-arabia-banner-1&wid=1920&hei=1080'),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5), BlendMode.darken),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Dunes of Arabia',
                style: TextStyle(
                  // Mimicking the elegant serif font
                  fontFamily: 'Georgia',
                  fontSize: 64,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLight,
                  letterSpacing: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Tales of immersion awaits, book your next adventure in the desert',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                  fontWeight: FontWeight.w300,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BookingFormPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentOrange,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 45, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  elevation: 5,
                ),
                child: const Text('Book Now', style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- 5. Destination/Things To Do Card Widget ---
  Widget _buildCard(
      {required String title, required String imageUrl, required BuildContext context}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      color: AppColors.cardBackground,
      child: InkWell(
        onTap: () => _showAction(context, 'Explore $title'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 4, // Image takes up most space
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                errorBuilder: (c, o, s) =>
                    Container(
                      color: Colors.grey[200],
                      child: Center(child: Text(title, style: const TextStyle(
                          fontSize: 16, color: Colors.grey))),
                    ),
              ),
            ),
            Expanded(
              flex: 1, // Text area is smaller
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 6. Destination Grid (Cloned from Image 2) ---
  Widget _buildDestinationGrid() {
    final destinations = [
      // Mapped URLs from the files provided
      {
        'title': 'AlUla',
        'url': 'https://images.squarespace-cdn.com/content/v1/54af99b7e4b02e23210f1359/3c3f0159-6c46-4d8f-a800-b2693df8bb71/elephant-rock-place-to-go-hero-0.jpg?format=1500w'
      }, // Placeholder URL for image_55823f.jpg
      {
        'title': 'Jeddah',
        'url': 'https://upload.wikimedia.org/wikipedia/commons/8/80/Jeddah_Waterfront_2025_%28cropped%29.jpg'
      }, // Placeholder URL for image_557f5c.jpg
      {
        'title': 'Riyadh',
        'url': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJTGsLdtSlvKeaR_uNPmQ6O6epBszHyxvZ0Y98cEjIHN86Uowgk7vP9bvjACoLsAzOBoY&usqp=CAU'
      }, // Placeholder URL for image_557f1f.jpg
      {
        'title': 'Makkah',
        'url': 'https://media-cdn.tripadvisor.com/media/attractions-splice-spp-674x446/15/8c/cb/62.jpg'
      },
      {
        'title': 'Madinah',
        'url': 'https://images.pexels.com/photos/24284829/pexels-photo-24284829/free-photo-of-tombs-of-prophet-muhammad-and-caliphs-in-medina.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
      },
      {
        'title': 'Taif',
        'url': 'https://media-cdn.tripadvisor.com/media/attractions-splice-spp-720x480/12/7c/c0/a0.jpg'
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 1000 ? 3 : (constraints
              .maxWidth > 650 ? 2 : 1);
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 25.0,
              mainAxisSpacing: 25.0,
              childAspectRatio: 0.9, // Closer to square/slightly tall
            ),
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              return _buildCard(
                title: destinations[index]['title']!,
                imageUrl: destinations[index]['url']!,
                context: context,
              );
            },
          );
        },
      ),
    );
  }

  // --- 7. Things To Do Grid (Cloned from Image 3) ---
  Widget _buildThingsToDoGrid() {
    final activities = [
      {
        'title': 'Al-Ahsa',
        'url': 'https://ncusar.org/wp-content/uploads/2025/02/IMG_2365-scaled.jpg'
      },
      {
        'title': 'KAEC',
        'url': 'https://lh6.googleusercontent.com/proxy/mJC0VJxkiqg38LdN8b7Au9VzRceOd4S5nHXTA6lrF3jlD06wYgkeHTA1rFv3WlVsLy0Y7qdk_5DCpbkD-GgNPWP7QgQpXdbmnduNlcHAo5rWthQyBu-HakcVmpG-D-maE8YUgx07cjIPkw'
      },
      {
        'title': 'Saudia Arabia Farm Life',
        'url': 'https://imgix-prod.sgs.com/-/media/sgscorp/images/health-and-nutrition/lettuce-field-in-the-sharon-region-israel-2.cdn.en-SA.1.jpg?fit=crop&auto=format&crop=focalpoint&fp-x=0&fp-y=0.5&fp-z=1&w=645&h=403'
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 1000 ? 3 : (constraints
              .maxWidth > 650 ? 2 : 1);
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 25.0,
              mainAxisSpacing: 25.0,
              childAspectRatio: 0.9,
            ),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              return _buildCard(
                title: activities[index]['title']!,
                imageUrl: activities[index]['url']!,
                context: context,
              );
            },
          );
        },
      ),
    );
  }

  // --- 8. Map Container Widget (Google Maps Integrated) ---
  Widget _buildMapContainer(BuildContext context) {
    final List<Map<String, dynamic>> smallMaps = [
      {
        'title': 'Jeddah',
        'position': const LatLng(21.4858, 39.1925),
      },
      {
        'title': 'Riyadh',
        'position': const LatLng(24.7136, 46.6753),
      },
      {
        'title': 'Madinah',
        'position': const LatLng(24.5247, 39.5692),
      },
    ];

    // --- Small Maps Column ---
    final Widget smallMapsColumn = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: smallMaps.map<Widget>((m) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: InkWell(
            onTap: () {
              setState(() {
                _currentPosition = m['position'];
              });

              _mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(m['position'], 11),
              );

              _showAction(context, "View ${m['title']} on map");
            },
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.antiAlias,
              color: AppColors.cardBackground,
              child: Container(
                width: 200,
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: m['position'],
                          zoom: 10,
                        ),
                        liteModeEnabled: true,
                        zoomControlsEnabled: false,
                        scrollGesturesEnabled: false,
                        rotateGesturesEnabled: false,
                        tiltGesturesEnabled: false,
                        markers: {
                          Marker(
                            markerId: MarkerId(m['title']),
                            position: m['position'],
                          ),
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      m['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );

    // --- Large Map Widget ---
    final Widget largeMap = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Explore Saudi Arabia',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 400,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _currentPosition,
                  zoom: 6,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                markers: {
                  Marker(
                    markerId: const MarkerId('selected'),
                    position: _currentPosition,
                  ),
                },
                zoomControlsEnabled: true,
                myLocationButtonEnabled: false,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Click on the small maps to view locations on this map.',
            style: TextStyle(color: AppColors.textDark, fontSize: 14),
          ),
        ],
      ),
    );

    // --- Responsive Layout (UNCHANGED) ---
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: largeMap),
                const SizedBox(width: 40),
                Expanded(flex: 1, child: smallMapsColumn),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                largeMap,
                const SizedBox(height: 40),
                smallMapsColumn,
              ],
            );
          }
        },
      ),
    );
  }
}