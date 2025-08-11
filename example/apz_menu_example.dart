import 'package:flutter/material.dart';
import '../lib/components/apz_menu/apz_menu.dart';
import '../lib/components/apz_button/appz_button.dart';

class ApzMenuExample extends StatefulWidget {
  const ApzMenuExample({super.key});

  @override
  State<ApzMenuExample> createState() => _ApzMenuExampleState();
}

class _ApzMenuExampleState extends State<ApzMenuExample> {
  late final List<MenuItem> _menuItems;

  @override
  void initState() {
    super.initState();
    _menuItems = [
      const MenuItem(text: 'My performance'),
      const MenuItem(text: 'Certifications'),
      const MenuItem(text: 'Training Hub'),
      const MenuItem(text: 'Contacts'),
      const MenuItem(text: 'Settings'),
      const MenuItem(text: 'Help'),
      const MenuItem(text: 'Feedback'),
      const MenuItem(text: 'About'),
      const MenuItem(text: 'Privacy Policy'),
      const MenuItem(text: 'Terms of Service'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ApzMenu Example'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Position the menu button
          Positioned(
            // top: 30,
            bottom: 30,
            right: 30,
            child: ApzMenu(
              items: _menuItems,
              position: ApzMenuPosition.top,
              onMenuItemTap: (text) {
                print('$text tapped');
              },
              signOutText: 'Sign out',
              onSignOut: () {
                print('Sign out tapped');
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  'Show Menu (Top)',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
