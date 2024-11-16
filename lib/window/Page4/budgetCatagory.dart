import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'pageAddBudget.dart';
import 'detailBudget.dart'; // เพิ่ม import สำหรับ detailBudget page
import '../../database/db_manage.dart'; // เพิ่ม import สำหรับ DatabaseManagement
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class Budgetcatagory extends StatefulWidget {
  @override
  _Budgetcatagory createState() => _Budgetcatagory();
}

class _Budgetcatagory extends State<Budgetcatagory> {
  final DatabaseManagement _databaseManagement = DatabaseManagement.instance; // อินสแตนซ์ของ DatabaseManagement

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.addBudgetCategory),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red.shade200, Color(0xFEF7FFFF)], // ไล่สีพื้นหลัง
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red[100]!, Color(0xFEF7FFFF)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Column(
            children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 16, left: 20, right: 20, top: 20),
              children: [
                _buildBudgetItem('assets/food.png', localizations.food, '1'),
                _buildBudgetItem('assets/travel_expenses.png', localizations.travelexpenses, '2'),
                _buildBudgetItem('assets/water_bill.png', localizations.waterbill, '3'),
                _buildBudgetItem('assets/electricity_bill.png', localizations.electricitybill, '4'),
                _buildBudgetItem('assets/internet.png', localizations.internetcost, '5'),
                _buildBudgetItem('assets/house.png',localizations.housecost, '6'),
                _buildBudgetItem('assets/car.png', localizations.carfare, '7'),
                _buildBudgetItem('assets/gasoline_cost.png', localizations.gasolinecost, '8'),
                _buildBudgetItem('assets/medical.png', localizations.medicalexpenses, '9'),
                _buildBudgetItem('assets/beauty.png', localizations.beautyexpenses, '10'),
                _buildBudgetItem('assets/other.png', localizations.other, '11'),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildBudgetItem(String imagePath, String label, String valued) {
    return GestureDetector(
      onTap: () async {
        // ตรวจสอบข้อมูลก่อนนำทาง
        bool shouldNavigateToDetail = await _checkBudgetAvailability(valued);
        if (shouldNavigateToDetail) {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailBudget(valued: valued),
            ),
          );
          if (result == true) {
            Navigator.pop(context, true); // ส่งค่า true กลับไปยัง page4.dart
          }
        } else {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBudget(valued: valued),
            ),
          );

          if (result == true) {
            Navigator.pop(context, true); // ส่งค่า true กลับไปยัง page4.dart
          }
        }
      },

      child: Container(

        margin: const EdgeInsets.only(bottom: 12),
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
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              child: Image.asset(
                imagePath,
                width: 40,
                height: 40,
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,

                    ),
                    maxLines: 1,
                    minFontSize: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _checkBudgetAvailability(String valued) async {
    // ดึงข้อมูลจากฐานข้อมูล
    var budgets = await _databaseManagement.queryAllBudgets();

    // หาข้อมูลที่ ID_type_transaction ตรงกับ valued
    var matchedBudgets = budgets.where((budget) => budget['ID_type_transaction'].toString() == valued);

    // ถ้าไม่มีข้อมูลที่ตรงกับ valued เลย ให้ return false
    if (matchedBudgets.isEmpty) {
      return false;
    }

    // ถ้ามีข้อมูลที่ตรงกับ valued
    for (var budget in matchedBudgets) {
      DateTime dateEnd;
      try {
        dateEnd = DateTime.parse(budget['date_end']);
      } catch (e) {
        print('Error parsing date: ${budget['date_end']}');
        continue; // ข้ามการวนลูปนี้ไปถ้าแปลงวันที่ล้มเหลว
      }

      // ตรวจสอบว่าเวลาปัจจุบันเกิน dateEnd หรือไม่
      if (DateTime.now().isBefore(dateEnd)) {
        return true; // ถ้าเวลาปัจจุบันยังไม่เกิน dateEnd
      }
    }

    // ถ้าทุกแถวที่ตรงกับ valued นั้นเวลาปัจจุบันเกิน dateEnd หมดแล้ว
    return false;
  }

}

