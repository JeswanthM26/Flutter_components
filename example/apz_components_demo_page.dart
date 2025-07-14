import 'package:flutter/material.dart';
import 'package:apz_flutter_components/components/appz_input_field/appz_input_field.dart';
import 'package:apz_flutter_components/components/appz_dropdown_field/appz_dropdown_field.dart';
import 'package:apz_flutter_components/components/apz_button/appz_button.dart';
import 'package:apz_flutter_components/components/appz_progress_bar/appz_progress_bar.dart';
import 'package:apz_flutter_components/components/apz_file_upload/apz_file_upload.dart';
import 'package:apz_flutter_components/apz_date_picker_field.dart';
import 'package:apz_flutter_components/apz_phone_input_with_dropdown.dart';
import 'package:apz_flutter_components/components/appz_input_field/appz_input_field_enums.dart';
import 'package:apz_flutter_components/components/appz_input_field/appz_input_field_theme.dart';
import 'package:apz_flutter_components/components/appz_input_field/appz_input_style_config.dart';
import 'package:apz_flutter_components/components/appz_dropdown_field/dropdown_style_config.dart';
import 'package:apz_flutter_components/components/apz_button/button_style_config.dart';
import 'package:apz_flutter_components/components/appz_progress_bar/progress_bar_style_config.dart';
import 'package:apz_flutter_components/common/ui_config_resolver.dart';
import 'package:file_picker/file_picker.dart';

class ApzComponentsDemoPage extends StatefulWidget {
  const ApzComponentsDemoPage({super.key});

  @override
  State<ApzComponentsDemoPage> createState() => _ApzComponentsDemoPageState();
}

class _ApzComponentsDemoPageState extends State<ApzComponentsDemoPage> {
  bool _loading = true;
  String? _error;
  final _inputController = TextEditingController();
  final _dropdownController = ValueNotifier<String?>(null);
  PlatformFile? _selectedFile;
  DateTime? _selectedDate;
  String? _phoneValue;

  @override
  void initState() {
    super.initState();
    _loadConfigs();
  }

  Future<void> _loadConfigs() async {
    try {
      final resolver = await UIConfigResolver.loadMaster('assets/json/master_theme.json');
      final dropdownConfig = await resolver.loadAndResolve('assets/json/dropdown_ui_config.json');
      final inputConfig = await resolver.loadAndResolve('assets/json/input_ui_config.json');
      final progressBarConfig = await resolver.loadAndResolve('assets/json/progress_bar_ui_config.json');
      final buttonConfig = await resolver.loadAndResolve('assets/json/button_ui_config.json');
      await DropdownStyleConfig.instance.loadFromResolved(dropdownConfig);
      await AppzStyleConfig.instance.loadFromResolved(inputConfig);
      await ProgressBarStyleConfig.instance.loadFromResolved(progressBarConfig);
      await ButtonStyleConfig.instance.loadFromResolved(buttonConfig);
      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        body: Center(child: Text('Error loading configs: $_error')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('APZ Components Demo (JSON-driven)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Input Fields', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            // Default Field
            const Text('Default'),
            AppzInputField(
              label: 'Full Name',
              hintText: 'Please enter your name here',
              controller: _inputController,
              fieldType: AppzFieldType.defaultType,
            ),

            // Disabled Field
            const Text('Disabled'),
            AppzInputField(
              label: 'Disabled Name',
              hintText: 'This field is disabled',
              controller: _inputController,
              fieldType: AppzFieldType.defaultType,
              initialFieldState: AppzFieldState.disabled,
            ),

            // Mobile Input Field
            const Text('Mobile Number'),
            AppzInputField(
              label: 'Mobile Number',
              hintText: 'Enter 10-digit number',
              fieldType: AppzFieldType.mobile,
              validationType: AppzInputValidationType.mandatory,
            ),

            // Aadhaar Input Field
            const Text('Aadhaar Number'),
            AppzInputField(
              label: 'Aadhaar Number',
              hintText: 'Enter 12-digit Aadhaar number',
              fieldType: AppzFieldType.aadhaar,
              validationType: AppzInputValidationType.mandatory,
            ),

            // MPIN Input Field
            const Text('MPIN'),
            AppzInputField(
              label: 'Enter MPIN',
              hintText: '●●●●',
              fieldType: AppzFieldType.mpin,
              obscureText: false,
              mpinLength: 6,
              validationType: AppzInputValidationType.mandatory,
            ),

            // Text Description Field
            const Text('Text Description'),
            AppzInputField(
              label: 'About You',
              hintText: 'Enter a short description...',
              fieldType: AppzFieldType.textDescription,
            ),

            const Text('File Upload', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ApzUploadFileWidget(
              currentStyle: AppzStyleConfig.instance.getStyleForState(AppzFieldState.defaultState),
              isEnabled: true,
              labelText: 'Upload Document',
              hintText: 'Click to upload the document',
              allowedExtensionsDescription: 'SVG, PNG, JPG or PDF',
              allowedExtensions: const ['pdf', 'svg', 'png', 'jpg'],
              onFileSelected: (file) => setState(() => _selectedFile = file),
              validationType: AppzInputValidationType.mandatory,
              selectedFile: _selectedFile,
              maxSizeInKB: 2048,
            ),
            const SizedBox(height: 24),

            const Text('Dropdown Field', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            AppzDropdownField(
              label: 'Select Option',
              items: const ['Option 1', 'Option 2', 'Option 3'],
              selectedItem: _dropdownController.value,
              onChanged: (val) => setState(() => _dropdownController.value = val),
              controller: _dropdownController,
              isMandatory: true,
            ),
            const SizedBox(height: 24),

            const Text('Button', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Row(
              children: [
                AppzButton(
                  label: 'Primary',
                  appearance: AppzButtonAppearance.primary,
                  size: AppzButtonSize.large,
                  onPressed: () {},
                ),
                const SizedBox(width: 24),
                AppzButton(
                  label: 'Secondary',
                  appearance: AppzButtonAppearance.secondary,
                  onPressed: () {},
                ),
                const SizedBox(width: 24),
                AppzButton(
                  label: 'Disabled',
                  disabled: true,
                ),
              ],
            ),
            const SizedBox(height: 24),

            const Text('Progress Bar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            AppzProgressBar(
              percentage: 65,
              labelPosition: ProgressBarLabelPosition.right,
              labelText: 'Progress',
            ),
            const SizedBox(height: 24),

            

            const Text('Date Picker', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ApzDatePickerField(
              label: 'Select Date',
              selectedDate: _selectedDate,
              onDateSelected: (date) => setState(() => _selectedDate = date),
              isMandatory: true,
            ),
            const SizedBox(height: 24),

            const Text('Phone Input with Dropdown', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ApzPhoneInputWithDropdown(
              label: 'Phone Number',
              initialPhoneCode: '91',
              isMandatory: true,
              onChanged: (val) => setState(() => _phoneValue = val),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
} 