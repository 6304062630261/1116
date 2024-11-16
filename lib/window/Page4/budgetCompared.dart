import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // สำหรับจัดการวันที่
import '../../database/db_manage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:auto_size_text/auto_size_text.dart';
class BudgetComparedList extends StatefulWidget {
  @override
  _BudgetComparedListState createState() => _BudgetComparedListState();
}

class _BudgetComparedListState extends State<BudgetComparedList> {
  Map<int, bool> _alertShownMap = {}; // เก็บสถานะแจ้งเตือนแยกตาม idTypeTransaction

  @override
  void initState() {
    super.initState();
    _checkIfAlertShownToday(); // เรียกใช้งานฟังก์ชันตรวจสอบเมื่อเริ่มต้น
  }

  // ตรวจสอบว่าการแจ้งเตือนเคยแสดงในวันนี้สำหรับแต่ละ idTypeTransaction หรือยัง
  Future<void> _checkIfAlertShownToday() async {
    final prefs = await SharedPreferences.getInstance();
    final todayMidnight = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final today = DateFormat('yyyy-MM-dd').format(todayMidnight);

    for (int idTypeTransaction = 1; idTypeTransaction <= 10; idTypeTransaction++) {
      final lastAlertDate = prefs.getString('lastAlertDate_$idTypeTransaction'); // วันที่ที่แจ้งเตือนล่าสุดของแต่ละ id
      if (lastAlertDate == today) {
        _alertShownMap[idTypeTransaction] = true; // แจ้งเตือนถูกแสดงแล้วในวันนี้
      } else {
        _alertShownMap[idTypeTransaction] = false; // แจ้งเตือนยังไม่ถูกแสดง
      }
    }
  }

  // บันทึกวันที่ปัจจุบันเมื่อแสดงการแจ้งเตือน
  Future<void> _setAlertShownToday(int idTypeTransaction) async {
    final prefs = await SharedPreferences.getInstance();
    final todayMidnight = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final today = DateFormat('yyyy-MM-dd').format(todayMidnight);
    await prefs.setString('lastAlertDate_$idTypeTransaction', today); // บันทึกวันที่ปัจจุบันแยกตาม id
  }

  Future<List<Map<String, dynamic>>> fetchBudgetData() async {
    final db = DatabaseManagement.instance;
    final now = DateTime.now();

    // ดึง budget ที่วันปัจจุบันยังไม่เกิน columnDateEnd
    final budgets = await db.queryAllBudgets();
    List<Map<String, dynamic>> filteredBudgets = [];

    for (var budget in budgets) {
      if (DateTime.parse(budget['date_end']).isAfter(now)) {
        print("Nowwwwwwww = $now");
        // ดึง balance (ผลรวมของ transaction ในช่วงเวลาที่กำหนด)
        final transactions = await db.queryAllTransactions();
        double balance = 0.0;
        for (var transaction in transactions) {
          if (transaction['ID_type_transaction'] == budget['ID_type_transaction']) {
            final transactionDate = DateTime.parse(transaction['date_user']);
            if (transactionDate.isAfter(DateTime.parse(budget['date_start'])) &&
                transactionDate.isBefore(DateTime.parse(budget['date_end']))) {
              balance += transaction['amount_transaction'];
            }
          }
        }

        final double budgetAmount = budget['capital_budget'];
        final double progress = budgetAmount > 0 ? balance / budgetAmount : 0.0;

        filteredBudgets.add({
          'idTypeTransaction': budget['ID_type_transaction'],
          'budget': budgetAmount,
          'balance': balance,
          'progress': progress,
        });
      }
    }

    return filteredBudgets;
  }

  // ฟังก์ชันแมป idTypeTransaction กับ imagePath
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
        return 'assets/other.png'; // กรณีที่ไม่มีการแมป
    }
  }

  String getText(int idTypeTransaction) {
    final localizations = AppLocalizations.of(context)!;
    switch (idTypeTransaction) {
      case 1:
        return localizations.food;
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
        return localizations.other; //ไม่แมป
    }
  }

  void _showAlertDialog(BuildContext context, double balance, int idTypeTransaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Row(
            children: [
              Image.asset(
                'assets/warning_1.png',
                width: 40,
                height: 40,
              ),
              SizedBox(width: 8),
              Text(localizations.warning),
            ],
          ),
          content: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${localizations.thebudgetfor} ',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: getText(idTypeTransaction), // ส่ง idTypeTransaction เท่านั้น
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: localizations.isover,
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: '${localizations.theBalanceis} ',
                  style: TextStyle(color: Colors.red),
                ),
                TextSpan(
                  text: '${balance.toStringAsFixed(2)} ฿.',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _setAlertShownToday(idTypeTransaction);
                },
                child: Text(localizations.close),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchBudgetData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text(localizations.nodata));
        }

        final budgetList = snapshot.data!;

        return ListView.builder(
          itemCount: budgetList.length,
          itemBuilder: (context, index) {
            final budgetData = budgetList[index];
            final double budget = budgetData['budget'];
            final double balance = budgetData['budget'] - budgetData['balance'];
            final double progress = budgetData['progress'];
            final int idTypeTransaction = budgetData['idTypeTransaction'];

            // แสดงการแจ้งเตือนเมื่อ progress > 0.8 และยังไม่เคยแสดงมาก่อนในวันนี้สำหรับ id นี้
            if (progress > 0.8 && _alertShownMap[idTypeTransaction] == false) {
              _alertShownMap[idTypeTransaction] = true; // อัปเดตว่าแสดงแจ้งเตือนแล้ว
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showAlertDialog(context, balance, idTypeTransaction); // เปลี่ยนจาก getText(idTypeTransaction) เป็น balance
              });
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color.fromARGB(255, 217, 217, 217),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                    child: Image.asset(
                      getImagePath(idTypeTransaction), // ใช้ฟังก์ชัน getImagePath เพื่อดึงรูปภาพที่ต้องการ
                      width: 40,
                      height: 40,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          getText(idTypeTransaction), // ชื่อประเภทงบประมาณ
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          minFontSize: 12, // ขนาดเล็กสุดที่จะย่อให้
                          overflow: TextOverflow.ellipsis, // ตัดข้อความเกินด้วย "..."
                        ),

                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(localizations.budget,),
                            Text('${budget.toStringAsFixed(0)} ฿'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(localizations.balance),
                            Text('${balance.toStringAsFixed(0)} ฿'),
                          ],
                        ),
                        SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          color: progress > 0.8 ? Colors.red : Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}