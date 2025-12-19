import 'package:cours_work/navigation/app_routes.dart';
import 'package:cours_work/presentation/home/home_page.dart';
import 'package:cours_work/presentation/home/widgets/custom_bottom_nav_bar.dart';
import 'package:cours_work/presentation/profile/profile_page.dart';
import 'package:flutter/material.dart';

class NavigationRoot extends StatefulWidget {
  const NavigationRoot({super.key});

  @override
  State<NavigationRoot> createState() => _NavigationRootState();
}

class _NavigationRootState extends State<NavigationRoot> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [const HomePage(), const SizedBox(), const ProfilePage()];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _currentIndex,
        onTap: (i) {
          if (i == 1) {
            Navigator.pushNamed(context, AppRoutes.quiz);
            return;
          }
          setState(() => _currentIndex = i);
        },
      ),
    );
  }
}
