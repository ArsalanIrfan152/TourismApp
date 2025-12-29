import 'package:flutter/material.dart';
import 'app_navigation.dart';
import 'app_drawer.dart';
import 'app_footer.dart';

class AppLayout extends StatelessWidget {
  final Widget body;

  const AppLayout({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      endDrawer: isMobile ? const AppDrawer() : null,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppNavigation(isMobile: isMobile),
            body,
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}
