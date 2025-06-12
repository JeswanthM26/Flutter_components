import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class ApzDropdownField<T> extends StatefulWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final bool enabled;
  final bool defaultRequired;
  final bool isMandatory;

  const ApzDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.enabled = true,
    this.defaultRequired = true,
    this.isMandatory = false,
  });

  @override
  State<ApzDropdownField<T>> createState() => _ApzDropdownFieldState<T>();
}

class _ApzDropdownFieldState<T> extends State<ApzDropdownField<T>> {
  final GlobalKey _fieldKey = GlobalKey();
  Offset _calculatedOffset = const Offset(0, 8); // default is below

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final position = renderBox.localToGlobal(Offset.zero);
        final screenHeight = MediaQuery.of(context).size.height;
        final spaceBelow = screenHeight - position.dy - renderBox.size.height;

        setState(() {
          _calculatedOffset = spaceBelow < 300 ? const Offset(0, -200) : const Offset(0, 8);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<T>> allItems = widget.defaultRequired
        ? [
            DropdownMenuItem<T>(
              value: null,
              child: Text('Please Select', style: TextStyle(color: Colors.grey[600])),
            ),
            ...widget.items,
          ]
        : widget.items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          RichText(
            text: TextSpan(
              text: widget.label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
              children: widget.isMandatory
                  ? [
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      )
                    ]
                  : [],
            ),
          ),
          const SizedBox(height: 8),
        ],
        DropdownButtonFormField2<T>(
          key: _fieldKey,
          isExpanded: true,
          value: widget.items.map((item) => item.value).contains(widget.value) ? widget.value : null,
          onChanged: widget.enabled ? widget.onChanged : null,
          items: allItems,
          validator: widget.validator,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          dropdownStyleData: DropdownStyleData(
            elevation: 4,
            maxHeight: 300,
            offset: _calculatedOffset,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(Icons.arrow_drop_down_rounded),
            iconSize: 24,
          ),
        ),
      ],
    );
  }
}
