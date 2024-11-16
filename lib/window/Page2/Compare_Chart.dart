import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CompareChart extends StatelessWidget{
  final double totalIncome;
  final double totalExpense;
  CompareChart({required this.totalIncome, required this.totalExpense});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                localizations.compareChart,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                localizations.showExpensesIncome,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Container(
            height: 300,
            width: 300,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: (totalExpense + totalIncome) / 4,
                      getTitlesWidget: (value, meta) {
                        if (value >= 1000000000) {
                          return Text(
                            '${(value / 1000000000).toStringAsFixed(1)}B',
                            style: TextStyle(fontSize: 12),
                          );
                        } else if (value >= 1000000) {
                          return Text(
                            '${(value / 1000000).toStringAsFixed(1)}M',
                            style: TextStyle(fontSize: 12),
                          );
                        } else if (value >= 1000) {
                          return Text(
                            '${(value / 1000).toStringAsFixed(1)}K',
                            style: TextStyle(fontSize: 12),
                          );
                        } else {
                          return Text(
                            value.toStringAsFixed(0),
                            style: TextStyle(fontSize: 12),
                          );
                        }
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0:
                            return Text(localizations.expense);
                          case 1:
                            return Text(localizations.income);
                          default:
                            return Text('');
                        }
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 1),
                    left: BorderSide(color: Colors.transparent, width: 0),
                    right: BorderSide(color: Colors.transparent, width: 0),
                    top: BorderSide(color: Colors.transparent, width: 10),
                  ),
                ),
                maxY: (totalExpense > totalIncome ? totalExpense : totalIncome) * 1.1,
                minY: 0,
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: totalExpense,
                        width: 30,
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: totalIncome,
                        width: 30,
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
