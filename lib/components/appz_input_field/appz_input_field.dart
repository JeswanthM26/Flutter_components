import 'package:apz_flutter_components/components/appz_custom_datepicker/apz_custom_datepicker.dart';
import 'package:apz_flutter_components/components/appz_custom_datepicker/custom_date_picker_params.dart';
import 'package:apz_flutter_components/components/appz_input_field/appz_input_field_theme.dart';
// import 'package:apz_flutter_components/components/apz_input_field/appz_input_field_theme.dart';
import 'package:flutter/material.dart';
// import 'package:apz_flutter_components/components/apz_custom_datepicker/custom_date_picker_params.dart' show SelectionType;
// import 'package:apz_flutter_components/components/apz_custom_datepicker/apz_custom_datepicker.dart';
import 'appz_input_field_enums.dart';
import 'appz_input_style_config.dart';
import 'field_types/aadhaar_input_widget.dart';
import 'field_types/mpin_input_widget.dart';
import 'field_types/mobile_input_widget.dart';

class AppzInputField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final AppzFieldType fieldType;
  final AppzFieldState initialFieldState;
  final String? initialValue;
  final AppzInputValidationType validationType;

  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;

  final bool obscureText;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final int mpinLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String mobileCountryCode;
  final bool mobileCountryCodeEditable;
  
  // Date Picker specific fields
  final dynamic minDate;
  final dynamic maxDate;
  final dynamic initialDate;
  final SelectionType selectionType;
  final String? dateFormat;
  final ValueChanged<String>? onDateSelected;
  final ValueChanged<List<String>>? onRangeSelected;

  const AppzInputField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.fieldType = AppzFieldType.defaultType,
    this.initialFieldState = AppzFieldState.defaultState,
    this.initialValue,
    this.validationType = AppzInputValidationType.none,
    this.focusNode,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.validator,
    this.obscureText = false,
    this.textInputAction,
    this.maxLength,
    this.mpinLength = 4,
    this.prefixIcon,
    this.suffixIcon,
    this.mobileCountryCode = "+91",
    this.mobileCountryCodeEditable = false,
    // Date Picker specific fields
    this.minDate,
    this.maxDate,
    this.initialDate,
    this.selectionType = SelectionType.single,
    this.dateFormat,
    this.onDateSelected,
    this.onRangeSelected,
  });

  @override
  State<AppzInputField> createState() => _AppzInputFieldState();
}

class _AppzInputFieldState extends State<AppzInputField> {
  late TextEditingController _internalController;
  late FocusNode _internalFocusNode;
  AppzFieldState _currentFieldState = AppzFieldState.defaultState;
  String? _validationErrorMessage;

  late List<TextEditingController> _mpinSegmentControllers;
  late List<FocusNode> _mpinSegmentFocusNodes;

  final ApzCustomDatepicker _datepicker = ApzCustomDatepicker();
  late bool _isTextObscured;

  bool get _isEffectivelyDisabled => _currentFieldState == AppzFieldState.disabled;
  bool get _hasError => _currentFieldState == AppzFieldState.error;
  bool get _isFocused => _currentFieldState == AppzFieldState.focused;
  bool get _isFilled => _internalController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _isTextObscured = widget.obscureText;
    _internalController = widget.controller ?? TextEditingController(text: widget.initialValue);
    _internalFocusNode = widget.focusNode ?? FocusNode();
    _currentFieldState = widget.initialFieldState;

    _internalFocusNode.addListener(_handleFocusChange);
    _internalController.addListener(_handleTextChange);

