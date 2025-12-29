import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import 'package:tourismapp/widgets/app_layout.dart';

// --- Data Model ---
class MapLocation {
  final String title;
  final LatLng position;

  MapLocation({required this.title, required this.position});
}

class FamousSpot {
  final String name;
  final LatLng position;
  final String description;
  final String category; // historical, natural, cultural, modern

  FamousSpot({
    required this.name,
    required this.position,
    required this.description,
    required this.category,
  });
}

class MapsPage extends StatelessWidget {
  const MapsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      body: MapsBody(),
    );
  }
}

// --- Maps Body Widget ---
class MapsBody extends StatefulWidget {
  const MapsBody({super.key});

  @override
  State<MapsBody> createState() => _MapsBodyState();
}

class _MapsBodyState extends State<MapsBody> {
  GoogleMapController? _mapController;
  LatLng? _currentUserLocation;
  final TextEditingController _searchController = TextEditingController();
  List<FamousSpot> _filteredSpots = [];
  bool _isSearching = false;
  String _selectedCategory = 'All';

  final List<MapLocation> locations = [
    MapLocation(title: 'Jeddah', position: const LatLng(21.4858, 39.1925)),
    MapLocation(title: 'Riyadh', position: const LatLng(24.7136, 46.6753)),
    MapLocation(title: 'Madinah', position: const LatLng(24.5247, 39.5692)),
    MapLocation(title: 'Makkah', position: const LatLng(21.3891, 39.8579)),
    MapLocation(title: 'Taif', position: const LatLng(21.4373, 40.5127)),
    MapLocation(title: 'AlUla', position: const LatLng(26.6080, 37.9232)),
  ];

  final List<FamousSpot> _famousSpots = [
    // Jeddah
    FamousSpot(
      name: 'King Fahd\'s Fountain',
      position: const LatLng(21.5102, 39.1288),
      description: 'Tallest fountain in the world',
      category: 'modern',
    ),
    FamousSpot(
      name: 'Al-Balad Historic District',
      position: const LatLng(21.4860, 39.1862),
      description: 'UNESCO World Heritage Site',
      category: 'historical',
    ),
    FamousSpot(
      name: 'Fakieh Aquarium',
      position: const LatLng(21.6736, 39.1183),
      description: 'First aquarium in Saudi Arabia',
      category: 'cultural',
    ),

    // Riyadh
    FamousSpot(
      name: 'Kingdom Centre',
      position: const LatLng(24.7110, 46.6741),
      description: 'Iconic 99-storey skyscraper',
      category: 'modern',
    ),
    FamousSpot(
      name: 'Masmak Fortress',
      position: const LatLng(24.6310, 46.7145),
      description: 'Historic clay and mud-brick fort',
      category: 'historical',
    ),
    FamousSpot(
      name: 'Diriyah',
      position: const LatLng(24.7326, 46.5723),
      description: 'First capital of Saudi dynasty',
      category: 'historical',
    ),

    // Madinah
    FamousSpot(
      name: 'Al-Masjid an-Nabawi',
      position: const LatLng(24.4672, 39.6113),
      description: 'The Prophet\'s Mosque',
      category: 'historical',
    ),
    FamousSpot(
      name: 'Mount Uhud',
      position: const LatLng(24.5069, 39.6174),
      description: 'Historic mountain site',
      category: 'historical',
    ),

    // Makkah
    FamousSpot(
      name: 'Masjid al-Haram',
      position: const LatLng(21.4225, 39.8262),
      description: 'The Great Mosque of Mecca',
      category: 'historical',
    ),
    FamousSpot(
      name: 'Jabal al-Nour',
      position: const LatLng(21.4583, 39.8597),
      description: 'Mountain of Light',
      category: 'historical',
    ),

    // Taif
    FamousSpot(
      name: 'Al Rudaf Park',
      position: const LatLng(21.2670, 40.4208),
      description: 'Beautiful natural park with large rocks',
      category: 'natural',
    ),
    FamousSpot(
      name: 'Shubra Palace',
      position: const LatLng(21.2651, 40.4104),
      description: 'Historic royal palace',
      category: 'historical',
    ),

    // AlUla
    FamousSpot(
      name: 'Madain Saleh',
      position: const LatLng(26.7917, 37.9525),
      description: 'UNESCO World Heritage archaeological site',
      category: 'historical',
    ),
    FamousSpot(
      name: 'Elephant Rock',
      position: const LatLng(26.6353, 37.9342),
      description: 'Natural rock formation shaped like an elephant',
      category: 'natural',
    ),

    // Eastern Province
    FamousSpot(
      name: 'King Fahd Causeway',
      position: const LatLng(26.1794, 50.3350),
      description: 'Bridge connecting Saudi Arabia to Bahrain',
      category: 'modern',
    ),

    // Abha
    FamousSpot(
      name: 'Al-Soudah Park',
      position: const LatLng(18.2564, 42.3814),
      description: 'Highest peak in Saudi Arabia',
      category: 'natural',
    ),

    // Tabuk
    FamousSpot(
      name: 'Al Disah Valley',
      position: const LatLng(27.6589, 36.4825),
      description: 'Stunning desert valley with rock formations',
      category: 'natural',
    ),
  ];

