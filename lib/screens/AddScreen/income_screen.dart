import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:walletcontroller/db/transactions/transaction_db.dart';
import 'package:walletcontroller/models/category/category_model.dart';
import 'package:walletcontroller/models/transactions/transaction_model.dart';
import 'package:walletcontroller/screens/bottom_navigation_screen/bottom_navigation_scree.dart';

import '../../db/category/category_db.dart';
import '../CategoryScreen/screens/category_app_pop.dart';

class AddIncome extends StatefulWidget {
  //final TransactionModel data;

  const AddIncome({  
    Key? key,
//required this.data
  }) : super(key: key);

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  String buttonname = 'Select category';
  String date = "";
  DateTime selectedDate = DateTime.now();
  bool buttonSelected = true;
  final List months = [
    "jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  final _formKey = GlobalKey<FormState>();
  final _amountcontroller = TextEditingController();

  CategoryModel? selectedCategoryModel;

  @override
  void initState() {
    CategoryDB.instance.refreshUI();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 45, 49),
      body: SafeArea(
          child: ListView(
        children: [
          const SizedBox(
            height: 60,
          ),
          Container(
            width: 55.h,
            height: 66.h,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 243, 238, 237),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 70,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 30,
                      ),
                      Text(
                        "Date :",
                        style: GoogleFonts.montserrat(),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextButton(
                            onPressed: () {
                              _selectDate(context);
                            },
                            child: Text(
                                "${selectedDate.day} - ${months[selectedDate.month - 1]}"),
                            style: ElevatedButton.styleFrom(
                             // primary: const Color.fromARGB(255, 243, 238, 237),
                            )),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        height: 110,
                        width: 25,
                      ),
                      Text(
                        "Amount :",
                        style: GoogleFonts.montserrat(),
                      ),
                      amountTextfield(),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        height: 70,
                        width: 20,
                      ),
                      Text(
                        "Category :",
                        style: GoogleFonts.montserrat(),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      categoryTextfield(),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {}
                        addTransaction();
                      },
                      child: const Text("Add Transaction"),
                      style: ElevatedButton.styleFrom(
                         // primary: const Color.fromARGB(255, 72, 71, 71)
                          
                          ))
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
  }

  Widget amountTextfield() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          maxLength: 9,
          //inputFormatters: [LengthLimitingTextInputFormatter(8)],
          controller: _amountcontroller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Your amount';
            } else if (value.length > 8) {
              return "Please enter correct format";
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.currency_rupee),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.blue,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.orange,
            )),
            hintText: 'Enter The Amount',
          ),
          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }

  Widget categoryTextfield() {
    return Expanded(
        child: SizedBox(
      height: 6.5.h,
      child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              const Color.fromARGB(255, 243, 238, 237),
            ),
            //shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                side: const BorderSide(
                    color: Colors.grey, width: 1, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          onPressed: () {
            showModalBottomSheet(
                // backgroundColor: Color.fromARGB(255, 245, 241, 206),
                context: context,
                builder: (context) {
                  return ValueListenableBuilder(
                      valueListenable: CategoryDB().incomeCategoryListNotifier,
                      builder: (BuildContext ctx, List<CategoryModel> newList,
                          _) {
                        return
                         newList.isEmpty 
                        ?  Column(
                          children: [
                            ElevatedButton(onPressed: (){
                        showCategoryPopup(context);
                        }, child:const Text("Add Category")),
                        Text("Please Add Category First..! ",style: GoogleFonts.montserrat(),)
  
                          ], 
                          ) 

                         :ListView.separated(
                            itemBuilder: (BuildContext ctx, index) {
                              final data = newList[index];

                              return Container(
                                height: 7.h,
                                width: 7.h,
                                //color: Colors.red,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  onTap: () => setState(() {
                                    buttonSelected = true;
                                    buttonname = data.name;
                                    Navigator.of(context).pop();
                                  }),
                                  title: Text(
                                    data.name,
                                    style: GoogleFonts.montserrat(),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (BuildContext context, index) {
                              return const Divider(
                                thickness: 2,
                                // color: Color.fromARGB(255, 105, 102, 102),
                              );
                            },
                            itemCount: newList.length);
                      });
                });
          },
          child: Text(
            buttonname,
            style: const TextStyle(color: Color.fromARGB(255, 127, 125, 125)),
          )),
    ));
  }

  Future<void> addTransaction() async {
    final _amountText = _amountcontroller.text;
    if (_amountText.isEmpty) {
      return;
    }
    if (_amountText.length > 9) {
      return;
    }
    if (buttonname == "Select category") {
      // ignore: deprecated_member_use
     ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Choose Correct Category')));
      return;
    }

    // ignore: unnecessary_null_comparison
    if (selectedDate == null) {
      return;
    }
    final _parseAmount = double.tryParse(_amountText);
    if (_parseAmount == null) {
      return;
    }
    final model = TransactionModel(
        type: CategoryType.income,
        date: selectedDate,
        amount: _parseAmount,
        category: buttonname,
        id: DateTime.now().millisecondsSinceEpoch.toString());
    TransactionDb.instance.addTransactions(model);
    final snackBar = SnackBar(
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 30.0),
      content: const Text('Your Transaction added successfully'),
      backgroundColor: (Colors.green),
      action: SnackBarAction(
        label: 'dismiss',
        textColor: Colors.white,
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
      return const BottomNavigation();
    }));
    TransactionDb.instance.refresh();
  }
}
