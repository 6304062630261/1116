// final String tableTransaction = "Transactions";
// final String tableBudget = "Budget";
// final String tableTypeTransaction = "Type_transaction";

// class TransactionFields {                               // กำหนดฟิลด์ข้อมูลของตาราง
//   // สร้างเป็นลิสรายการสำหรับคอลัมน์ฟิลด์
//   static final List<String> values = [                  
//     columnIdTransaction, columnDateUser, columnAmountTransaction, columnTypeExpense, columnMemoTransaction, columnReferralCode, columnIdTypeTransaction, columnTypeTransaction, columnIdBudget, columnCapitalBudget, columnDateStart, columnDateEnd   
//   ];
 
//   static final String columnIdTransaction = 'ID_transaction';
//   static final String columnDateUser = 'date_user';
//   static final String columnAmountTransaction = 'amount_transaction';
//   static final String columnTypeExpense = 'type_expense';
//   static final String columnMemoTransaction = 'memo_transaction';
//   static final String columnReferralCode = 'referral_code';

//   static final String columnIdTypeTransaction = 'ID_type_transaction';
//   static final String columnTypeTransaction = 'type_transaction';
  
//   static final String columnIdBudget = 'ID_budget';
//   static final String columnCapitalBudget = 'capital_budget';
//   static final String columnDateStart = 'date_start';
//   static final String columnDateEnd = 'date_end';
  
// }
 
// // ส่วนของ Data Model transaction
// class transaction {
//   final int? columnIdTransaction; // จะใช้ค่าจากที่ gen ในฐานข้อมูล
//   final DateTime columnDateUser; 
//   final double columnAmountTransaction;
//   final bool columnTypeExpense;
//   final String? columnMemoTransaction;
//   final String? columnReferralCode;
 
//   // constructor
//   const transaction({
//     this.columnIdTransaction,
//     required this.columnDateUser,
//     required this.columnAmountTransaction,
//     required this.columnTypeExpense,
//     this.columnMemoTransaction,
//     this.columnReferralCode,
//   });
 
//   // ฟังก์ชั่นสำหรับ สร้างข้อมูลใหม่ โดยรองรับแก้ไขเฉพาะฟิลด์ที่ต้องการ
//   transaction copy({
//    int? columnIdTransaction, 
//    DateTime? columnDateUser, 
//    double? columnAmountTransaction,
//    bool? columnTypeExpense,
//    String? columnMemoTransaction,
//    String? columnReferralCode,
//   }) =>
//     transaction(
//       columnIdTransaction: columnIdTransaction ?? this.columnIdTransaction, 
//       columnDateUser: columnDateUser ?? this.columnDateUser,
//       columnAmountTransaction: columnAmountTransaction ?? this.columnAmountTransaction,
//       columnTypeExpense: columnTypeExpense ?? this.columnTypeExpense,
//       columnMemoTransaction: columnMemoTransaction ?? this.columnMemoTransaction,
//       columnReferralCode: columnReferralCode ?? this.columnReferralCode,
//     );
 
//   // สำหรับแปลงข้อมูลจาก Json เป็น object
//   static transaction fromJson(Map<String, Object?> json) =>  
//     transaction(
//       columnIdTransaction: json[TransactionFields.columnIdTransaction] as int?,
//       columnDateUser: DateTime.parse(json[TransactionFields.columnDateUser] as String),
//       columnAmountTransaction: double.parse(json[TransactionFields.columnAmountTransaction] as String),
//       columnTypeExpense: json[TransactionFields.columnTypeExpense] == 1,
//       columnMemoTransaction: json[TransactionFields.columnMemoTransaction] as String,
//       columnReferralCode: json[TransactionFields.columnReferralCode] as String,
//     );
 
//   // สำหรับแปลง object เป็น Json บันทึกลงฐานข้อมูล
//   Map<String, Object?> toJson() => {
//     TransactionFields.columnIdTransaction: columnIdTransaction,
//     TransactionFields.columnDateUser: columnDateUser.toIso8601String(),
//     TransactionFields.columnAmountTransaction: columnAmountTransaction,    
//     TransactionFields.columnTypeExpense: columnTypeExpense ? 1 : 0,
//     TransactionFields.columnMemoTransaction: columnMemoTransaction,
//   };
// }


