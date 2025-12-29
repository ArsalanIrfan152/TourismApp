import 'package:flutter/material.dart';
import '../main.dart';
import '../pages/Home.dart';
import '../pages/Destination.dart';
import '../pages/Thingstodo.dart';
import '../pages/Planyourtrip.dart';
import '../pages/Map.dart';
import '../pages/BookNow.dart';
import '../pages/Profile.dart';
import '../pages/Settings.dart';

class AppNavigation extends StatelessWidget {
  final bool isMobile;
  const AppNavigation({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final navItems = [
      {'title': 'Home', 'page': const MainHomePage()},
      {'title': 'Destinations', 'page': const DestinationPage()},
      {'title': 'Things to Do', 'page': const ThingsToDoPage()},
      {'title': 'Plan your Trip', 'page': const PlanYourTripPage()},
      {'title': 'Map', 'page': const MapsPage()},
      {'title': 'Settings', 'page': const SettingsPage()},
      {'title': 'Profile', 'page': const ProfilePage()},
    ];

    return Container(
      color: AppColors.secondaryBackgroundDark,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/images/logo.png', height: 40),

          if (!isMobile)
            Row(
              children: navItems.map((item) {
                return TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => item['page'] as Widget),
                    );
                  },
                  child: Text(
                    item['title'] as String,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            ),

          if (!isMobile)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BookingFormPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentOrange,
              ),
              child: const Text('Book Now'),
            ),

          if (isMobile)
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ),
        ],
      ),
    );
  }
}
