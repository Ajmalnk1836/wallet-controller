import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../db/category/category_db.dart';
import '../../db/transactions/transaction_db.dart';
import '../../models/category/category_model.dart';
import '../../models/transactions/transaction_model.dart';
import '../Bottom_navigation_screen/bottom_navigation_scree.dart';

class UpdateScreenTwo extends StatefulWidget {
  final CategoryType type;
  final DateTime date;
  final double amount;
  final String category;
  final String id;
  const UpdateScreenTwo({
    Key? key,
    required this.type,
    required this.date,
    required this.amount,
    required this.category,
    required this.id,
  }) : super(key: key);

  @override
  State<UpdateScreenTwo> createState() => _UpdateScreenTwoState();
}

class _UpdateScreenTwoState extends State<UpdateScreenTwo> {
  String buttonname = 'Select category';
  String date = "";
  DateTime selectedDate = DateTime.now();
  bool buttonSelected = true;
  late String id1;
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
  //final _categorycontroller = TextEditingController();
  //TextEditingController amount = TextEditingController();

  CategoryModel? selectedCategoryModel;

  @override
  void initState() {
    CategoryDB.instance.refreshUI();
    selectedDate = widget.date;
    id1 = widget.id;
    _amountcontroller.text = widget.amount.toString();

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
                      const Text("Date"),
                      const SizedBox(
                        width: 10,
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
                                //  primary: const Color.fromARGB(255, 243, 238, 237),
                                )),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        height: 110,
                        width: 20,
                      ),
                      const Text("Amount"),
                      amountTextfield(),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        height: 70,
                        width: 20,
                      ),
                      const Text("Category"),
                      categoryTextfield(),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {}
                        updateTransaction();
                      },
                      child: const Text("Update Transaction"),
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
          controller: _amountcontroller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Your amount';
            }
            return null;
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
                  context: context,
                  builder: (context) {
                    return ValueListenableBuilder(
                        valueListenable:
                            CategoryDB().incomeCategoryListNotifier,
                        builder:
                            (BuildContext ctx, List<CategoryModel> newList, _) {
                          return ListView.separated(
                              itemBuilder: (BuildContext ctx, index) {
                                final data = newList[index];

                                return ListTile(
                                  onTap: () =>
                                      //       Buttonname ==  "Select category" ? Scaffold.of(context).showSnackBar(
                                      // SnackBar(content: Text('Coose right option'))) :
                                      setState(() {
                                    buttonSelected = true;
                                    buttonname = data.name;
                                    // selectedCategoryModel=data.name;

                                    Navigator.of(context).pop();
                                  }),
                                  title: Text(data.name),
                                );
                              },
                              separatorBuilder: (BuildContext context, index) {
                                return const Divider();
                              },
                              itemCount: newList.length);
                        });
                  });
            },
            child: Text(
              buttonname,
              style: const TextStyle(color: Colors.grey),
            )));
  }

  Future<void> updateTransaction() async {
    final _amountText = _amountcontroller.text;
    if (_amountText.isEmpty) {
      return;
    }
    if (buttonname == "Select category") {
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
        id: id1);
    TransactionDb.instance.updateTransaction(model);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
      return const BottomNavigation();
    }));
    TransactionDb.instance.refresh();
  }
}
