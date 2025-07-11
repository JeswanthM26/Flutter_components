import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

enum ApzFieldAppearance { primary, secondary }

class ApzInputField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool enabled;
  final bool isEmailFld;
  final bool isAmount;
  final bool allowAllCaps;
  final bool isMandatory;
  final bool onlyNumbers;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onTap;
  final void Function()? onEditingComplete;
  final int? maxLength;
  final int maxLines;
  final ApzFieldAppearance appearance;

  const ApzInputField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.enabled = true,
    this.isEmailFld = false,
    this.isAmount = false,
    this.allowAllCaps = false,
    this.isMandatory = false,
    this.onlyNumbers = false,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.onEditingComplete,
    this.maxLength,
    this.maxLines = 1,
    this.appearance = ApzFieldAppearance.primary,
  });

  String? _validate(String? value) {
    if (validator != null) return validator!(value);

    if (isMandatory && (value == null || value.trim().isEmpty)) {
      return 'This field is required';
    }

    if (isEmailFld) {
      final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
      if (value == null || value.trim().isEmpty) return 'Email is required';
      if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    }

    return null;
  }

  List<TextInputFormatter> _buildInputFormatters() {
    final formatters = <TextInputFormatter>[];

    if (isAmount) {
      formatters.add(FilteringTextInputFormatter.digitsOnly);
      formatters.add(_ThousandsSeparatorInputFormatter());
    } else if (onlyNumbers) {
      formatters.add(FilteringTextInputFormatter.digitsOnly);
    }

    if (allowAllCaps) {
      formatters.add(UpperCaseTextFormatter());
    }

    return formatters;
  }

  Widget _buildLabel() {
    return RichText(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black,
        ),
        children: isMandatory
            ? [
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]
            : [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textFormField = TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: isAmount || onlyNumbers ? TextInputType.number : keyboardType,
      validator: _validate,
      enabled: enabled,
      inputFormatters: _buildInputFormatters(),
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      onEditingComplete: onEditingComplete,
      maxLength: maxLength,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText ?? '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
      ),
    );

    return appearance == ApzFieldAppearance.primary
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel(),
              const SizedBox(height: 8),
              textFormField, 
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 12),
                alignment: Alignment.centerLeft,
                child: _buildLabel(),
              ),
              Flexible(
                child: textFormField,
              ),
            ],
          );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.decimalPattern();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String numericText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    String formatted = _formatter.format(int.tryParse(numericText) ?? 0);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
