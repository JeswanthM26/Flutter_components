import 'package:flutter/material.dart';
import 'package:apz_flutter_components/components/appz_toggle/appz_toggle.dart';

class AppzToggleExample extends StatefulWidget {
  const AppzToggleExample({Key? key}) : super(key: key);

  @override
  State<AppzToggleExample> createState() => _AppzToggleExampleState();
}

class _AppzToggleExampleState extends State<AppzToggleExample> {
  bool on1 = false;
  bool on2 = true;
  bool on3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppzToggle Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Default (off, large)'),
            AppzToggleSwitch(
              label: 'Label',
              subtitle: 'Subtitle',
              onTap: () {},
            ),
            const SizedBox(height: 24),
            const Text('Secondary Appearance'),
            const SizedBox(height: 8),
            AppzToggleSwitch(
              label: 'Label',
              subtitle: 'Subtitle',
              appearance: AppzToggleAppearance.secondary,
              onTap: () {},
            ),
            const SizedBox(height: 24),
            const Text('Tertiary Appearance'),
            const SizedBox(height: 8),
            AppzToggleSwitch(
              label: 'Label',
              subtitle: 'Subtitle',
              appearance: AppzToggleAppearance.tertiary,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
} 