    _updateFilledState();
    if (widget.initialFieldState == AppzFieldState.disabled) {
      _currentFieldState = AppzFieldState.disabled;
    }
    _initializeMpinFields();
    _initializeDatePickerField();
  }

  void _initializeDatePickerField() {
    if (widget.fieldType == AppzFieldType.datepicker) {
      final initialDate = _parseDate(widget.initialDate);
      if (initialDate != null) {
        _internalController.text = _datepicker.formatDate(
          initialDate,
          widget.dateFormat ?? 'dd/MM/yyyy',
        );
      }
    }
  }

  DateTime? _parseDate(dynamic date) {
    if (date == null) return null;
    if (date is DateTime) return date;
    if (date is String) return DateTime.tryParse(date);
    return null;
  }

  Future<void> _showDatePicker() async {
    FocusScope.of(context).requestFocus(FocusNode()); // Hide keyboard

    final minDate = _parseDate(widget.minDate);
    final maxDate = _parseDate(widget.maxDate);
    final initialDate = _parseDate(widget.initialDate);

    if (minDate == null || maxDate == null) {
      // Or handle this error more gracefully
      throw ArgumentError("minDate and maxDate must be provided for datepicker");
    }

    final params = CustomDatePickerParams(
      context: context,
      minDate: minDate,
      maxDate: maxDate,
      // initialDate: initialDate ?? DateTime.now(),
      initialDate: initialDate,
      selectionType: widget.selectionType,
      dateFormat: widget.dateFormat,
    );

    final List<String?>? result = await _datepicker.showCustomDate(params);

    if (result != null && result.isNotEmpty) {
      final validDates = result.whereType<String>().toList();
      if (widget.selectionType == SelectionType.single) {
        if (validDates.isNotEmpty) {
          final selectedDate = validDates.first;
          _internalController.text = selectedDate;
          widget.onDateSelected?.call(selectedDate);
        }
      } else {
        if (validDates.length >= 1) {
          _internalController.text = validDates.join(' to ');
          widget.onRangeSelected?.call(validDates);
        }
      }
    }
  }

  void _initializeMpinFields() {
    if (widget.fieldType == AppzFieldType.mpin) {
      _mpinSegmentControllers = List.generate(widget.mpinLength, (index) => TextEditingController());
      _mpinSegmentFocusNodes = List.generate(widget.mpinLength, (index) => FocusNode());
      for (int i = 0; i < widget.mpinLength; i++) {
        _mpinSegmentControllers[i].addListener(() => _onMpinSegmentChanged(i));
      }
    } else {
      _mpinSegmentControllers = [];
      _mpinSegmentFocusNodes = [];
    }
  }

  void _disposeMpinFields() {
    if (_mpinSegmentControllers.isNotEmpty) {
      for (var controller in _mpinSegmentControllers) {
        controller.dispose();
      }
      for (var focusNode in _mpinSegmentFocusNodes) {
        focusNode.dispose();
      }
    }
  }

  void _onMpinSegmentChanged(int segmentIndex) {
    final mpinValue = _mpinSegmentControllers.map((c) => c.text).join();
    if (_internalController.text != mpinValue) {
      _internalController.text = mpinValue;
    }
  }

  @override
  void didUpdateWidget(covariant AppzInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _internalController.removeListener(_handleTextChange);
      _internalController = widget.controller ?? TextEditingController(text: widget.initialValue ?? _internalController.text);
      _internalController.addListener(_handleTextChange);
    }
    if (widget.focusNode != oldWidget.focusNode) {
      _internalFocusNode.removeListener(_handleFocusChange);
      _internalFocusNode = widget.focusNode ?? FocusNode();
      _internalFocusNode.addListener(_handleFocusChange);
    }
    if (widget.initialFieldState != oldWidget.initialFieldState && widget.initialFieldState != _currentFieldState) {
      if (widget.initialFieldState == AppzFieldState.disabled || widget.initialFieldState == AppzFieldState.error) {
        _updateState(widget.initialFieldState);
      }
    }
    if (widget.initialValue != oldWidget.initialValue && widget.controller == null) {
      _internalController.text = widget.initialValue ?? '';
    }
    if (widget.obscureText != oldWidget.obscureText) {
      _isTextObscured = widget.obscureText;
    }
    if (widget.fieldType == AppzFieldType.mpin &&
        (oldWidget.fieldType != AppzFieldType.mpin || widget.mpinLength != oldWidget.mpinLength)) {
      _disposeMpinFields();
      _initializeMpinFields();
    } else if (widget.fieldType != AppzFieldType.mpin && oldWidget.fieldType == AppzFieldType.mpin) {
      _disposeMpinFields();
      _mpinSegmentControllers = [];
      _mpinSegmentFocusNodes = [];
    }
  }

  void _handleFocusChange() {
    if (_isEffectivelyDisabled) return;
    if (_internalFocusNode.hasFocus) {
      _updateState(AppzFieldState.focused);
    } else {
      if (!_hasError) {
        _updateState(_isFilled ? AppzFieldState.filled : AppzFieldState.defaultState);
      }
    }
  }

  void _handleTextChange() {
    if (_isEffectivelyDisabled) return;
    widget.onChanged?.call(_internalController.text);
    _updateFilledState();
  }

  void _updateFilledState() {
    if (_isEffectivelyDisabled || _isFocused || _hasError) {
      return;
    }
    final bool hasText = _internalController.text.isNotEmpty;
    if (hasText && _currentFieldState != AppzFieldState.filled) {
      _updateState(AppzFieldState.filled);
    } else if (!hasText && _currentFieldState == AppzFieldState.filled) {
      _updateState(AppzFieldState.defaultState);
    }
  }

  void _updateState(AppzFieldState newState, {String? errorMessage}) {
    if (_currentFieldState != newState || _validationErrorMessage != errorMessage) {
      if (mounted) {
        setState(() {
          _currentFieldState = newState;
          _validationErrorMessage = (newState == AppzFieldState.error) ? errorMessage : null;
        });
      }
    }
  }

  String? _performValidation(String? value) {
    String? validationError;

    if (widget.fieldType == AppzFieldType.mobile ||
        widget.fieldType == AppzFieldType.mpin ||
        widget.fieldType == AppzFieldType.aadhaar ||
        widget.fieldType == AppzFieldType.datepicker) {
      return null;
    }

    final val = value ?? '';

    if (widget.validationType == AppzInputValidationType.mandatory && val.isEmpty) {
      validationError = 'This field is required.';
    }

    if (validationError == null) {
      switch (widget.validationType) {
        case AppzInputValidationType.email:
          if (val.isNotEmpty && !RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(val)) {
            validationError = 'Enter a valid email address.';
          }
          break;
        case AppzInputValidationType.numeric:
          if (val.isNotEmpty && !RegExp(r'^\d+$').hasMatch(val)) {
            validationError = 'Only numbers allowed.';
          }
          break;
        default:
          break;
      }
    }

    return validationError;
  }

  @override
  void dispose() {
    _internalFocusNode.removeListener(_handleFocusChange);
    _internalController.removeListener(_handleTextChange);
    if (widget.controller == null) _internalController.dispose();
    if (widget.focusNode == null) _internalFocusNode.dispose();
    _disposeMpinFields();
    super.dispose();
  }

  TextStyle _getTextStyleForField(AppzStateStyle style) {
    return TextStyle(
      color: style.textColor,
      fontFamily: style.fontFamily,
      fontSize: style.labelFontSize + 2,
      fontWeight: _isFilled ? FontWeight.w600 : FontWeight.w400,
    );
  }

  InputDecoration _createBaseInputDecoration(AppzStateStyle defaultStyle) {
    final focusedStyle = AppzStyleConfig.instance.getStyleForState(AppzFieldState.focused);
    final errorStyle = AppzStyleConfig.instance.getStyleForState(AppzFieldState.error);
    final disabledStyle = AppzStyleConfig.instance.getStyleForState(AppzFieldState.disabled);
    final isDatePicker = widget.fieldType == AppzFieldType.datepicker;
    Widget? suffixIcon;
    if (isDatePicker) {
      suffixIcon = IconButton(
        icon: const Icon(Icons.calendar_today_outlined),
        onPressed: _showDatePicker,
      );
    } else if (widget.obscureText) {
      suffixIcon = IconButton(
        icon: Icon(_isTextObscured ? Icons.visibility_off : Icons.visibility),
        onPressed: () {
          setState(() {
            _isTextObscured = !_isTextObscured;
          });
        },
      );
    } else {
      suffixIcon = widget.suffixIcon;
    }

    return InputDecoration(
      hintText: widget.hintText,
      hintStyle: TextStyle(
        color: defaultStyle.textColor.withOpacity(0.5),
        fontFamily: defaultStyle.fontFamily,
        fontSize: defaultStyle.labelFontSize,
      ),
      filled: true,
      fillColor: defaultStyle.backgroundColor,
    //  suffixIcon: isDatePicker
      
    //       ? IconButton(
    //           icon: const Icon(Icons.calendar_today_outlined),
    //           onPressed: _showDatePicker,
    //         )
    //       : widget.suffixIcon,
          suffixIcon: suffixIcon,
      prefixIcon: widget.prefixIcon,
      contentPadding: EdgeInsets.symmetric(
        horizontal: defaultStyle.paddingHorizontal,
        vertical: defaultStyle.paddingVertical,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultStyle.borderRadius),
        borderSide: BorderSide(
          color: defaultStyle.borderColor,
          width: defaultStyle.borderWidth,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(focusedStyle.borderRadius),
        borderSide: BorderSide(
          color: focusedStyle.borderColor,
          width: focusedStyle.borderWidth,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(errorStyle.borderRadius),
        borderSide: BorderSide(
          color: errorStyle.borderColor,
          width: errorStyle.borderWidth,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(errorStyle.borderRadius),
        borderSide: BorderSide(
          color: errorStyle.borderColor,
          width: errorStyle.borderWidth,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(disabledStyle.borderRadius),
        borderSide: BorderSide(
          color: disabledStyle.borderColor,
          width: disabledStyle.borderWidth,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!AppzStyleConfig.instance.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    final AppzStateStyle style = AppzStyleConfig.instance.getStyleForState(_currentFieldState, isFilled: _isFilled);
    final InputDecoration baseFieldDecoration = _createBaseInputDecoration(style);
    final bool isDatePicker = widget.fieldType == AppzFieldType.datepicker;

    Widget fieldWidget;

    switch (widget.fieldType) {
      case AppzFieldType.defaultType:
      case AppzFieldType.datepicker:
        fieldWidget = TextFormField(
          controller: _internalController,
          focusNode: _internalFocusNode,
          decoration: baseFieldDecoration,
          style: _getTextStyleForField(style),
          validator: _performValidation,
          onTap: isDatePicker ? _showDatePicker : widget.onTap,
          readOnly: isDatePicker,
          onFieldSubmitted: widget.onSubmitted,
            obscureText: _isTextObscured,
          //obscureText: widget.obscureText,
          textInputAction: widget.textInputAction,
          maxLength: widget.maxLength,
          enabled: !_isEffectivelyDisabled,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        );
        break;
      case AppzFieldType.mobile:
        fieldWidget = MobileInputWidget(
          key: widget.key ?? ValueKey('mobile_${widget.label}'),
          currentStyle: style,
          mainController: _internalController,
          mainFocusNode: _internalFocusNode,
          isEnabled: !_isEffectivelyDisabled,
          hintText: widget.hintText,
          countryCode: widget.mobileCountryCode,
          countryCodeEditable: widget.mobileCountryCodeEditable,
          validator: widget.validator,
          validationType: widget.validationType,
        );
        break;
      case AppzFieldType.aadhaar:
        fieldWidget = AadhaarInputWidget(
          key: widget.key ?? ValueKey('aadhaar_${widget.label}'),
          currentStyle: style,
          mainController: _internalController,
          mainFocusNode: _internalFocusNode,
          isEnabled: !_isEffectivelyDisabled,
          hintText: widget.hintText,
          validator: widget.validator,
          validationType: widget.validationType,
        );
        break;
      case AppzFieldType.mpin:
        fieldWidget = MpinInputWidget(
          key: widget.key ?? ValueKey('mpin_${widget.label}'),
          currentStyle: style,
          mainController: _internalController,
          mainFocusNode: _internalFocusNode,
          isEnabled: !_isEffectivelyDisabled,
          obscureText: _isTextObscured,
          //obscureText: widget.obscureText,
          mpinLength: widget.mpinLength,
          validator: widget.validator,
          validationType: widget.validationType,
        );
        break;
      case AppzFieldType.fileUpload:
      case AppzFieldType.textDescription:
        fieldWidget = Text('Field type ${widget.fieldType.name} not yet fully implemented.');
        break;
    }

    final Text labelWidget = Text.rich(
      TextSpan(
        text: widget.label,
        style: TextStyle(color: style.labelColor, fontFamily: style.fontFamily, fontSize: style.labelFontSize, fontWeight: FontWeight.w400),
        children: [
          if (widget.validationType == AppzInputValidationType.mandatory)
            TextSpan(
              text: '*',
              style: TextStyle(color: AppzStyleConfig.instance.getMandatoryAsteriskColor(), fontSize: style.labelFontSize, fontWeight: FontWeight.w400),
            ),
        ],
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          labelWidget,
          const SizedBox(height: 6.0),
        ],
        fieldWidget,
        if (_validationErrorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              _validationErrorMessage!,
              style: TextStyle(
                color: AppzStyleConfig.instance.getStyleForState(AppzFieldState.error).borderColor,
                fontSize: style.labelFontSize * 0.9,
                fontFamily: style.fontFamily),
            ),
          ),
      ],
    );
  }
}