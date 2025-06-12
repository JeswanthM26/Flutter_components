import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:intl/intl.dart';

class ApzDatePickerField extends StatefulWidget {
  final String label;
  final Function(DateTime) onDateSelected;
  final DateTime? selectedDate;
  final bool blockFuture;
  final bool blockPast;
  final bool isMandatory;

  const ApzDatePickerField({
    super.key,
    required this.label,
    required this.onDateSelected,
    this.selectedDate,
    this.blockFuture = false,
    this.blockPast = false,
    this.isMandatory = false
  });

  @override
  State<ApzDatePickerField> createState() => _LabeledDatePickerFieldState();
}

class _LabeledDatePickerFieldState extends State<ApzDatePickerField> {
  DateTime? _selectedDate;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.selectedDate != null) {
      _selectedDate = widget.selectedDate;
      _controller.text = DateFormat('dd-MM-yyyy').format(widget.selectedDate!);
    }
  }

  void _showCalendarDialog() {
    final today = DateTime.now();
    final min = widget.blockPast ? today : DateTime(1900);
    final max = widget.blockFuture ? today : DateTime(2100);
    DateTime tempDate = _selectedDate ?? today;

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            elevation: 12,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              width: 340,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  dp.DayPicker.single(
                    selectedDate: tempDate,
                    onChanged: (date) {
                      setState(() {
                        _selectedDate = date;
                        _controller.text = DateFormat('dd-MM-yyyy').format(date);
                        widget.onDateSelected(date);
                      });
                      Navigator.pop(context);
                    },
                    firstDate: min,
                    lastDate: max,
                    datePickerStyles: dp.DatePickerRangeStyles(
                      selectedSingleDateDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    datePickerLayoutSettings: const dp.DatePickerLayoutSettings(
                      showPrevMonthEnd: true,
                      showNextMonthStart: true,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),*/
        RichText(
          text: TextSpan(
            text: widget.label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
            children: widget.isMandatory
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
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _showCalendarDialog,
          child: AbsorbPointer(
            child: TextFormField(
              controller: _controller,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'dd-mm-yyyy',
                suffixIcon: const Icon(Icons.calendar_month),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
