/*import 'package:apz_flutter_components/common/token_parser.dart';
import 'package:flutter/material.dart';

class ToggleStyleConfig {
  static final ToggleStyleConfig instance = ToggleStyleConfig._internal();
  final TokenParser _tokenParser = TokenParser();

  ToggleStyleConfig._internal();

  Future<void> load() async {
    await _tokenParser.loadTokens();
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
      if (primitiveCollection == null) return Colors.transparent;
      final primitiveVariables = primitiveCollection['modes'][0]['variables'] as List<dynamic>;
      final primitiveToken = primitiveVariables.firstWhere((v) => v['name'] == alias, orElse: () => null);
      if (primitiveToken != null) {
        return _parseColor(primitiveToken['value']);
      }
    } else {
      return _parseColor(token['value']);
    }
    return Colors.transparent;
  }

  double getDouble(String key, String size) {
    return _tokenParser.getValue<double>(['toggleSwitch', size, key], fromSupportingTokens: true) ?? 0.0;
  }

  double getSpacing(String size) {
    return _tokenParser.getValue<double>(['toggleSwitch', 'spacing', size], fromSupportingTokens: true) ?? 8.0;
  }

  Color _parseColor(String hex) {
    if (hex == null || hex is! String) return Colors.transparent;
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.tryParse(hex, radix: 16) ?? 0);
  }

  TextStyle getTextStyle(String size, Color color) {
    final fontFamily = _tokenParser.getValue<String>(['toggleSwitch', 'text', 'fontFamily'], fromSupportingTokens: true) ?? '';
    final fontSize = getDouble('thumbSize', size); // Use thumbSize as fontSize for demo, adjust as needed
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w500,
    );
  }
}*/
import 'package:flutter/material.dart';
import '../../common/token_parser.dart';
 
class ToggleStyleConfig extends ChangeNotifier {
  static final ToggleStyleConfig instance = ToggleStyleConfig._internal();
  Map<String, dynamic>? _config;
  final TokenParser _tokenParser = TokenParser();
  bool _useMaterialTheme = true;
  bool _isLoaded = false;
 
  ToggleStyleConfig._internal();
 
  bool get useMaterialTheme => _useMaterialTheme;
 
  void setUseMaterialTheme(bool value) {
    _useMaterialTheme = value;
    notifyListeners();
  }
 
  Future<void> load() async {
    try {
      await _tokenParser.loadTokens();
      final supportingConfig = _tokenParser.getValue<Map<String, dynamic>>(['toggleSwitch'], fromSupportingTokens: true);
      _config = supportingConfig;
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      _isLoaded = false;
    }
  }
 
  bool get isInitialized => _config != null && _isLoaded;
 
  Map<String, double> get sizes {
    if (_config == null || !_isLoaded) {
      throw Exception('ToggleStyleConfig not initialized. Call load() first.');
    }
    final sizesMap = _config!['sizes'] as Map<String, dynamic>;
    return sizesMap.map((k, v) => (v is num) ? MapEntry(k, (v as num).toDouble()) : MapEntry(k, double.tryParse(v.toString()) ?? 0));
  }
 
  double size(String key, {String? sizeVariant}) {
    if (_config == null || !_isLoaded) {
      throw Exception('ToggleStyleConfig not initialized. Call load() first.');
    }
    if (sizeVariant != null) {
      final sizeMap = _config![sizeVariant] as Map<String, dynamic>;
      final value = sizeMap[key];
      return value is num ? value.toDouble() : double.tryParse(value.toString()) ?? 0;
    }
    final value = _config![key];
    return value is num ? value.toDouble() : double.tryParse(value.toString()) ?? 0;
  }
 
  Color getActiveColor() {
    return getColor('Form Fields/Toggle/Switch/Active');
  }
 
  Color getInactiveColor() {
    return getColor('Form Fields/Toggle/Switch/Inactive');
  }
 
  Color getThumbColor() {
    return getColor('Form Fields/Toggle/Switch/Switch button');
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