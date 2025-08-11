// import 'package:flutter/material.dart';
// import '../lib/components/appz_loader/appz_loader.dart';
// import '../lib/components/appz_text/appz_text.dart';

// class AppzLoaderExample extends StatelessWidget {
//   const AppzLoaderExample({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('AppzLoader Example')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             AppzLoader(
//               assetPath: 'assets/loader/hourglass_loading.gif',
//               height: 100,
//               width: 100,
//               label: AppzText(
//                 'Loading from asset...',
//                 category: 'label',
//                 fontWeight: 'bold',
//                 color: Colors.red,
//               ),
//             ),
//             const SizedBox(height: 20),
//             AppzLoader(
//               imageUrl: 'https://media.giphy.com/media/y1ZBcOGOOtlpC/giphy.gif',
//               label: AppzText(
//                 'Loading from network...',
//                 category: 'label',
//                 fontWeight: 'regular',
//                 color: Colors.blue,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:apz_flutter_components/components/appz_loader/appz_loader.dart';
import 'package:flutter/material.dart';
// Make sure these imports match your project structure
import '../lib/components/apz_button/appz_button.dart';

class AppzLoaderExample extends StatelessWidget {
  const AppzLoaderExample({super.key});

// for changing the size and path of the loader
  // add  the following lines to main.dart and customize the loader
  /// Initialize the loader with custom settings if needed.
  // AppzLoader.init(
  //   size: 300.0,
  //   // customLoaderPath: 'assets/loaders/your_new_loader.gif' // Your custom path
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appz Loader Example'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppzButton(
                label: 'Show Loader (5s)',
                size: AppzButtonSize.large,
                appearance: AppzButtonAppearance.secondary,
                onPressed: () {
                  AppzLoader.startLoader(context);
                  Future.delayed(const Duration(seconds: 5), () {
                    AppzLoader.stopLoader();
                  });
                },
              ),
              const SizedBox(height: 16),
              AppzButton(
                label: 'Stop Loader',
                appearance: AppzButtonAppearance.secondary,
                onPressed: () {
                  AppzLoader.stopLoader();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
