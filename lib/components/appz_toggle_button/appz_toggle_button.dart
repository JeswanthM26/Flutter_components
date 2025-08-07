// import 'package:flutter/material.dart';
// import 'toggle_button_style_config.dart';

// enum AppzToggleWithLabelSize { small, large }

// class AppzToggleWithLabel extends StatelessWidget {
//   final String label;
//   final bool value;
//   final ValueChanged<bool> onChanged;
//   final AppzToggleWithLabelSize size;
//   final String inactiveText;
//   final String activeText;
//   final bool isDisabled;

//   const AppzToggleWithLabel({
//     Key? key,
//     required this.label,
//     required this.value,
//     required this.onChanged,
//     this.size = AppzToggleWithLabelSize.large,
//     this.inactiveText = 'No',
//     this.activeText = 'Yes',
//     this.isDisabled = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final cfg = ToggleWithLabelStyleConfig.instance;
//     final sizeStr = size.name;
//     final width = cfg.getDouble('width', sizeStr);
//     final height = cfg.getDouble('height', sizeStr);
//     final borderRadius = cfg.getDouble('borderRadius', sizeStr);
//     final fontSize = cfg.getDouble('fontSize', sizeStr);
//     final labelFontSize = cfg.getDouble('labelFontSize', sizeStr);
//     final spacing = cfg.getDouble('spacing', sizeStr);

//     Widget buildToggleButton({required String text, required bool selected, required VoidCallback onTap, required bool disabled}) {
//       final state = disabled
//           ? 'disabled'
//           : (selected ? 'selected' : 'unselected');
//       final bgColor = cfg.getColor('${state}_backgroundColor');
//       final borderColor = cfg.getColor('${state}_borderColor');
//       final textColor = cfg.getColor('${state}_textColor');
//       final fontFamily = cfg.getFontFamily();
//       final fontWeight = cfg.getFontWeight();
//       return Container(
//         width: width / 2 - 2,
//         height: height,
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(borderRadius),
//           border: Border.all(
//             color: borderColor,
//             width: 1.0,
//           ),
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             borderRadius: BorderRadius.circular(borderRadius),
//             onTap: disabled ? null : onTap,
//             child: Center(
//               child: Text(
//                 text,
//                 style: TextStyle(
//                   fontFamily: fontFamily,
//                   fontWeight: fontWeight,
//                   fontSize: fontSize,
//                   color: textColor,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//     }

//     final labelFontFamily = cfg.getFontFamily();
//     final labelFontWeight = cfg.getLabelFontWeight();
//     final labelTextColor = cfg.getColor('label_textColor');

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontFamily: labelFontFamily,
//             fontWeight: labelFontWeight,
//             fontSize: labelFontSize,
//             color: labelTextColor,
//           ),
//         ),
//         SizedBox(height: spacing),
//         Container(
//           width: width,
//           height: height,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(borderRadius),
//             border: Border.all(
//               color: cfg.getColor('unselected_borderColor'),
//               width: 1.0,
//             ),
//             color: cfg.getColor('unselected_backgroundColor'),
//           ),
//           child: Row(
//             children: [
//               buildToggleButton(
//                 text: inactiveText,
//                 selected: !value,
//                 onTap: () => onChanged(false),
//                 disabled: isDisabled,
//               ),
//               buildToggleButton(
//                 text: activeText,
//                 selected: value,
//                 onTap: () => onChanged(true),
//                 disabled: isDisabled,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// } 


import 'package:apz_flutter_components/components/appz_text/appz_text.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_components/components/appz_text/appz_text.dart';
import 'toggle_button_style_config.dart';
 
enum AppzToggleButtonAppearance {
  primary,
  secondary,
}
 
enum AppzToggleButtonSize {
  small,
  large,
}
 
class AppzToggleButton extends StatefulWidget {
  final String label;
  final AppzToggleButtonAppearance appearance;
  final AppzToggleButtonSize size;
  final String? subtitle;
  final bool isToggled;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final List<String> options;
 
  const AppzToggleButton({
    Key? key,
    required this.label,
    this.appearance = AppzToggleButtonAppearance.primary,
    this.size = AppzToggleButtonSize.large,
    this.subtitle,
    this.isToggled = false,
    this.onTap,
    this.controller,
    required this.options,
  }) : super(key: key);
 
  @override
  _AppzToggleButtonState createState() => _AppzToggleButtonState();
}
 
class _AppzToggleButtonState extends State<AppzToggleButton> {
  int _selectedIndex = 0;
  bool _configLoaded = false;
 
  @override
  void initState() {
    super.initState();
    _loadConfig();
  }
 
  Future<void> _loadConfig() async {
    await ToggleButtonStyleConfig.instance.load();
    if (mounted) setState(() => _configLoaded = true);
  }
 
  @override
  Widget build(BuildContext context) {
    if (!_configLoaded) {
      return const SizedBox.shrink();
    }
 
    final config = ToggleButtonStyleConfig.instance;
    final sizeVariant = widget.size == AppzToggleButtonSize.small ? 'small' : 'large';
 
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
 
    final toggleButtons = Container(
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: config.getInactiveColor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(config.getBorderRadius()),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.options.length, (index) {
          final isSelected = _selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              padding: config.getPadding(sizeVariant),
              decoration: ShapeDecoration(
                color: isSelected ? config.getActiveColor() : config.getInactiveColor(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(config.getBorderRadius()),
                ),
              ),
              child: AppzText(
                widget.options[index],
                category: 'button',
                fontWeight: 'semibold',
                color: isSelected ? config.getActiveTextColor() : config.getInactiveTextColor(),
              ),
            ),
          );
        }),
      ),
    );
 
    switch (widget.appearance) {
      case AppzToggleButtonAppearance.primary:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            labelAndSubtitle,
            const SizedBox(height: 8),
            toggleButtons,
          ],
        );
      case AppzToggleButtonAppearance.secondary:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            labelAndSubtitle,
            toggleButtons,
          ],
        );
    }
  }
}
 