  LatLng _currentPosition = const LatLng(23.8859, 45.0792);
  String _currentLargeMapTitle = 'Explore Saudi Arabia';
  String _currentLargeMapText = 'Click on the small maps to view locations on this map.';
  int? _selectedIndex;
  Set<Marker> _filteredMarkers = {};

  @override
  void initState() {
    super.initState();
    _filteredSpots = _famousSpots;
    _getCurrentLocation();
    _updateFilteredMarkers();
  }

  void _getCurrentLocation() {
    setState(() {
      _currentUserLocation = const LatLng(24.7136, 46.6753);
    });
  }

  bool _isWithinSaudiArabia(LatLng position) {
    const double minLat = 16.0;
    const double maxLat = 32.0;
    const double minLng = 34.0;
    const double maxLng = 55.0;

    return position.latitude >= minLat &&
        position.latitude <= maxLat &&
        position.longitude >= minLng &&
        position.longitude <= maxLng;
  }

  void _openMap(int index) {
    setState(() {
      _selectedIndex = index;
      _currentPosition = locations[index].position;
      _currentLargeMapTitle = locations[index].title;
      _currentLargeMapText = 'Showing map for ${locations[index].title} province with famous spots.';
      _selectedCategory = 'All';
    });

    _updateFilteredMarkers();

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_currentPosition, 11),
    );
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0; // Earth's radius in km
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  void _searchSpots(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      if (query.isEmpty) {
        if (_selectedIndex != null) {
          _filteredSpots = _famousSpots
              .where((spot) => _isSpotInProvince(spot, locations[_selectedIndex!]))
              .toList();
        } else {
          _filteredSpots = _famousSpots;
        }
      } else {
        _filteredSpots = _famousSpots
            .where((spot) =>
        spot.name.toLowerCase().contains(query.toLowerCase()) ||
            spot.description.toLowerCase().contains(query.toLowerCase()) ||
            spot.category.toLowerCase().contains(query.toLowerCase()))
            .where((spot) => _isWithinSaudiArabia(spot.position))
            .toList();
      }
    });
  }

  bool _isSpotInProvince(FamousSpot spot, MapLocation province) {
    if (!_isWithinSaudiArabia(spot.position)) {
      return false;
    }

    final distance = _calculateDistance(
      spot.position.latitude,
      spot.position.longitude,
      province.position.latitude,
      province.position.longitude,
    );
    return distance < 200; // Within 200km radius
  }

  void _updateFilteredMarkers() {
    setState(() {
      _filteredMarkers.clear();

      // Add current location marker if available
      if (_currentUserLocation != null) {
        _filteredMarkers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: _currentUserLocation!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            infoWindow: const InfoWindow(
              title: 'Your Current Location',
              snippet: 'Riyadh, Saudi Arabia',
            ),
          ),
        );
      }

      // Filter famous spots based on category and province
      for (var spot in _famousSpots) {
        if (!_isWithinSaudiArabia(spot.position)) continue;

        // Check if spot is in selected province (if a province is selected)
        if (_selectedIndex != null) {
          if (!_isSpotInProvince(spot, locations[_selectedIndex!])) {
            continue; // Skip spots not in selected province
          }
        }

        // Check category filter
        if (_selectedCategory != 'All') {
          String spotCategory = spot.category.toLowerCase();
          String selectedCategory = _selectedCategory.toLowerCase();

          if (spotCategory != selectedCategory) {
            continue; // Skip spots that don't match the selected category
          }
        }

        // Create marker for the spot
        BitmapDescriptor icon;
        switch (spot.category) {
          case 'historical':
            icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
            break;
          case 'natural':
            icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
            break;
          case 'cultural':
            icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
            break;
          case 'modern':
            icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
            break;
          default:
            icon = BitmapDescriptor.defaultMarker;
        }

        _filteredMarkers.add(
          Marker(
            markerId: MarkerId('spot_${spot.name}'),
            position: spot.position,
            icon: icon,
            infoWindow: InfoWindow(
              title: spot.name,
              snippet: spot.description,
            ),
            onTap: () {
              setState(() {
                _currentPosition = spot.position;
                _currentLargeMapTitle = spot.name;
                _currentLargeMapText = spot.description;
              });
              _mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(spot.position, 15),
              );
            },
          ),
        );
      }
    });
  }

  // when user clicks on historical, cultural etc
  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _updateFilteredMarkers();
  }

  // navigate to the spot (search)
  void _navigateToSpot(FamousSpot spot) {
    setState(() {
      _currentPosition = spot.position;
      _currentLargeMapTitle = spot.name;
      _currentLargeMapText = spot.description;
      _isSearching = false;
      _searchController.clear();
    });

    //smooth zooming
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(spot.position, 15),
    );

    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              _buildBannerSection(),
              const SizedBox(height: 40),
              const Text(
                'Provinces of Saudi Arabia',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 30),
              _buildMapSection(constraints.maxWidth),
              const SizedBox(height: 60),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBannerSection() {
    return Container(
      height: 450,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const NetworkImage(
            'https://static.vecteezy.com/system/resources/previews/008/215/357/non_2x/world-map-landpage-website-template-background-wallpaper-vector.jpg',
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
      ),
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.all(40),
      child: const Text(
        'Maps',
        style: TextStyle(fontSize: 64, color: Colors.white),
      ),
    );
  }

  Widget _buildSmallMap(MapLocation location, int index) {
    return InkWell(
      onTap: () => _openMap(index),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _selectedIndex == index
                ? const Color(0xFFD87848)
                : const Color(0xFFCCCCCC),
            width: _selectedIndex == index ? 3 : 1,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                initialCameraPosition:
                CameraPosition(target: location.position, zoom: 10),
                liteModeEnabled: true,
                zoomControlsEnabled: false,
                scrollGesturesEnabled: false,
                markers: {
                  Marker(
                    markerId: MarkerId(location.title),
                    position: location.position,
                  ),
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                location.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search famous spots...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF555555)),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear, color: Color(0xFF555555)),
                onPressed: () {
                  _searchController.clear();
                  _searchSpots('');
                },
              )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            onChanged: _searchSpots,
          ),
          if (_isSearching && _filteredSpots.isNotEmpty)
            Container(
              constraints: const BoxConstraints(
                maxHeight: 150,
              ),
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: _filteredSpots.length,
                itemBuilder: (context, index) {
                  final spot = _filteredSpots[index];
                  return ListTile(
                    leading: Icon(
                      _getCategoryIcon(spot.category),
                      color: _getCategoryColor(spot.category),
                    ),
                    title: Text(spot.name),
                    subtitle: Text(
                      spot.description,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Color(0xFF555555)),
                    onTap: () => _navigateToSpot(spot),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLargeMapContainer() {
    return Container(
      height: 550,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Map title and info
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentLargeMapTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF333333),
                  ),
                ),
                Text(
                  _currentLargeMapText,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF555555),
                  ),
                ),
              ],
            ),
          ),

          // Search bar
          _buildSearchBar(),
          const SizedBox(height: 8),

          // Category filters
          Container(
            constraints: const BoxConstraints(
              maxHeight: 60,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: ['All', 'Historical', 'Natural', 'Cultural', 'Modern'].map((category) {
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        selectedColor: const Color(0xFFD87848).withOpacity(0.2),
                        checkmarkColor: const Color(0xFFD87848),
                        backgroundColor: Colors.white,
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: isSelected ? const Color(0xFFD87848) : Colors.grey.shade300,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        labelStyle: TextStyle(
                          color: isSelected ? const Color(0xFFD87848) : const Color(0xFF333333),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                        onSelected: (selected) => _filterByCategory(category),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Legend
          Container(
            height: 40,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    _buildLegendItem('Your Location', BitmapDescriptor.hueAzure),
                    const SizedBox(width: 12),
                    _buildLegendItem('Historical', BitmapDescriptor.hueOrange),
                    const SizedBox(width: 12),
                    _buildLegendItem('Natural', BitmapDescriptor.hueGreen),
                    const SizedBox(width: 12),
                    _buildLegendItem('Cultural', BitmapDescriptor.hueViolet),
                    const SizedBox(width: 12),
                    _buildLegendItem('Modern', BitmapDescriptor.hueBlue),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Map
          Expanded(
            child: GoogleMap(
              initialCameraPosition:
              CameraPosition(target: _currentPosition, zoom: 6),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              markers: _filteredMarkers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              compassEnabled: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, double hue) {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          color: _hueToColor(hue),
          size: 20,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF333333)),
        ),
      ],
    );
  }

  Color _hueToColor(double hue) {
    switch (hue.toInt()) {
      case BitmapDescriptor.hueAzure:
        return Colors.blue;
      case BitmapDescriptor.hueOrange:
        return Colors.orange;
      case BitmapDescriptor.hueGreen:
        return Colors.green;
      case BitmapDescriptor.hueViolet:
        return Colors.purple;
      case BitmapDescriptor.hueBlue:
        return Colors.blueAccent;
      default:
        return Colors.red;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'historical':
        return Icons.history;
      case 'natural':
        return Icons.landscape;
      case 'cultural':
        return Icons.museum;
      case 'modern':
        return Icons.apartment;
      default:
        return Icons.place;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'historical':
        return Colors.orange;
      case 'natural':
        return Colors.green;
      case 'cultural':
        return Colors.purple;
      case 'modern':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildMapSection(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: screenWidth > 700
          ? Row(
        children: [
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.9,
              ),
              itemCount: locations.length,
              itemBuilder: (context, i) => _buildSmallMap(locations[i], i),
            ),
          ),
          const SizedBox(width: 30),
          Expanded(flex: 2, child: _buildLargeMapContainer()),
        ],
      )
          : Column(
        children: [
          _buildLargeMapContainer(),
          const SizedBox(height: 30),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.9,
            ),
            itemCount: locations.length,
            itemBuilder: (context, i) => _buildSmallMap(locations[i], i),
          ),
        ],
      ),
    );
  }
}