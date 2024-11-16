import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../database/db_manage.dart';
import 'noDataDashBoard.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:auto_size_text/auto_size_text.dart';
class CardDashBoard extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> cardFuture;

  CardDashBoard({required this.cardFuture});

  @override
  _CardDashBoardState createState() => _CardDashBoardState();
}

class _CardDashBoardState extends State<CardDashBoard> {
  double expensePercentage = 0.0;
  double totalExpense = 0.0;
  double totalIncome = 0.0;
  String monthName = '';
  String year = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshData(); // อัปเดตข้อมูลเดือนและปีตาม locale ของผู้ใช้ทุกครั้งที่มีการเปลี่ยนแปลง dependencies
  }

  @override
  void didUpdateWidget(CardDashBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cardFuture != widget.cardFuture) {
      _refreshData(); // รีเฟรชข้อมูลเมื่อ cardFuture เปลี่ยนแปลง
    }
  }

  Future<void> _refreshData() async {
    DateTime now = DateTime.now();
    monthName = DateFormat('MMMM', Localizations.localeOf(context).languageCode).format(now);
    year = DateFormat('yyyy').format(now);

    List<Map<String, dynamic>> transactions = await DatabaseManagement.instance.rawQuery(
        '''
      SELECT amount_transaction, type_expense FROM [Transactions]
      WHERE strftime('%m', date_user) = ? AND strftime('%Y', date_user) = ?
      ''',
        [DateFormat('MM').format(now), DateFormat('yyyy').format(now)]
    );

    double income = 0.0;
    double expense = 0.0;

    for (var transaction in transactions) {
      double amount = transaction['amount_transaction'];
      bool isExpense = transaction['type_expense'] == 1;

      if (isExpense) {
        expense += amount;
      } else {
        income += amount;
      }
    }

    setState(() {
      totalIncome = income;
      totalExpense = expense;
      expensePercentage = (totalIncome > 0) ? (totalExpense / totalIncome) * 100 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.cardFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: NoDataDashBoard());
        } else {
          // ใช้ NumberFormat เพื่อจัดรูปแบบจำนวนเงิน
          final NumberFormat currencyFormat = NumberFormat("#,##0.00", "en_US");
          final localizations = AppLocalizations.of(context)!;
          return Center(
            child: Card(
              color: Color.fromARGB(255, 9, 209, 220),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                child: SizedBox(
                  width: 320,
                  height: 130,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 20, top: 12),
                        child: Text(
                          '${localizations!.summaryFor} $monthName $year',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 15),
                            child: Card(
                              color: Color.fromARGB(255, 235, 249, 255),
                              clipBehavior: Clip.hardEdge,
                              child: SizedBox(
                                width: 180,
                                height: 65,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            localizations!.income,
                                            style: TextStyle(
                                              color: const Color.fromARGB(255, 53, 53, 53),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min, // This minimizes the space taken by the Row
                                            children: [
                                              AutoSizeText(
                                                ' ${currencyFormat.format(totalIncome)}',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                minFontSize: 12,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                '฿',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(255, 53, 53, 53),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            localizations!.expense,
                                            style: TextStyle(
                                              color: const Color.fromARGB(255, 53, 53, 53),
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min, // This minimizes the space taken by the Row
                                            children: [
                                              AutoSizeText(
                                                ' ${currencyFormat.format(totalExpense)}',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                minFontSize: 12,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                '฿',
                                                style: TextStyle(
                                                  color: const Color.fromARGB(255, 53, 53, 53),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  )

                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                          Container(
                            padding: EdgeInsets.only(left: 0),
                            child: Card(
                              color: Color.fromARGB(255, 218, 244, 255),
                              clipBehavior: Clip.hardEdge,
                              child: SizedBox(
                                width: 90,
                                height: 65,
                                child: Center(

                                    child: AutoSizeText(
                                    '${expensePercentage.toStringAsFixed(1)} %',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(255, 38, 38, 38),
                                    ),
                                      minFontSize:10,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )

                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
