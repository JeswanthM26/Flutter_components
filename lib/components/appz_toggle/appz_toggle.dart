/*import 'package:flutter/material.dart';
import 'toggle_style_config.dart';

enum AppzToggleSize { small, large }

class AppzToggle extends StatefulWidget {
  final bool isOn;
  final bool isDisabled;
  final AppzToggleSize size;
  final String? text;
  final ValueChanged<bool>? onChanged;

  const AppzToggle({
    Key? key,
    this.isOn = false,
    this.isDisabled = false,
    this.size = AppzToggleSize.large,
    this.text,
    this.onChanged,
  }) : super(key: key);

  @override
  State<AppzToggle> createState() => _AppzToggleState();
}

class _AppzToggleState extends State<AppzToggle> {
  late bool _on;
  late ToggleStyleConfig _cfg;

  @override
  void initState() {
    super.initState();
    _on = widget.isOn;
    _cfg = ToggleStyleConfig.instance;
  }

  String _getState() {
    if (widget.isDisabled) return 'disabled';
    return _on ? 'on' : 'off';
  }

  @override
  Widget build(BuildContext context) {
    final sizeStr = widget.size.name;
    final state = _getState();

    final width = _cfg.getDouble('width', sizeStr);
    final height = _cfg.getDouble('height', sizeStr);
    final thumbSize = _cfg.getDouble('thumbSize', sizeStr);
    final padding = _cfg.getDouble('padding', sizeStr);
    final trackRadius = height / 2;
    final thumbPositionOn = width - thumbSize - padding;
    final thumbPositionOff = padding;
    final thumbPosition = _on ? thumbPositionOn : thumbPositionOff;

    final bgColor = _cfg.getColor('${state}_backgroundColor');
    final borderColor = _cfg.getColor('${state}_borderColor');
    final thumbColor = _cfg.getColor('${state}_thumbColor');
    final textColor = _cfg.getColor('${state}_textColor');
    final textStyle = _cfg.getTextStyle(sizeStr, textColor);
    final spacing = _cfg.getSpacing(sizeStr);

    return GestureDetector(
      onTap: widget.isDisabled
          ? null
          : () {
              setState(() {
                _on = !_on;
              });
              widget.onChanged?.call(_on);
            },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: width,
            height: height,
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(trackRadius),
              border: Border.all(
                color: borderColor,
                width: 1.0,
              ),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Positioned(
                  left: thumbPosition,
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      color: thumbColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.text != null) ...[
            SizedBox(width: spacing),
            Text(
              widget.text!,
              style: textStyle,
            ),
          ],
        ],
      ),
    );
  }
}*/
import 'package:apz_flutter_components/components/appz_text/appz_text.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_components/components/appz_text/appz_text.dart';
import 'toggle_style_config.dart';
 
enum AppzToggleAppearance {
  primary,
  secondary,
  tertiary,
}
 
enum AppzToggleSize {
  small,
  large,
}
 
class AppzToggleSwitch extends StatefulWidget {
  final String label;
  final AppzToggleAppearance appearance;
  final AppzToggleSize size;
  final String? subtitle;
  final bool isToggled;
  final VoidCallback? onTap;
  final TextEditingController? controller;
 
  const AppzToggleSwitch({
    Key? key,
    required this.label,
    this.appearance = AppzToggleAppearance.primary,
    this.size = AppzToggleSize.large,
    this.subtitle,
    this.isToggled = false,
    this.onTap,
    this.controller,
  }) : super(key: key);
 
  @override
  _AppzToggleSwitchState createState() => _AppzToggleSwitchState();
}
 
class _AppzToggleSwitchState extends State<AppzToggleSwitch> {
  bool _isToggled = false;
  bool _configLoaded = false;
 
  @override
  void initState() {
    super.initState();
    _isToggled = widget.isToggled;
    _loadConfig();
  }
 
  Future<void> _loadConfig() async {
    await ToggleStyleConfig.instance.load();
    if (mounted) setState(() => _configLoaded = true);
  }
 
  @override
  Widget build(BuildContext context) {
    if (!_configLoaded) {
      return const SizedBox.shrink();
    }
 
    final config = ToggleStyleConfig.instance;
    final sizeVariant = widget.size == AppzToggleSize.small ? 'small' : 'large';
 
    final width = config.size('width', sizeVariant: sizeVariant);
    final height = config.size('height', sizeVariant: sizeVariant);
    final thumbSize = config.size('thumbSize', sizeVariant: sizeVariant);
    final padding = config.size('padding', sizeVariant: sizeVariant);
 
    final toggle = GestureDetector(
      onTap: () {
        setState(() {
          _isToggled = !_isToggled;
        });
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(padding),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: _isToggled ? config.getActiveColor() : config.getInactiveColor(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Align(
          alignment: _isToggled ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: thumbSize,
            height: thumbSize,
            decoration: ShapeDecoration(
              color: config.getThumbColor(),
              shape: const OvalBorder(),
              shadows: [
                const BoxShadow(
                  color: Color(0x0F101828),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                  spreadRadius: 0,
                ),
                const BoxShadow(
                  color: Color(0x19101828),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                  spreadRadius: 0,
                )
              ],
            ),
          ),
        ),
      ),
    );
 
    final labelAndSubtitle = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppzText(
          widget.label,
          category: 'label',
          fontWeight: 'medium',
        ),
        if (widget.subtitle != null)
          AppzText(
            widget.subtitle!,
            category: 'label',
            fontWeight: 'regular',
          ),
      ],
    );
 
    switch (widget.appearance) {
      case AppzToggleAppearance.primary:
        return Column(
          children: [
            labelAndSubtitle,
            const SizedBox(height: 8),
            toggle,
          ],
        );
      case AppzToggleAppearance.secondary:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            labelAndSubtitle,
            toggle,
          ],
        );
      case AppzToggleAppearance.tertiary:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            toggle,
            labelAndSubtitle,
          ],
        );
    }
  }
}