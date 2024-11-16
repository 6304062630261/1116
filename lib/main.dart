import 'package:flutter/material.dart';
import 'window/Page1/page1.dart';
import 'window/Page1/pageAddLog.dart';
import 'window/Page2/page2.dart';
import 'window/Page3/page3.dart';
import 'window/Page4/page4.dart';
import '../database/db_manage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseManagement.instance.database;  // Initialize the database
  await DatabaseManagement.instance.showAllData();  // Call the function to show data
  await initializeDateFormatting('th', null);  // Initialize ข้อมูล locale สำหรับภาษาไทย

  runApp(MyApp());  // เริ่มแอปพลิเคชัน
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        ...AppLocalizations.localizationsDelegates, // ใช้ spread operator เพื่อแยกแต่ละ delegate ออกมา
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: AppLocalizations.supportedLocales, // ใช้ supported locales ที่กำหนดใน AppLocalizations
      // home: MyHomePage(),
      initialRoute: '/',
      routes: {
        '/':(context) => MyHomePage(),
        '/addTransactionPage':(context) => const AddTransaction(),
        '/Page1':(context) =>  Page1(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Page1(),
    Page2(),
    Page3(),
    Page4(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 0 ? 'assets/home_color.png' : 'assets/home_gray.png',
              width: 30,
              height: 30,
            ),
            label: AppLocalizations.of(context)!.home, // ใช้ localization
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 1 ? 'assets/dashboard_color.png' : 'assets/dashboard_gray.png',
              width: 30,
              height: 30,
            ),
            label: AppLocalizations.of(context)!.dashboard, // ใช้ localization
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 2 ? 'assets/wallet_color.png' : 'assets/wallet_gray.png',
              width: 30,
              height: 30,
            ),
            label: AppLocalizations.of(context)!.wallet, // ใช้ localization
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              _selectedIndex == 3 ? 'assets/budget_color.png' : 'assets/budget_gray.png',
              width: 30,
              height: 30,
            ),
            label: AppLocalizations.of(context)!.budget, // ใช้ localization
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 50, 50, 50),
        unselectedItemColor: Colors.grey[600],
      ),
    );
  }
}
