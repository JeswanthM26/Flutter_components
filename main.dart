import 'example/appz_progress_bar_example.dart';
import 'package:apz_flutter_components/components/appz_progress_bar/progress_bar_style_config.dart';
import 'package:flutter/material.dart';
import 'lib/components/appz_dropdown_field/dropdown_style_config.dart';
import 'lib/components/appz_input_field/appz_input_style_config.dart';
import 'lib/common/ui_config_resolver.dart';

Future<void> main() async {
  // Ensure that widget binding is initialized before calling native code.
  WidgetsFlutterBinding.ensureInitialized();

  final resolver = await UIConfigResolver.loadMaster('assets/json/master_theme.json');

  final dropdownConfig = await resolver.loadAndResolve('assets/json/dropdown_ui_config.json');
  final inputConfig = await resolver.loadAndResolve('assets/json/input_ui_config.json');
  final progressBarConfig = await resolver.loadAndResolve('assets/json/progress_bar_ui_config.json');

  await DropdownStyleConfig.instance.loadFromResolved(dropdownConfig);
  await AppzStyleConfig.instance.loadFromResolved(inputConfig);
  await ProgressBarStyleConfig.instance.loadFromResolved(progressBarConfig);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppzInputField Demo V2',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const ExamplePg(),
      debugShowCheckedModeBanner: false, // Optional: to hide the debug banner
    );
  }
}
