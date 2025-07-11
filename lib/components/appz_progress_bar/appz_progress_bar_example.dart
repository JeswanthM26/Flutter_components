import 'package:flutter/material.dart';
import 'appz_progress_bar.dart';

/// Example for the AppzProgressBar component demonstrating dynamic usage patterns
class AppzProgressBarTest extends StatefulWidget {
  const AppzProgressBarTest({super.key});

  @override
  State<AppzProgressBarTest> createState() => _AppzProgressBarTestState();
}

class _AppzProgressBarTestState extends State<AppzProgressBarTest> {
  double _progress = 50.0;

  void _increaseProgress() {
    setState(() {
      _progress = (_progress + 10).clamp(0, 100);
    });
  }

  void _decreaseProgress() {
    setState(() {
      _progress = (_progress - 10).clamp(0, 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progress Bar Test - Dynamic Demo',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _decreaseProgress,
                  child: const Text('Decrease Progress'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _increaseProgress,
                  child: const Text('Increase Progress'),
                ),
                const SizedBox(width: 16),
                Text('${_progress.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')),
              ],
            ),
            const SizedBox(height: 30),
            
            // All progress bars displayed horizontally in a single row
            const Text('All Progress Bar Variants:', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Inter')),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // No Label
                  Container(
                    width: 220,
                    margin: const EdgeInsets.only(right: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Without Label', style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                        const SizedBox(height: 42),
                        AppzProgressBar(
                          percentage: _progress,
                          labelPosition: ProgressBarLabelPosition.none,
                        ),
                      ],
                    ),
                  ),
                  // Right Label
                  Container(
                    width: 220,
                    margin: const EdgeInsets.only(right: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('With Label', style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                        const SizedBox(height: 38),
                        AppzProgressBar(
                          percentage: _progress,
                          labelPosition: ProgressBarLabelPosition.right,
                          showPercentage: true,
                        ),
                      ],
                    ),
                  ),
                  // Bottom Label
                  Container(
                    width: 220,
                    margin: const EdgeInsets.only(right: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('With Bottom Label', style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                        const SizedBox(height: 42),
                        AppzProgressBar(
                          percentage: _progress,
                          labelPosition: ProgressBarLabelPosition.bottom,
                        ),
                      ],
                    ),
                  ),
                  // Top Floating Label
                  Container(
                    width: 220,
                    margin: const EdgeInsets.only(right: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('With Top Floating Label', style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                        const SizedBox(height: 11),
                        AppzProgressBar(
                          percentage: _progress,
                          labelPosition: ProgressBarLabelPosition.topFloating,
                        ),
                      ],
                    ),
                  ),
                  // Bottom Floating Label
                  Container(
                    width: 220,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('With Bottom Floating Label', style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                        const SizedBox(height: 42),
                        AppzProgressBar(
                          percentage: _progress,
                          labelPosition: ProgressBarLabelPosition.bottomFloating,
                          showPercentage: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
} 