// // ส่วนของ Data Model typeTransaction
// class typeTransaction {
//   final int? columnIdTypeTransaction; // จะใช้ค่าจากที่ gen ในฐานข้อมูล
//   final String? columnTypeTransaction;
 
//   // constructor
//   const typeTransaction({
//     this.columnIdTypeTransaction,
//     required this.columnTypeTransaction,
//   });
 
//   // ฟังก์ชั่นสำหรับ สร้างข้อมูลใหม่ โดยรองรับแก้ไขเฉพาะฟิลด์ที่ต้องการ
//   typeTransaction copy({
//    int? columnIdTypeTransaction, 
//    String? columnTypeTransaction,
//   }) =>
//     typeTransaction(
//       columnIdTypeTransaction: columnIdTypeTransaction ?? this.columnIdTypeTransaction, 
//       columnTypeTransaction: columnTypeTransaction ?? this.columnTypeTransaction,
//     );
 
//   // สำหรับแปลงข้อมูลจาก Json เป็น object
//   static typeTransaction fromJson(Map<String, Object?> json) =>  
//     typeTransaction(
//       columnIdTypeTransaction: json[TransactionFields.columnIdTypeTransaction] as int?,
//       columnTypeTransaction: json[TransactionFields.columnTypeTransaction] as String,
//     );
 
//   // สำหรับแปลง object เป็น Json บันทึกลงฐานข้อมูล
//   Map<String, Object?> toJson() => {
//     TransactionFields.columnIdTypeTransaction: columnIdTypeTransaction,
//     TransactionFields.columnTypeTransaction: columnTypeTransaction,
//   };
// }

// // ส่วนของ Data Model budget
// class budget {
//   final int? columnIdBudget; // จะใช้ค่าจากที่ gen ในฐานข้อมูล
//   final double columnCapitalBudget;
//   final DateTime? columnDateStart; 
//   final DateTime? columnDateEnd; 

//   // constructor
//   const budget({
//     this.columnIdBudget,
//     required this.columnCapitalBudget,
//     this.columnDateStart,
//     this.columnDateEnd,
//   });
 
//   // ฟังก์ชั่นสำหรับ สร้างข้อมูลใหม่ โดยรองรับแก้ไขเฉพาะฟิลด์ที่ต้องการ
//   budget copy({
//    int? columnIdBudget, 
//    double? columnCapitalBudget,
//    DateTime? columnDateStart,
//    DateTime? columnDateEnd, 
//   }) =>
//     budget(
//       columnIdBudget: columnIdBudget ?? this.columnIdBudget, 
//       columnCapitalBudget: columnCapitalBudget ?? this.columnCapitalBudget,
//       columnDateStart: columnDateStart ?? this.columnDateStart,
//       columnDateEnd: columnDateEnd ?? this.columnDateEnd,
//     );
 
//   // สำหรับแปลงข้อมูลจาก Json เป็น object
//   static budget fromJson(Map<String, Object?> json) =>  
//     budget(
//       columnIdBudget: json[TransactionFields.columnIdBudget] as int?,
//       columnCapitalBudget: double.parse(json[TransactionFields.columnCapitalBudget] as String),
//       columnDateStart: DateTime.parse(json[TransactionFields.columnDateStart] as String),
//       columnDateEnd: DateTime.parse(json[TransactionFields.columnDateEnd] as String),
//     );
 
//   // สำหรับแปลง object เป็น Json บันทึกลงฐานข้อมูล
//   Map<String, Object?> toJson() => {
//     TransactionFields.columnIdBudget: columnIdBudget,
//     TransactionFields.columnCapitalBudget: columnCapitalBudget,
//     TransactionFields.columnDateStart: columnDateStart?.toIso8601String(),
//     TransactionFields.columnDateEnd: columnDateEnd?.toIso8601String(),
//   };
// }