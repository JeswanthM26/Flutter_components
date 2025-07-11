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
  late double fillPercent;
  late String displayText;
  late String category;

  @override
  void initState() {
    super.initState();
    cfg = ProgressBarStyleConfig.instance;
    fillPercent = widget.percentage.clamp(0.0, 100.0);
    displayText = widget.labelText ?? '${fillPercent.toInt()}${widget.showPercentage ? '%' : ''}';
    category = _categoryFromLabelPosition(widget.labelPosition);
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

  double _getFillWidth(double percentage, double totalWidth) {
    return (percentage.clamp(0.0, 100.0) / 100.0) * totalWidth;
  }

  @override
  Widget build(BuildContext context) {
    final width = cfg.getDouble('width', category: category);
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

    final fillWidth = _getFillWidth(fillPercent, width);

    switch (widget.labelPosition) {
      case ProgressBarLabelPosition.none:
        return _buildBarOnly(width, height, borderRadius, fillWidth, bgColor, fillColor);

      case ProgressBarLabelPosition.right:
        return Row(
          children: [
            _buildBarOnly(width - 30, height, borderRadius, _getFillWidth(fillPercent, width - 30), bgColor, fillColor),
            SizedBox(width: labelSpacing),
            Text(displayText, style: labelStyle),
          ],
        );

      case ProgressBarLabelPosition.bottom:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildBarOnly(width, height, borderRadius, fillWidth, bgColor, fillColor),
            SizedBox(height: labelSpacing),
            Text(displayText, style: labelStyle),
          ],
        );

      case ProgressBarLabelPosition.topFloating:
        return Column(
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
                      color: floatingShadow,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(displayText, style: labelStyle),
              ),
            ),
            SizedBox(height: floatingOffset),
            _buildBarOnly(width, height, borderRadius, fillWidth, bgColor, fillColor),
          ],
        );

      case ProgressBarLabelPosition.bottomFloating:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBarOnly(width, height, borderRadius, fillWidth, bgColor, fillColor),
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
                      color: floatingShadow,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(displayText, style: labelStyle),
              ),
            ),
          ],
        );
    }
  }

  Widget _buildBarOnly(double width, double height, double radius, double fillWidth, Color bg, Color fill) {
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
