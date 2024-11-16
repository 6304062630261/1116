import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../../../database/db_manage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddBudget extends StatefulWidget {
  final String valued;

  AddBudget({required this.valued});

  @override
  _AddBudgetState createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudget> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _amountController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 30));
  String _typeTransactionName = '';

  @override
  void initState() {
    super.initState();
    _loadTypeTransactionName();
  }

  Future<void> _loadTypeTransactionName() async {
    int id = int.parse(widget.valued);
    String? name = await DatabaseManagement.instance.getTypeTransactionNameById(id);
    setState(() {
     // _typeTransactionName = name ?? 'Unknown';
      _typeTransactionName = _typeTransactionsLang(name ?? 'Unknown', AppLocalizations.of(context)!);

    });
  }
  String _typeTransactionsLang(String name,AppLocalizations localizations){
    final localizations = AppLocalizations.of(context)!;
    switch (name) {
      case 'Food':
        return localizations.food;
      case 'Travel expenses':
        return localizations.travelexpenses;
      case 'Water bill':
        return localizations.waterbill;
      case "Electricity bill":
        return localizations.electricitybill;
      case 'Internet cost':
        return localizations.internetcost;
      case 'House cost':
        return localizations.housecost;
      case 'Car fare':
        return localizations.carfare;
      case 'Gasoline cost':
        return localizations.gasolinecost;
      case 'Medical expenses':
        return localizations.medicalexpenses;
      case 'Beauty expenses':
        return localizations.beautyexpenses;
      case 'Other':
        return localizations.other;
      default:
        return localizations.other; //ไม่แมป
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title:Text(localizations.budget),
        elevation: 500.0,
        centerTitle: true,
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
        height: MediaQuery.of(context).size.height, // ทำให้ Gradient เต็มหน้าจอ
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red[100]!, Color(0xFEF7FFFF)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 4,
                  blurRadius: 10,
                ),
              ],
            ),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      '$_typeTransactionName',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildDateTimePicker(
                    localizations.startdate,
                    'startDate',
                    _startDate,
                        (value) {
                      if (value != null) {
                        setState(() {
                          _startDate = value;
                          _endDate = value.add(Duration(days: 30));
                        });
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  _buildDateTimePicker(
                    localizations.endDate,
                    'endDate',
                    _endDate,
                    null,
                  ),
                  SizedBox(height: 20),
                  _buildTextField(localizations.amount),
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.saveAndValidate()) {
                        var startDate = _formKey.currentState?.value['startDate'];
                        var endDate = _formKey.currentState?.value['endDate'];
                        var category = widget.valued;
                        var capitalBudget = _amountController.text;

                        startDate = DateTime(startDate.year, startDate.month, startDate.day);

                        Map<String, dynamic> row = {
                          'date_start': startDate.toString(),
                          'date_end': endDate.toString(),
                          'capital_budget': double.parse(capitalBudget),
                          'ID_type_transaction': category,
                        };

                        await DatabaseManagement.instance.insertBudget(row);
                        Navigator.pop(context, true);
                      }
                    },
                    child: Text(localizations.save, style: TextStyle(color: Colors.white, fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.red[800],
                      elevation: 5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimePicker(String label, String name, DateTime initialValue, Function(DateTime?)? onChanged) {
    return FormBuilderDateTimePicker(
      name: name,
      initialValue: initialValue,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      inputType: InputType.date,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.red[900], fontSize: 16),
        suffixIcon: Icon(Icons.calendar_today, color: Colors.red[900]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red[800]!),
        ),
      ),
      locale: Locale('th'),
      onChanged: onChanged,
    );
  }

  Widget _buildTextField(String label) {
    return FormBuilderTextField(
      name: 'amountController',
      controller: _amountController,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.red[900], fontSize: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red[900]!),
        ),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return label;
        }
        if (double.tryParse(value) == null) {
          return AppLocalizations.of(context)!.pleaseenteravalidnumber;
        }
        return null;
      },
    );
  }
}
