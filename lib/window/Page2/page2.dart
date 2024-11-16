import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vongola/database/db_manage.dart';
import 'package:intl/intl.dart';
import 'package:vongola/window/Page1/pageAddLog.dart';
import 'package:vongola/window/Page2/Chart.dart';
import 'package:vongola/window/Page2/Compare.dart';
import 'package:vongola/window/Page2/Status.dart';
import 'Compare.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<Map<String, dynamic>> selectedDateExpenses = [];
  DateTime? selectedDate;
  Set<DateTime> markedDates = {};
  DateTime? currentSelectedDate;

  final Map<String, String> typeImage = {
    'Food': 'assets/food.png',
    'Travel expenses': 'assets/travel_expenses.png',
    'Water bill': 'assets/water_bill.png',
    'Electricity bill': 'assets/electricity_bill.png',
    'Internet cost':'assets/internet.png',
    'House cost': 'assets/house.png',
    'Car fare': 'assets/car.png',
    'Gasoline cost': 'assets/gasoline_cost.png',
    'Medical expenses': 'assets/medical.png',
    'Beauty expenses': 'assets/beauty.png',
    'Other': 'assets/other.png',
    'IC': 'assets/money.png'
  };


  @override
  void initState() {
    super.initState();
    _fetch_Mark_Dates();
  }

  Future<void> _fetch_Mark_Dates() async {
    final List<Map<String, dynamic>> result = await DatabaseManagement.instance.rawQuery(
        '''
      SELECT DISTINCT DATE(date_user) as date_user 
      FROM Transactions
        '''
    );
    setState(() {
      markedDates =
          result.map((data) => DateTime.parse(data['date_user'])).toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text(localizations!.dashboard),
        ),
        elevation: 500.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Color(0xFEF7FFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
       ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TableCalendar(
                  locale: Localizations.localeOf(context).toString(),
                  firstDay: DateTime(2023, 1, 1),
                  lastDay: DateTime(2100, 1, 1),
                  focusedDay: DateTime.now(),
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                  },
                  selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      selectedDate = selectedDay;
                      print("________[ s e l e c t  d a y ]__________");
                      print(selectedDay);
                      DateTime dateOnly = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
                      print("Selected date dateonly: $dateOnly");
                      _showDateDetailsDialog(dateOnly);
                    });
                  },

                  calendarBuilders: CalendarBuilders(
                    markerBuilder:(context, date, events){
                      if (markedDates.any((markedDate) => markedDate.year == date.year &&
                          markedDate.month == date.month && markedDate.day == date.day)) {
                        return Positioned(
                          bottom: 1,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color.fromARGB(255, 91, 92, 91),
                            ),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextFormatter: (date, locale) {
                      return DateFormat('dd MMMM yyyy', locale).format(date); // ตั้งค่าฟอร์แมทวันที่แบบกำหนดเอง
                    },
                    titleTextStyle: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: const Color.fromARGB(255, 90, 216, 255),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 137, 176),
                      shape: BoxShape.circle,
                    ),
                    defaultTextStyle: TextStyle(
                      fontSize: 15.0,
                    ),
                    weekendTextStyle: TextStyle(
                      fontSize: 14.0,
                      color: Colors.red,
                    ),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    weekendStyle: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChartPage()),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue, // สีของขอบ
                                  width: 2.0, // ความกว้างของขอบ
                                ),
                                borderRadius: BorderRadius.circular(10), // กำหนดขอบโค้งมน
                              ),
                              padding: EdgeInsets.all(8), // ระยะห่างระหว่างขอบและเนื้อหา
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/pie-chart.png', // ชื่อไฟล์รูปภาพ
                                    width: 80, // ปรับขนาดตามที่ต้องการ
                                    height: 60,
                                  ),
                                  SizedBox(height: 5), // ระยะห่างระหว่างรูปภาพกับข้อความ
                                  Text(localizations!.chart),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),


                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Status()), // แก้ชื่อคลาสที่ถูกต้อง
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue, // สีของขอบ
                                  width: 2.0, // ความกว้างของขอบ
                                ),
                                borderRadius: BorderRadius.circular(10), // กำหนดขอบโค้งมน
                              ),
                              padding: EdgeInsets.all(8), // ระยะห่างระหว่างขอบและเนื้อหา
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/notes.png', // ชื่อไฟล์รูปภาพ
                                    width: 80, // ปรับขนาดตามที่ต้องการ
                                    height: 60,
                                  ),
                                  SizedBox(height: 5), // ระยะห่างระหว่างรูปภาพกับข้อความ
                                  Text(localizations!.record),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),

                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ComparePage()), // แก้ชื่อคลาสที่ถูกต้อง
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue, // สีของขอบ
                                  width: 2.0, // ความกว้างของขอบ
                                ),
                                borderRadius: BorderRadius.circular(10), // กำหนดขอบโค้งมน
                              ),
                              padding: EdgeInsets.all(8), // ระยะห่างระหว่างขอบและเนื้อหา
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/compare.png', // ชื่อไฟล์รูปภาพ
                                    width: 80, // ปรับขนาดตามที่ต้องการ
                                    height: 60,
                                  ),
                                  SizedBox(height: 5), // ระยะห่างระหว่างรูปภาพกับข้อความ
                                  Text(localizations!.compare),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )


                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _showDateDetailsDialog(DateTime date) async{
    currentSelectedDate = date;
    String dateString = date.toIso8601String().split('T')[0];
    await _fetchcalendarDay(dateString);
    showDialog(
      context: context,
      builder: (BuildContext context){
        final localizations = AppLocalizations.of(context)!;
        final screenHeight = MediaQuery.of(context).size.height;
        return AlertDialog(
          title: Text(DateFormat(' dd MMMM yyyy', localizations.localeName).format(date)
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: screenHeight * 0.7,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selectedDateExpenses.isEmpty)
                      Column(
                        children: [
                          Image.asset(
                            'assets/Zzz.png', width: 100, height: 100, fit: BoxFit.cover,
                          ),
                          Text(localizations.noRecordsForThisDay, style: TextStyle(fontSize: 16)),
                        ],
                      )
                    else
                      ...selectedDateExpenses.map((expense) {
                        String imagetype = 'assets/other.png';
                        String expenseType = localizations.other;
                        if (expense['incomeexpense'] == 0) {
                          imagetype = 'assets/wallet_color.png';
                          expenseType = localizations.income;
                        } else if (expense['type'] == 'Food' && expense['incomeexpense'] == 1) {
                          imagetype = 'assets/food.png';
                          expenseType = localizations.food;
                        } else if (expense['type'] == 'Travel expenses' && expense['incomeexpense'] == 1) {
                          imagetype = 'assets/travel_expenses.png';
                          expenseType = localizations.travelexpenses;
                        } else if (expense['type'] == 'Water bill' && expense['incomeexpense'] == 1) {
                          imagetype = 'assets/water_bill.png';
                          expenseType = localizations.waterbill;
                        } else if (expense['type'] == 'Internet cost' && expense['incomeexpense'] == 1) {
                          imagetype = 'assets/internet.png';
                          expenseType = localizations.internetcost;
                        } else if (expense['type'] == 'Electricity bill' && expense['incomeexpense'] == 1) {
                          imagetype = 'assets/electricity_bill.png';
                          expenseType = localizations.electricitybill;
                        } else if (expense['type'] == 'House cost' && expense['incomeexpense'] == 1) {
                          imagetype = 'assets/house.png';
                          expenseType = localizations.housecost;
                        } else if (expense['type'] == 'Car fare' && expense['incomeexpense'] == 1) {
                          imagetype = 'assets/car.png';
                          expenseType = localizations.carfare;
                        } else if (expense['type'] == 'Gasoline cost' && expense['incomeexpense'] == 1) {
                          imagetype = 'assets/gasoline_cost.png';
                          expenseType = localizations.gasolinecost;
                        } else if (expense['type'] == 'Medical expenses' && expense['incomeexpense'] == 1) {
                          imagetype = 'assets/medical.png';
                          expenseType = localizations.medicalexpenses;
                        } else if (expense['type'] == 'Beauty expenses' && expense['incomeexpense'] == 1) {
                          imagetype = 'assets/beauty.png';
                          expenseType = localizations.beautyexpenses;
                        }
                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  imagetype,
                                  height: 50,
                                  width: 50,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        expense['incomeexpense'].toString() == '0'
                                            ? localizations.income
                                            : expenseType,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontWeight: FontWeight.bold)
                                      ),
                                      Text(
                                        '${localizations.amount} ${expense['amount']}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (expense['memo'] != null && expense['memo'].isNotEmpty)
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                              size: 16,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              ' ${expense['memo']}',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.edit_note, color: Colors.blue),
                                        iconSize: 20,
                                        padding: EdgeInsets.all(0),
                                        constraints: BoxConstraints(
                                          minWidth: 30,
                                          minHeight: 30,
                                        ),
                                        onPressed:(){
                                          _showEditExpenseDialog(
                                              expense['ID_transaction_Primary'],
                                                  (amount, memo) {
                                                _updateExpense(
                                                    expense['ID_transaction_Primary'],
                                                    amount, memo);
                                              });
                                        },
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.close_rounded, color: Colors.red),
                                        iconSize: 20,
                                        padding: EdgeInsets.all(0),
                                        constraints: BoxConstraints(
                                          minWidth: 30,
                                          minHeight: 30,
                                        ),
                                        onPressed: (){
                                          _deleteExpense(expense['ID_transaction_Primary']);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Divider(
                              color: Colors.grey, // สีเส้นแบ่ง
                              thickness: 0.5,
                            ),
                          ],
                        );
                      }).toList(),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด Dialog
              },
              child: Text(localizations.close), // ใช้ localizations
            ),
          ],
        );
      },
    );
  }


  void _showEditExpenseDialog(int id, Function(double, String) onSave) {
    TextEditingController amountController = TextEditingController();
    TextEditingController memoController = TextEditingController();
    final localizations = AppLocalizations.of(context)!;
    var expense = selectedDateExpenses.firstWhere((expense) => expense['ID_transaction_Primary'] == id);
    amountController.text = expense['amount'].toString();
    memoController.text = expense['memo'].toString();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.editExpense),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: localizations.amount),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: memoController,
                decoration: InputDecoration(labelText: localizations.memo),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              }, child: Text(localizations.calcel),
            ),
            TextButton(
              onPressed: (){
                onSave(double.parse(amountController.text),
                    memoController.text);
                Navigator.of(context).pop();
                Future.delayed(Duration(milliseconds: 100), (){
                  _showDateDetailsDialog(currentSelectedDate!);
                  Navigator.of(context).pop();
                });
              },
              child: Text(localizations.save),
            ),
          ],
        );
      },
    );
  }



  Future<void> _updateExpense(int id, double amount, String memo) async {
    Map<String,dynamic> updatedRow = {
      'ID_transaction': id,
      'amount_transaction': amount,
      'memo_transaction': memo,
    };
    await DatabaseManagement.instance.updateTransaction(updatedRow);
    setState(() {
      selectedDateExpenses = selectedDateExpenses.map((expense) {
        if (expense['ID_transaction_Primary'] == id) {
          return {
            ...expense,
            'amount': amount,
            'memo': memo,
          };
        }
        return expense;
      }).toList();
    });
    await _fetch_Mark_Dates();
  }

  Future<void> _deleteExpense(int id) async {
    int deletedCount = await DatabaseManagement.instance.deleteTransaction(id);
    if (deletedCount > 0) {
      print('Deleted successfully!');
      setState(() {
        selectedDateExpenses.removeWhere((expense) => expense['ID'] == id);
      });
      await _fetch_Mark_Dates();
      Navigator.of(context).pop();
      _showDateDetailsDialog(currentSelectedDate!);
    } else {
      print('No data deleted.');
    }
    print('delete ID---------------: $id');
    print(deletedCount);
  }


  Future<void> _fetchcalendarDay(String date) async {
    print("Fetching data for date: $date");
    DateTime startDate = DateTime.parse(date);
    print('startDate');
    print(startDate);
    print('date *********************');
    print(date);

    final List<Map<String, dynamic>> result = await DatabaseManagement.instance
        .rawQuery(
      '''
    SELECT *
      FROM Transactions
      JOIN Type_transaction ON Transactions.ID_type_transaction = Type_transaction.ID_type_transaction
      WHERE DATE(Transactions.date_user) = '${startDate.year}-${startDate.month
          .toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(
          2, '0')}'
      ''',
    );
    print("__________________");
    print('${startDate.year}-${startDate.month}-${startDate.day}');
    print("__________________");
    print("________result__________");
    print(result);
    setState(() {
      selectedDateExpenses = result.map((data) {
        return {
          'type': data['type_transaction'] ?? '-',
          'amount': data['amount_transaction'] ?? 0.0,
          'memo': data['memo_transaction'] ?? '-',
          'ID': data['ID_type_transaction'] ?? '-',
          'incomeexpense': data['type_expense'] ?? '-',
          'ID_transaction_Primary': data['ID_transaction'] ?? '-',
        };
      }).toList();
    });
  }
}

