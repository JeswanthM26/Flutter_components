import 'package:flutter/material.dart';
import 'lib/components/appz_dropdown_field/dropdown_style_config.dart';
import 'lib/components/appz_input_field/appz_input_style_config.dart';
import 'example/appz_input_field_example_page.dart';
import 'lib/common/ui_config_resolver.dart';

Future<void> main() async {
  // Ensure that widget binding is initialized before calling native code.
  WidgetsFlutterBinding.ensureInitialized();

  // Load the UI configuration
  // It's important to await this before runApp so styles are ready.
  //await AppzStyleConfig.instance.load('assets/ui_config.json');
  //await AppzStyleConfig.instance.load('assets/input_ui_config.json');
  final resolver = await UIConfigResolver.loadMaster('assets/json/master_theme.json');

  final dropdownConfig = await resolver.loadAndResolve('assets/json/dropdown_ui_config.json');
  final inputConfig = await resolver.loadAndResolve('assets/json/input_ui_config.json');

  await DropdownStyleConfig.instance.loadFromResolved(dropdownConfig);
  await AppzStyleConfig.instance.loadFromResolved(inputConfig);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppzInputField Demo V2',
      theme: ThemeData(
        // You might want to define some base app theme properties here.
        // For now, AppzInputField is self-contained with its styling via JSON.
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AppzInputFieldExamplePage(),
      debugShowCheckedModeBanner: false, // Optional: to hide the debug banner
    );
  }
}
