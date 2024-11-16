import 'package:flutter/material.dart';
import '../../database/db_manage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CardFinancial extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> transactionsFuture;

  CardFinancial({required this.transactionsFuture});

  Future<List<Map<String, dynamic>>> fetchBudgetData() async {
    final db = DatabaseManagement.instance;
    final now = DateTime.now();

    final budgets = await db.queryAllBudgets();
    List<Map<String, dynamic>> filteredBudgets = [];

    for (var budget in budgets) {
      if (DateTime.parse(budget['date_end']).isAfter(now)) {
        final transactions = await db.queryAllTransactions();
        double balance = 0.0;
        for (var transaction in transactions) {
          if (transaction['ID_type_transaction'] == budget['ID_type_transaction']) {
            final transactionDate = DateTime.parse(transaction['date_user']);
            if (transactionDate.isAfter(DateTime.parse(budget['date_start'])) &&
                transactionDate.isBefore(DateTime.parse(budget['date_end']))) {
              balance += transaction['amount_transaction'] ?? 0.0;
            }
          }
        }

        final double budgetAmount = budget['capital_budget'] ?? 0.0;
        final double progress = budgetAmount > 0 ? balance / budgetAmount : 0.0;

        filteredBudgets.add({
          'idTypeTransaction': budget['ID_type_transaction'] ?? 0,
          'budget': budgetAmount,
          'balance': balance,
          'progress': progress,
        });
      }
    }

    return filteredBudgets;
  }

  String getImagePath(int idTypeTransaction) {
    switch (idTypeTransaction) {
      case 1:
        return 'assets/food.png';
      case 2:
        return 'assets/travel_expenses.png';
      case 3:
        return 'assets/water_bill.png';
      case 4:
        return 'assets/electricity_bill.png';
      case 5:
        return 'assets/internet.png';
      case 6:
        return 'assets/house.png';
      case 7:
        return 'assets/car.png';
      case 8:
        return 'assets/gasoline_cost.png';
      case 9:
        return 'assets/medical.png';
      case 10:
        return 'assets/beauty.png';
      case 11:
        return 'assets/other.png';
      default:
        return 'assets/other.png';
    }
  }

  String getText(BuildContext context, int idTypeTransaction) {
    final localizations = AppLocalizations.of(context)!; // ใช้ AppLocalizations
    switch (idTypeTransaction) {
      case 1:
        return localizations.food; // เปลี่ยนให้ใช้ค่าใน AppLocalizations
      case 2:
        return localizations.travelexpenses;
      case 3:
        return localizations.waterbill;
      case 4:
        return localizations.electricitybill;
      case 5:
        return localizations.internetcost;
      case 6:
        return localizations.housecost;
      case 7:
        return localizations.carfare;
      case 8:
        return localizations.gasolinecost;
      case 9:
        return localizations.medicalexpenses;
      case 10:
        return localizations.beautyexpenses;
      case 11:
        return localizations.other;
      default:
        return localizations.other;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchBudgetData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        }
        final localizations = AppLocalizations.of(context)!;
        final budgetList = snapshot.data!;

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: budgetList.length,
          itemBuilder: (context, index) {
            final budgetData = budgetList[index];
            final double balance = budgetData['balance'] ?? 0.0;
            final double progress = budgetData['progress'] > 1.0 ? 1.0 : budgetData['progress']; // จำกัดค่าไม่ให้เกิน 1.0 (100%)
            final int idTypeTransaction = budgetData['idTypeTransaction'] ?? 0;

            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: 20, right: 20, bottom: 0, top: index == 0 ? 0 : 5,
                  ),
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[200],
                            ),
                            child: Image.asset(
                              getImagePath(idTypeTransaction),
                              width: 35,
                              height: 35,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getText(context, idTypeTransaction), // ส่ง context
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: const Color.fromARGB(255, 38, 38, 38),
                                  ),
                                ),
                                Text(
                                  '${localizations.spent} ${balance.toStringAsFixed(0)} ${localizations.thb}',
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 149, 149, 149),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${(progress * 100).toStringAsFixed(0)}%',  // จำกัดค่าไม่ให้เกิน 100%
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 38, 38, 38),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 68, top: 0, bottom: 0), // ลดระยะห่างจากด้านล่าง
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          color: progress > 0.8 ? Colors.red : Colors.blue,
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1.5,
                  color: const Color.fromARGB(255, 217, 217, 217),
                  indent: 30,
                  endIndent: 30,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
