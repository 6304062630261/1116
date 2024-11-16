import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PieChartWidget extends StatelessWidget{
  final Map<String, double> dataMap;
  PieChartWidget({required this.dataMap});

  @override
  Widget build(BuildContext context){
    List<PieChartSectionData> pieChartSections = _createPieChartSections(context);
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            _buildTitle(localizations),
            Container(
              height: 300,
              child: PieChart(
                PieChartData(
                  sections: pieChartSections,
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
            SizedBox(height: 5),
            _buildIndicator(pieChartSections),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  final Map<String, Color> typeToColor ={
    'Food': Colors.blueAccent,
    'Travel expenses': Colors.lightGreenAccent,
    'Water bill': Colors.lightBlueAccent,
    'Electricity bill': Colors.yellow,
    'House cost': Colors.deepOrangeAccent,
    'Car fare': Colors.deepPurpleAccent,
    'Gasoline cost': Colors.orangeAccent,
    'Medical expenses': Colors.indigo,
    'Beauty expenses': Colors.pink,
    'Internet cost': Colors.blue.shade100,
    'Other': Colors.teal.shade400,

  };

  List<PieChartSectionData> _createPieChartSections(BuildContext context){
    final localizations = AppLocalizations.of(context)!;
    return dataMap.entries.map((entry){
      return PieChartSectionData(
        color: typeToColor[entry.key] ?? Colors.grey,
        value: entry.value,
        title: _getLocalizedTitle(entry.key, localizations) ,
        radius: 50,
        showTitle: false,
      );
    }).toList();
  }

  String _getLocalizedTitle(String key, AppLocalizations localizations){
    switch (key){
      case 'Food':
        return localizations.food;
      case 'Travel expenses':
        return localizations.travelexpenses;
      case 'Water bill':
        return localizations.waterbill;
      case 'Electricity bill':
        return localizations.electricitybill;
      case 'House cost':
        return localizations.housecost;
      case 'Car fare':
        return localizations.carfare;
      case 'Gasoline cost':
        return localizations.gasolinecost;
      case 'Medical expenses':
        return localizations.medicalexpenses;
      case 'Beauty expenses':
        return localizations.beautyexpenses;
      case 'Internet cost':
        return localizations.internetcost;
      case 'Other':
        return localizations.other;
      default:
        return key;
    }
  }

  Widget _buildTitle(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.chart,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          localizations.donutchart,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildIndicator(List<PieChartSectionData> pieChartSections ){
    return Column(
      children: pieChartSections.map((section){
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: section.color,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                '${section.title} ${NumberFormat('#,##0.00').format(section.value)} ฿',
                style: TextStyle(fontSize: 20),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
