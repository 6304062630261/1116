import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class S {
  S(this.localeName);

  final String localeName;

  static Future<S> load(Locale locale) {
    final String name = locale.toString();
    return Future.value(S(name)); // ใช้ Future.value() ที่นี่
  }

  static S of(BuildContext context) {
    final S? instance = Localizations.of<S>(context, S);
    assert(instance != null, 'No S found in context');
    return instance!; // ใช้ ! เพื่อบอกว่า instance จะไม่เป็น null ที่นี่
  }

  String get transactionType => Intl.message(
    'ประเภทธุรกรรม',
    name: 'transactionType',
    locale: localeName,
  );

  String get income => Intl.message(
    'รายได้',
    name: 'Income',
    locale: localeName,
  );

  String get expense => Intl.message(
    'รายจ่าย',
    name: 'Expense',
    locale: localeName,
  );

  String get pleaseSelectTransactionType => Intl.message(
    'กรุณาเลือกประเภทธุรกรรม',
    name: 'Please select a transaction type',
    locale: localeName,
  );

  String get category => Intl.message(
    'ประเภท',
    name: 'Category',
    locale: localeName,
  );

  String get pleaseSelectCategory => Intl.message(
    'กรุณาเลือกประเภทรายจ่าย',
    name: 'Please select a category',
    locale: localeName,
  );

  String get food => Intl.message(
    'อาหาร',
    name: 'Food',
    locale: localeName,
  );

  String get travelExpenses => Intl.message(
    'ค่าเดินทาง',
    name: 'Travel expenses',
    locale: localeName,
  );

  String get waterBill => Intl.message(
    'ค่าน้ำ',
    name: 'Water bill',
    locale: localeName,
  );

  String get electricityBill => Intl.message(
    'ค่าไฟ',
    name: 'Electricity bill',
    locale: localeName,
  );

  String get internetCost => Intl.message(
    'ค่าอินเทอร์เน็ต',
    name: 'Internet cost',
    locale: localeName,
  );

  String get houseCost => Intl.message(
    'ค่าบ้าน',
    name: 'House cost',
    locale: localeName,
  );

  String get carFare => Intl.message(
    'ค่ารถ',
    name: 'Car fare',
    locale: localeName,
  );

  String get gasolineCost => Intl.message(
    'ค่าน้ำมัน',
    name: 'Gasoline cost',
    locale: localeName,
  );

  String get medicalExpenses => Intl.message(
    'ค่ายา',
    name: 'Medical expenses',
    locale: localeName,
  );

  String get beautyExpenses => Intl.message(
    'ค่าเครื่องสำอาง',
    name: 'Beauty expenses',
    locale: localeName,
  );

  String get other => Intl.message(
    'อื่นๆ',
    name: 'Other',
    locale: localeName,
  );

  String get amount => Intl.message(
    'จำนวนเงิน',
    name: 'Amount',
    locale: localeName,
  );

  String get pleaseEnterAmount => Intl.message(
    'กรุณากรอกจำนวนเงิน',
    name: 'Please enter the amount of money',
    locale: localeName,
  );

  String get pleaseEnterValidNumber => Intl.message(
    'กรุณาใส่ตัวเลขที่ถูกต้อง',
    name: 'Please enter a valid number',
    locale: localeName,
  );

  String get pickImage => Intl.message(
    'เลือกภาพ',
    name: 'Pick Image',
    locale: localeName,
  );

  String get slipAlreadyRecorded => Intl.message(
    'สลิปนี้เคยถูกบันทึกแล้ว',
    name: 'This slip has already been recorded.',
    locale: localeName,
  );

  String get invalidCategorySelected => Intl.message(
    'การเลือกประเภทไม่ถูกต้อง',
    name: 'Invalid category selected.',
    locale: localeName,
  );

  String get save => Intl.message(
    'บันทึก',
    name: 'Save',
    locale: localeName,
  );

  String get save1 => Intl.message(
    'บันทึก',
    name: 'Save1',
    locale: localeName,
  );
}

// Class สำหรับ LocalizationsDelegate
class SDelegate extends LocalizationsDelegate<S> {
  const SDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'th'].contains(locale.languageCode);

  @override
  Future<S> load(Locale locale) => S.load(locale);

  @override
  bool shouldReload(SDelegate old) => false;
}
