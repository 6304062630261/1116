import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../database/db_manage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoDataDashBoard extends StatefulWidget {
  @override
  _NoDataCardDashBoardState createState() => _NoDataCardDashBoardState();
}

class _NoDataCardDashBoardState extends State<NoDataDashBoard> {
  String monthName = '';
  String year = '';

  @override
  void initState() {
    super.initState();
    _getCurrentMonthAndYear();
  }

  void _getCurrentMonthAndYear() {
    DateTime now = DateTime.now(); 
    monthName = DateFormat('MMMM').format(now);
    year = DateFormat('yyyy').format(now);
    setState(() {}); // เรียกใช้ setState เพื่ออัพเดต UI
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Color.fromARGB(255, 9, 209, 220), // Card color
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30), // Color when tapped
          child: SizedBox(
            width: 320, // Card width
            height: 130, // Card height
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Align text to the top
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, top: 12), 
                  child: Text(
                    'Summary for $monthName $year',
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
                        color: Color.fromARGB(255, 235, 249, 255), // Card color
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          child: SizedBox(
                            width: 180, // Card width
                            height: 65, // Card height
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Income',
                                        style: TextStyle(
                                          color: const Color.fromARGB(255, 53, 53, 53), 
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '0.00', 
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' ฿',
                                              style: TextStyle(
                                                color: const Color.fromARGB(255, 53, 53, 53),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Expense',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '0.00',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' ฿',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
                        child: InkWell(
                          child: SizedBox(
                            width: 90,
                            height: 65,
                            child: Center(
                              child: Text(
                                '0.0 %',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 38, 38, 38),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}