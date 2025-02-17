import 'package:dating_app/models/profile_model.dart';
import 'package:dating_app/presentation/profile/personal_profile_screen.dart';
import 'package:dating_app/presentation/home/home_screen.dart';
import 'package:dating_app/themes/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class BottomBar extends StatefulWidget {
  final Profile? profile;
  const BottomBar({
    super.key,
    required this.profile,
  });

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = [
      const HomeScreen(),
      const Text("Love List"),
      const Text("Chat"),
      const PersonalProfileScreen(),
    ];
    return Scaffold(
      backgroundColor: AppTheme.colors.bgColor,
      body: Center(child: widgetOptions[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          elevation: 10,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: const Color(0xFF526480),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(IconlyLight.home),
                activeIcon: Icon(IconlyBold.home),
                label: "Task"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.heart),
                activeIcon: Icon(CupertinoIcons.heart_fill),
                label: "Task"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.chat_bubble_text),
                activeIcon: Icon(CupertinoIcons.chat_bubble_text_fill),
                label: "Task"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person),
                activeIcon: Icon(CupertinoIcons.person_fill),
                label: "Profile")
          ]),
    );
  }
}
