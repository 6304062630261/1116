import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PeriodSelectionMenu extends StatelessWidget {
  final String selectedPeriod;
  final Function(String) onPeriodSelected;
  final Function(DateTime, DateTime) onCustomDateSelected;

  PeriodSelectionMenu({
    required this.selectedPeriod,
    required this.onPeriodSelected,
    required this.onCustomDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) async {
        if (value == 'Custom') {
          // นี่คือที่คุณสามารถใช้งานการเลือกวันที่แบบ Custom ได้
          // รอให้ผู้ใช้เลือกวันที่เริ่มต้นและสิ้นสุดแล้วส่งค่าไปยัง onCustomDateSelected
          DateTime startDate = DateTime.now().subtract(Duration(days: 7));
          DateTime endDate = DateTime.now();
          onCustomDateSelected(startDate, endDate);
        } else {
          onPeriodSelected(value);
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(value: 'Day', child: Text('Day')),
          PopupMenuItem(value: 'Month', child: Text('Month')),
          PopupMenuItem(value: 'Year', child: Text('Year')),
          PopupMenuItem(value: 'Custom', child: Text('Custom')),
        ];
      },
    );
  }
}
