import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:scan/scan.dart';

class ImageOcrHelper {
  final ImagePicker _picker = ImagePicker();

  Future<Map<String, String?>> pickImageAndExtractText() async{
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return await extractTextFromImage(pickedFile.path);
    }
    return {'amount': null, 'datetime': null, 'memo': null, 'referral': null};
  }


  Future<Map<String, String?>> extractTextFromImage(String path) async{
    String? result = await Scan.parse(path);
    String extractedTextEng = await FlutterTesseractOcr.extractText(
      path,
      language: 'eng',
    );
    String extractedTextTha = await FlutterTesseractOcr.extractText(
      path,
      language: 'tha',
    );
    String extractedText = extractedTextTha;

    if (extractedText.isEmpty && extractedTextEng.isEmpty) {
      print("No text found.");
      return {'amount': null, 'datetime': null, 'memo': null, 'referral': null};
    }


    print("Extracted Text (Eng): $extractedTextEng");
    print("Extracted Text (Thai): $extractedText");

    final RegExp decimalPattern = RegExp(r'(?<!\S)(\d{1,3}(?:,\d{3})*)?\.\d{2}(?!\S)');
    final Iterable<Match> matches = decimalPattern.allMatches(extractedTextEng);

    double totalAmount = matches.isNotEmpty
        ? matches.map((match) {
      String numberString = match.group(0)!.replaceAll(',', '');
      print("Matched Decimal: $numberString");
      return double.parse(numberString);
    }).reduce((a, b) => a + b)
        : 0.0;

    String? formattedDateTime;

    final RegExp dateTimePattern = RegExp(
        r'(\d{1,2})\s(.?[มกพสตพธnQa].?)\s*.{0,5}\s*([คพยn])\s*.\s*(\d{2,4}).?\s*.?\s*([0|1|2|]\d{1}:\d{2}(:\d{2})?)'
    );

    final Match? dateTimeMatch = dateTimePattern.firstMatch(extractedText);
    print("DMAte : $dateTimeMatch");

    if (dateTimeMatch != null) {
      String day = dateTimeMatch.group(1)!.padLeft(2, '0');
      String monthText = '${dateTimeMatch.group(2)}${dateTimeMatch.group(3)}';
      String year = dateTimeMatch.group(4)!;
      String time = dateTimeMatch.group(5)!;
      print('day : $day');
      print('monthText : $monthText');
      print('year : $year');
      print('time : $time');

      Map<String, String> monthMap = {
        'ม ค': '01',
        'ก พ': '02', 'กุ พ': '02', 'n พ': '02',
        'มี ค': '03',
        'เม ย': '04',
        'พ ค': '05',
        'มิ ย': '06',
        'ก ค': '07', 'n ค': '07',
        'ส ค': '08',
        'ก ย': '09',
        'ต ค': '10', 'Q.n': '10', 'a.n': '10',
        'พ ย': '11',
        'ธ ค': '12',
      };
      String month = monthMap[monthText]!;

      if (year.length == 2) {
        year = '25' + year;
      }

      int extractedYear = int.parse(year);
      int currentYear = DateTime.now().year;
      if (extractedYear > currentYear) {
        extractedYear -= 543;
        print("Converted Year: $extractedYear");
      }
      year = extractedYear.toString();

      String hour = time.split(':')[0].padLeft(2, '0');
      String minute = time.split(':')[1].padLeft(2, '0');
      String second = time.split(':').length > 2 ? time.split(':')[2].padLeft(2, '0') : '00';
      String dateTimeString = '$year-$month-$day $hour:$minute:$second';

      print("dateTimeString: $dateTimeString");

      try {
        DateTime dateTime = DateTime.parse(dateTimeString);
        formattedDateTime = DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
      } catch (e) {
        print("Error parsing date: $e");
        formattedDateTime = null;
      }
    }

    if (formattedDateTime == null) {
      // เรียกใช้ RegExp สำหรับรูปแบบภาษาอังกฤษ
      RegExp dateTimePatternEng = RegExp(
          r'(\d{1,2})\s([A-Za-z]{3,4})\s*(\d{2,4}).?\s*.?\s*([0|1|2|]\d{1}:\d{2}(:\d{2})?)'
      );

      final Match? dateTimeMatchEng = dateTimePatternEng.firstMatch(extractedTextEng);
      print("DMAteEng : $dateTimeMatchEng");

      if (dateTimeMatchEng != null) {
        String dayEng = dateTimeMatchEng.group(1)!.padLeft(2, '0');
        String monthTextEng = '${dateTimeMatchEng.group(2)}';
        String yearEng = dateTimeMatchEng.group(3)!;
        String timeEng = dateTimeMatchEng.group(4)!;
        print('dayEng : $dayEng');
        print('monthTextEng : $monthTextEng');
        print('yearEng : $yearEng');
        print('timeEng : $timeEng');

        Map<String, String> monthMapEng = {
          'Jan': '01',
          'Feb': '02',
          'Mar': '03',
          'Apr': '04',
          'May': '05',
          'Jun': '06',
          'Jul': '07',
          'Aug': '08',
          'Sept': '09',
          'Oct': '10',
          'Nov': '11',
          'Dec': '12',
        };
        String monthEng = monthMapEng[monthTextEng]!;

        if (yearEng.length == 2) {
          yearEng = '20' + yearEng;
        }

        //HH:MM:SS
        String hourEng = timeEng.split(':')[0].padLeft(2, '0');
        String minuteEng = timeEng.split(':')[1].padLeft(2, '0');
        String secondEng = timeEng.split(':').length > 2 ? timeEng.split(':')[2].padLeft(2, '0') : '00';
        String dateTimeStringEng = '$yearEng-$monthEng-$dayEng $hourEng:$minuteEng:$secondEng';

        print("dateTimeStringEng: $dateTimeStringEng");

        try {
          DateTime dateTimeEng = DateTime.parse(dateTimeStringEng);
          formattedDateTime = DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTimeEng);
        } catch (e) {
          print("Error parsing dateEng: $e");
          formattedDateTime = null;
        }
      }
    }

    print("Formatted DateTime: $formattedDateTime");

    final RegExp memoPattern = RegExp(
        r'(บ.{0,3}น.{0,3}ท.{0,3}ก.{1,12}า)\s*:\s*(.{1,150})'
    );
    final Match? memoMatch = memoPattern.firstMatch(extractedText);
    String? formattedMemo;

    if (memoMatch != null) {
      String memoContent = memoMatch.group(2) ?? '';

      //ลบช่องว่างระหว่างตัวอักษรในช่วง ก-ฮ
      formattedMemo = memoContent.replaceAll(RegExp(r'(?<=[ก-๙])\s+(?=[ก-๙])'), '');
      print("Memo Content: $formattedMemo");
    }
    else{
      final RegExp memoPattern = RegExp(
          r'(?:Note|memo)\s*:?\s*(.{1,255})'
      );
      final Match? memoMatch = memoPattern.firstMatch(extractedTextEng);
      String? formattedMemo;

      if (memoMatch != null) {
        String memoContent = memoMatch.group(2) ?? '';
        //ลบช่องว่างระหว่างตัวอักษรในช่วง ก-ฮ
        formattedMemo = memoContent.replaceAll(RegExp(r'(?<=[ก-๙])\s+(?=[ก-๙])'), '');
        print("Memo Content: $formattedMemo");
      }
    }

    final RegExp referralPattern = RegExp(r'([A-z0-9]{13,30})');
    //final RegExp referralPattern = RegExp(r'(?i)([A-Z0-9]{13,30})');

    final Match? referralMatch = referralPattern.firstMatch(extractedTextEng); // ใช้ข้อความภาษาอังกฤษ
    String? referralContent;
    if (referralMatch != null) {
      // ใช้group(0) เพื่อเข้าถึงค่าที่จับได้ทั้งหมด
      referralContent = referralMatch.group(0) ?? '';
      print("referral Content: $referralContent");
    } else {
      print("No match found");
    }

    print("----amount : $totalAmount");
    print("----datetime : $formattedDateTime");
    print("----memo : $formattedMemo");
    print("----referral : $referralContent");
    // ส่งค่ากลับทั้งยอดรวมและวันที่/เวลา
    return {
      'amount': totalAmount > 0 ? totalAmount.toStringAsFixed(2) : null,
      'datetime': formattedDateTime,
      'memo' : formattedMemo,
      'referral' : result,
    };
  }
}
