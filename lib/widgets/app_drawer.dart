import 'package:flutter/material.dart';
import '../main.dart';
import '../pages/Home.dart';
import '../pages/Destination.dart';
import '../pages/Thingstodo.dart';
import '../pages/Planyourtrip.dart';
import '../pages/Map.dart';
import '../pages/Profile.dart';
import '../pages/Settings.dart';
import '../pages/BookNow.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.secondaryBackgroundDark,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Image.asset('assets/images/logo.png', height: 50),

          const SizedBox(height: 20),

          _item(context, 'Home', const MainHomePage()),
          _item(context, 'Destinations', const DestinationPage()),
          _item(context, 'Things to Do', const ThingsToDoPage()),
          _item(context, 'Plan your Trip', const PlanYourTripPage()),
          _item(context, 'Map', const MapsPage()),
          _item(context, 'Settings', const SettingsPage()),
          _item(context, 'Profile', const ProfilePage()),

          const SizedBox(height: 25),

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
            child: const Text(
              "BOOK NOW",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }
}
