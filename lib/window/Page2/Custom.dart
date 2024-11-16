import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final Function(DateTime, DateTime) onDateSelected; // Callback for returning selected dates

  const CustomDatePicker({Key? key, required this.onDateSelected}) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? startDate;
  DateTime? endDate;

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: startDate ?? DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Custom Date Range'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (startDate != null && endDate != null) {
                widget.onDateSelected(startDate!, endDate!); // Pass the selected dates back
                Navigator.pop(context); // Close the page
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please select both dates')),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ListTile(
            title: Text('Start Date: ${startDate != null ? DateFormat('yyyy-MM-dd').format(startDate!) : 'Not Selected'}'),
            trailing: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () => selectStartDate(context),
            ),
          ),
          ListTile(
            title: Text('End Date: ${endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : 'Not Selected'}'),
            trailing: IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () => selectEndDate(context),
            ),
          ),
        ],
      ),
    );
  }
}
