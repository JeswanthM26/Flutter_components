// import 'package:apz_flutter_components/common/token_parser.dart';
// import 'package:flutter/material.dart';

// class ToggleWithLabelStyleConfig {
//   static final ToggleWithLabelStyleConfig instance = ToggleWithLabelStyleConfig._internal();
//   final TokenParser _tokenParser = TokenParser();

//   ToggleWithLabelStyleConfig._internal();

//   Future<void> load() async {
//     await _tokenParser.loadTokens();
//   }

//   Color getColor(String tokenName) {
//     final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
//     if (collections == null) return Colors.transparent;
//     final tokenCollection = collections.firstWhere((c) => c['name'] == 'Tokens', orElse: () => null);
//     if (tokenCollection == null) return Colors.transparent;
//     final variables = tokenCollection['modes'][0]['variables'] as List<dynamic>;
//     final token = variables.firstWhere((v) => v['name'] == tokenName, orElse: () => null);
//     if (token == null) return Colors.transparent;
//     if (token['isAlias'] == true) {
//       final alias = token['value']['name'];
//       final primitiveCollection = collections.firstWhere((c) => c['name'] == 'Primitive', orElse: () => null);
//       if (primitiveCollection == null) return Colors.transparent;
//       final primitiveVariables = primitiveCollection['modes'][0]['variables'] as List<dynamic>;
//       final primitiveToken = primitiveVariables.firstWhere((v) => v['name'] == alias, orElse: () => null);
//       if (primitiveToken != null) {
//         return _parseColor(primitiveToken['value']);
//       }
//     } else {
//       return _parseColor(token['value']);
//     }
//     return Colors.transparent;
//   }

//   double getDouble(String key, String size) {
//     return _tokenParser.getValue<double>(['toggleWithLabel', size, key], fromSupportingTokens: true) ?? 0.0;
//   }

//   double getSpacing(String size) {
//     return _tokenParser.getValue<double>(['toggleWithLabel', size, 'spacing'], fromSupportingTokens: true) ?? 8.0;
//   }

//   String getFontFamily() {
//     return _tokenParser.getValue<String>(['toggleWithLabel', 'text', 'fontFamily'], fromSupportingTokens: true) ?? '';
//   }

//   FontWeight getFontWeight() {
//     final weightToken = _tokenParser.getValue<String>(['toggleWithLabel', 'text', 'fontWeight'], fromSupportingTokens: true);
//     return _parseFontWeight(weightToken);
//   }

//   FontWeight getLabelFontWeight() {
//     final weightToken = _tokenParser.getValue<String>(['toggleWithLabel', 'text', 'labelFontWeight'], fromSupportingTokens: true);
//     return _parseFontWeight(weightToken);
//   }

//   Color _parseColor(String hex) {
//     if (hex == null || hex is! String) return Colors.transparent;
//     hex = hex.replaceFirst('#', '');
//     if (hex.length == 6) hex = 'FF$hex';
//     return Color(int.tryParse(hex, radix: 16) ?? 0);
//   }

//   FontWeight _parseFontWeight(String? weight) {
//     switch (weight) {
//       case 'w100':
//         return FontWeight.w100;
//       case 'w200':
//         return FontWeight.w200;
//       case 'w300':
//         return FontWeight.w300;
//       case 'w400':
//         return FontWeight.w400;
//       case 'w500':
//         return FontWeight.w500;
//       case 'w600':
//         return FontWeight.w600;
//       case 'w700':
//         return FontWeight.w700;
//       case 'w800':
//         return FontWeight.w800;
//       case 'w900':
//         return FontWeight.w900;
//       default:
//         return FontWeight.normal;
//     }
//   }
// } 
import 'package:flutter/material.dart';
import '../../common/token_parser.dart';
 
class ToggleButtonStyleConfig extends ChangeNotifier {
  static final ToggleButtonStyleConfig instance = ToggleButtonStyleConfig._internal();
  Map<String, dynamic>? _config;
  final TokenParser _tokenParser = TokenParser();
  bool _useMaterialTheme = true;
  bool _isLoaded = false;
 
  ToggleButtonStyleConfig._internal();
 
  bool get useMaterialTheme => _useMaterialTheme;
 
  void setUseMaterialTheme(bool value) {
    _useMaterialTheme = value;
    notifyListeners();
  }
 
  Future<void> load() async {
    try {
      await _tokenParser.loadTokens();
      final supportingConfig = _tokenParser.getValue<Map<String, dynamic>>(['toggleButton'], fromSupportingTokens: true);
      _config = supportingConfig;
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      _isLoaded = false;
    }
  }
 
  bool get isInitialized => _config != null && _isLoaded;
 
  Color getActiveColor() {
    return getColor('Form Fields/Toggle/Button/Active');
  }
 
  Color getInactiveColor() {
    return getColor('Form Fields/Toggle/Button/Inactive');
  }
 
  Color getActiveTextColor() {
    return getColor('Text colour/Button/Default');
  }
 
  Color getInactiveTextColor() {
    return getColor('Text colour/Button/Clicked');
  }
 
  double getBorderRadius() {
    return _tokenParser.getValue<double>(['toggleButton', 'borderRadius'], fromSupportingTokens: true) ?? 0.0;
  }
 
  EdgeInsets getPadding(String size) {
    final paddingMap = _tokenParser.getValue<Map<String, dynamic>>(['toggleButton', size, 'padding'], fromSupportingTokens: true);
    if (paddingMap != null) {
      return EdgeInsets.symmetric(
        horizontal: paddingMap['horizontal']?.toDouble() ?? 0.0,
        vertical: paddingMap['vertical']?.toDouble() ?? 0.0,
      );
    }
    return EdgeInsets.zero;
  }
 
  Color getColor(String tokenName) {
    final collections = _tokenParser.getValue<List<dynamic>>(['collections']);
    if (collections == null) return Colors.transparent;
 
    final tokenCollection = collections.firstWhere((c) => c['name'] == 'Tokens', orElse: () => null);
    if (tokenCollection == null) return Colors.transparent;
 
    final variables = tokenCollection['modes'][0]['variables'] as List<dynamic>;
    final token = variables.firstWhere((v) => v['name'] == tokenName, orElse: () => null);
 
    if (token == null) return Colors.transparent;
 
    if (token['isAlias'] == true) {
      final alias = token['value']['name'];
      final primitiveCollection = collections.firstWhere((c) => c['name'] == 'Primitive', orElse: () => null);
      if (primitiveCollection != null) {
        final primitiveVariables = primitiveCollection['modes'][0]['variables'] as List<dynamic>;
        final primitiveToken = primitiveVariables.firstWhere((v) => v['name'] == alias, orElse: () => null);
 
        if (primitiveToken != null) {
          return parseColor(primitiveToken['value']);
        }
      }
    } else {
      return parseColor(token['value']);
    }
 
    return Colors.transparent;
  }
 
  static Color parseColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
}
 