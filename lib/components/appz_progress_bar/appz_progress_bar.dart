import 'package:flutter/material.dart';
import 'progress_bar_style_config.dart';

enum ProgressBarLabelPosition {
  none,
  right,
  bottom,
  topFloating,
  bottomFloating,
}

class AppzProgressBar extends StatefulWidget {
  final double percentage;
  final ProgressBarLabelPosition labelPosition;
  final String? labelText;
  final bool showPercentage;

  const AppzProgressBar({
    super.key,
    required this.percentage,
    this.labelPosition = ProgressBarLabelPosition.none,
    this.labelText,
    this.showPercentage = true,
  });

  @override
  State<AppzProgressBar> createState() => _AppzProgressBarState();
}

class _AppzProgressBarState extends State<AppzProgressBar> {
  late ProgressBarStyleConfig cfg;

  @override
  void initState() {
    super.initState();
    cfg = ProgressBarStyleConfig.instance;
  }

  String _categoryFromLabelPosition(ProgressBarLabelPosition position) {
    switch (position) {
      case ProgressBarLabelPosition.none:
        return 'noLabel';
      case ProgressBarLabelPosition.right:
        return 'rightLabel';
      case ProgressBarLabelPosition.bottom:
        return 'bottomLabel';
      case ProgressBarLabelPosition.topFloating:
        return 'topFloatingLabel';
      case ProgressBarLabelPosition.bottomFloating:
        return 'bottomFloatingLabel';
    }
  }

  @override
  Widget build(BuildContext context) {
    final fillPercent = widget.percentage.clamp(0.0, 100.0);
    final displayText = widget.labelText ??
        '${fillPercent.toInt()}${widget.showPercentage ? '%' : ''}';
    final category = _categoryFromLabelPosition(widget.labelPosition);

    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = MediaQuery.of(context).size.width;
        final availableWidth = (constraints.hasBoundedWidth && constraints.maxWidth != double.infinity)
            ? constraints.maxWidth
            : screenWidth;
        final paddedWidth = availableWidth;
        final height = cfg.getDouble('height', category: category);
        final borderRadius = cfg.getDouble('borderRadius');
        final fontSize = cfg.getDouble('fontSize');
        final fontFamily = cfg.get('fontFamily') ?? 'Outfit';
        final labelColor = cfg.getColor('labelColor');
        final labelPadding = cfg.getEdgeInsets('labelPadding');
        final labelSpacing = cfg.getDouble('labelSpacing');
        final floatingOffset = cfg.getDouble('floatingLabelOffset');
        final floatingBg = cfg.getColor('floatingLabelBackgroundColor');
        final floatingShadow = cfg.getColor('floatingLabelShadowColor');
        final bgColor = cfg.getColor('backgroundColor');
        final fillColor = cfg.getColor('fillColor');

        final labelStyle = TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
          color: labelColor,
        );

        Widget barWidget;
        switch (widget.labelPosition) {
          case ProgressBarLabelPosition.none:
            barWidget = _buildBarOnly(paddedWidth, height, borderRadius, fillPercent, bgColor, fillColor);
            break;
          case ProgressBarLabelPosition.right:
            barWidget = Row(
              children: [
                _buildBarOnly(paddedWidth - 30, height, borderRadius,
                    fillPercent, bgColor, fillColor),
                SizedBox(width: labelSpacing),
                Text(displayText, style: labelStyle),
              ],
            );
            break;
          case ProgressBarLabelPosition.bottom:
            barWidget = Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBarOnly(paddedWidth, height, borderRadius, fillPercent, bgColor, fillColor),
                SizedBox(height: labelSpacing),
                Text(displayText, style: labelStyle),
              ],
            );
            break;
          case ProgressBarLabelPosition.topFloating:
            barWidget = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: floatingOffset),
                Align(
                  alignment: Alignment((fillPercent / 50.0) - 1, 0),
                  child: Container(
                    padding: labelPadding,
                    decoration: BoxDecoration(
                      color: floatingBg,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: floatingShadow.withOpacity(0.5),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(displayText, style: labelStyle),
                  ),
                ),
                SizedBox(height: floatingOffset),
                _buildBarOnly(paddedWidth, height, borderRadius, fillPercent, bgColor, fillColor),
              ],
            );
            break;
          case ProgressBarLabelPosition.bottomFloating:
            barWidget = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBarOnly(paddedWidth, height, borderRadius, fillPercent, bgColor, fillColor),
                SizedBox(height: floatingOffset),
                Align(
                  alignment: Alignment((fillPercent / 50.0) - 1, 0),
                  child: Container(
                    padding: labelPadding,
                    decoration: BoxDecoration(
                      color: floatingBg,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: floatingShadow.withOpacity(0.5),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(displayText, style: labelStyle),
                  ),
                ),
              ],
            );
            break;
        }
        // Always wrap barWidget in Padding for consistent horizontal padding
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: barWidget,
        );
      },
    );
  }

  Widget _buildBarOnly(double width, double height, double radius, double fillPercent, Color bg, Color fill) {
    final fillWidth = (fillPercent.clamp(0.0, 100.0) / 100.0) * width;
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          if (fillPercent > 0)
            Container(
              width: fillWidth,
              height: height,
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(radius),
              ),
            )
          else
            Container(
              width: height,
              height: height,
              decoration: BoxDecoration(color: fill, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}
