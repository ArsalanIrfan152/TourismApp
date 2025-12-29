import 'package:flutter/material.dart';
import 'package:tourismapp/main.dart'; // For AppColors
import 'package:tourismapp/widgets/app_layout.dart'; // Import AppLayout

// --- Global State for Favorites ---
final ValueNotifier<List<Map<String, String>>> favoritesNotifier = ValueNotifier([]);

// --- Destination Data ---
final List<Map<String, String>> allDestinations = [
  {
    'id': '1',
    'title': 'AlUla',
    'url': 'https://images.squarespace-cdn.com/content/v1/54af99b7e4b02e23210f1359/3c3f0159-6c46-4d8f-a800-b2693df8bb71/elephant-rock-place-to-go-hero-0.jpg?format=1500w',
    'desc': 'Nature, Culture & History, Beautiful Landscapes',
    'temp': '24.3°C'
  },
  {
    'id': '2',
    'title': 'Jeddah',
    'url': 'https://upload.wikimedia.org/wikipedia/commons/8/80/Jeddah_Waterfront_2025_%28cropped%29.jpg',
    'desc': 'Nature, Culture & History, Beautiful Landscapes',
    'temp': '29.9°C'
  },
  {
    'id': '3',
    'title': 'Riyadh',
    'url': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJTGsLdtSlvKeaR_uNPmQ6O6epBszHyxvZ0Y98cEjIHN86Uowgk7vP9bvjACoLsAzOBoY&usqp=CAU',
    'desc': 'Nature, Culture & History, Beautiful Landscapes',
    'temp': '21.7°C'
  },
  {
    'id': '4',
    'title': 'Makkah',
    'url': 'https://media-cdn.tripadvisor.com/media/attractions-splice-spp-674x446/15/8c/cb/62.jpg',
    'desc': 'Historic site, Shopping & Religious site',
    'temp': '26.2°C'
  },
  {
    'id': '5',
    'title': 'Madinah',
    'url': 'https://images.pexels.com/photos/24284829/pexels-photo-24284829/free-photo-of-tombs-of-prophet-muhammad-and-caliphs-in-medina.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    'desc': 'Culture & History, Nature, Adventure',
    'temp': '25.2°C'
  },
  {
    'id': '6',
    'title': 'Taif',
    'url': 'https://media-cdn.tripadvisor.com/media/attractions-splice-spp-720x480/12/7c/c0/a0.jpg',
    'desc': 'Culture & History, Nature, Adventure',
    'temp': '22.6°C'
  },
];

class DestinationPage extends StatelessWidget {
  const DestinationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: DestinationsBody(),
    );
  }
}

// --- Destinations Body Widget (Content without navigation/footer) ---
class DestinationsBody extends StatelessWidget {
  const DestinationsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildBannerSection(context),
        const SizedBox(height: 50),

        // Fixed Overflow: Using Wrap and LayoutBuilder for the header row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  const Text(
                    'All Destinations',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w800,
                      fontSize: 32,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FavouritesPage()),
                    ),
                    icon: const Icon(Icons.favorite, color: Colors.white, size: 20),
                    label: Text(
                      constraints.maxWidth < 450 ? "Favorites" : "My Favorites",
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      elevation: 2,
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        const SizedBox(height: 30),
        _buildDestinationGrid(context),
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildBannerSection(BuildContext context) {
    return Container(
      height: 450,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const NetworkImage(
            'https://mir-s3-cdn-cf.behance.net/projects/404/8ec931220843737.Y3JvcCwyMzIzLDE4MTcsMTk1LDA.jpg',
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.darken,
          ),
        ),
      ),
      child: const Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 40.0, bottom: 40.0),
          child: Text(
            'Destinations',
            style: TextStyle(
              fontSize: 54,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontFamily: 'Georgia',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationCard({
    required BuildContext context,
    required String id,
    required String title,
    required String imageUrl,
    required String description,
    required String temperature,
  }) {
    return ValueListenableBuilder<List<Map<String, String>>>(
      valueListenable: favoritesNotifier,
      builder: (context, favorites, _) {
        final isFavorite = favorites.any((element) => element['id'] == id);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: Image.network(
                      imageUrl,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.8),
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          if (isFavorite) {
                            favoritesNotifier.value = favoritesNotifier.value
                                .where((e) => e['id'] != id)
                                .toList();
                          } else {
                            favoritesNotifier.value = [
                              ...favoritesNotifier.value,
                              {
                                'id': id,
                                'title': title,
                                'url': imageUrl,
                                'desc': description,
                                'temp': temperature,
                              },
                            ];
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      temperature,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDestinationGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 1000
              ? 3
              : (constraints.maxWidth > 650 ? 2 : 1);
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 25.0,
              mainAxisSpacing: 25.0,
              childAspectRatio: 0.8,
            ),
            itemCount: allDestinations.length,
            itemBuilder: (context, index) {
              final dest = allDestinations[index];
              return _buildDestinationCard(
                context: context,
                id: dest['id']!,
                title: dest['title']!,
                imageUrl: dest['url']!,
                description: dest['desc']!,
                temperature: dest['temp']!,
              );
            },
          );
        },
      ),
    );
  }
}

// --- Favourites Page (Standalone without AppLayout) ---
class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  Widget _buildFavoriteCard({
    required BuildContext context,
    required String id,
    required String title,
    required String imageUrl,
    required String description,
    required String temperature,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.network(
                  imageUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.8),
                  child: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      favoritesNotifier.value = favoritesNotifier.value
                          .where((e) => e['id'] != id)
                          .toList();
                    },
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  temperature,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: AppColors.accentOrange,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ValueListenableBuilder<List<Map<String, String>>>(
        valueListenable: favoritesNotifier,
        builder: (context, favorites, _) {
          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "You haven't added any favorites yet!",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Browse destinations and tap the heart icon to add them here.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Saved Destinations (${favorites.length})",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 1000
                        ? 3
                        : (constraints.maxWidth > 650 ? 2 : 1);
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final dest = favorites[index];
                        return _buildFavoriteCard(
                          context: context,
                          id: dest['id']!,
                          title: dest['title']!,
                          imageUrl: dest['url']!,
                          description: dest['desc']!,
                          temperature: dest['temp']!,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}