import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:walletcontroller/db/transactions/transaction_db.dart';
import 'package:walletcontroller/screens/bottom_navigation_screen/bottom_navigation_scree.dart';
import 'package:walletcontroller/screens/common_widgets/commonwidget.dart';
import '../../../models/category/category_model.dart';
import '../../../models/transactions/transaction_model.dart';
import '../../updatescreens/updatescreentwo.dart';

class ViewAll extends StatefulWidget {
  const ViewAll({Key? key}) : super(key: key);

  @override
  State<ViewAll> createState() => _ViewAllState();
}

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

var items = [
  'All',
  'Today',
  'Yesterday',
  'This Month',
  'Months',
];
DateTime? _selected = DateTime.now();
String dropdownvalue = "All";

class _ViewAllState extends State<ViewAll> {
  @override
  Widget build(BuildContext context) {
    TransactionDb.instance.refresh();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 45, 49),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (ctx) {
                      return const BottomNavigation();
                    }));
                  },
                  icon: const Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.white,
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 12),
                      child: Text(
                        "All Transactions",
                        style: GoogleFonts.montserrat(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Text(
                        "Your All Transaction details",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 7.h,
                // color: Colors.red,
                child: Row(
                  children: [
                    DropdownButtonHideUnderline(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 11.0),
                        child: Container(
                          //color: Colors.white,
                          width: 17.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: DropdownButton(
                            dropdownColor: Colors.white,
                            underline: Container(), //remove underline
                            isExpanded: true,

                            value: dropdownvalue,
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(
                                  items,
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalue = newValue!;
                                // print(dropdownvalue);
                              });
                            },
                            icon: Icon(
                              Icons.arrow_circle_down_sharp,
                              size: 3.h,
                            ),
                            iconEnabledColor: Colors.green, //Icon color
                            style: GoogleFonts.montserrat(
                                color: Colors.black, //Font color
                                fontSize: 20 //font size on dropdown button,

                                ),
                          ),
                        ),
                      ),
                    ),
                    dropdownvalue == "Months"
                        ? Padding(
                            padding: const EdgeInsets.only(
                              left: 48.0,
                            ),
                            child: IconButton(
                                onPressed: () {
                                  _onPressed(context: context);
                                },
                                icon: const Icon(
                                  Icons.calendar_month,
                                  color: Colors.white,
                                )),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: dropdownvalue == "Today"
                      ? TransactionDb.instance.todaysortingNotifier
                      : dropdownvalue == "Yesterday"
                          ? TransactionDb.instance.yesterdaysortingNotifier
                          : dropdownvalue == " This Month"
                              ? TransactionDb.instance.monthsortingNotifier
                              : dropdownvalue == "Months"
                                  ? TransactionDb.instance.monthsoNotifier
                                  : TransactionDb
                                      .instance.TransactionListNotifier,
                  builder: (BuildContext ctx, List<TransactionModel> newList,
                      _) {
                    return newList.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:const [
                         LenghtNullview(), 
                            ],
                          )
                        : ListView.separated(
                            itemBuilder: (BuildContext ctx, index) {
                              final _value = newList[index];
                              return Slidable(   
                                key: Key(_value.id!),
                                startActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        backgroundColor: Colors.red,
                                        onPressed: (ctx) {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title:
                                                  const Text("Confirm Delete"),
                                              content: const Text(
                                                  "Are you sure you want to delete this item?"),
                                              actions: <Widget>[
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(ctx).push(
                                                          MaterialPageRoute(
                                                              builder: (ctx) {
                                                        return const ViewAll();
                                                      }));
                                                    },
                                                    child:
                                                        const Text("Cancel")),
                                                TextButton(
                                                  onPressed: () {
                                                    TransactionDb.instance
                                                        .deleteTransaction(
                                                            _value.id!);
                                                    Navigator.of(ctx).push(
                                                        MaterialPageRoute(
                                                            builder: (ctx) {
                                                      return const ViewAll();
                                                    }));
                                                  },
                                                  child: const Text("Ok"),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        icon: Icons.delete,
                                        label: "Delete",
                                      ),
                                      SlidableAction(
                                        backgroundColor: Colors.green,
                                        onPressed: (ctx) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder: (ctx) {
                                            return UpdateScreenTwo(
                                              amount: _value.amount,
                                              category: _value.category,
                                              date: _value.date,
                                              type: _value.type,
                                              id: _value.id!,
                                            );
                                          }));
                                          // ignore: deprecated_member_use
                                 ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                  content:
                                                      Text('Item Updated')));
                                        },
                                        icon: Icons.edit,
                                        label: "Edit",
                                      ),
                                    ]),
                                child: Stack(children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 13,
                                      right: 30,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: ListTile(
                                        leading: Container(
                                          height: 6.h,
                                          width: 8.h,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 231, 229, 229),
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0),
                                                  child: Text(
                                                    parseDAte(_value.date),
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 16,
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        title: Text(
                                          _value.type == CategoryType.income
                                              ? "Income "
                                              : "Expense",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        subtitle: Text(
                                          _value.category,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        trailing: Wrap(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: .0),
                                              child: SizedBox(
                                                //color: Colors.red,
                                                height: 5.h,
                                                width: 15.h,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      _value.type ==
                                                              CategoryType
                                                                  .income
                                                          ? Icons.arrow_upward
                                                          : Icons
                                                              .arrow_downward,
                                                      color: _value.type ==
                                                              CategoryType
                                                                  .income
                                                          ? Colors.green
                                                          : Colors.red,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 2),
                                                      child: AutoSizeText(
                                                        "₹ ${_value.amount}",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          color: _value.type ==
                                                                  CategoryType
                                                                      .income
                                                              ? Colors.green
                                                              : Colors.red,
                                                          fontSize: 14,
                                                        ),
                                                        maxLines: 1,
                                                        maxFontSize: 12,
                                                        minFontSize: 12,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ]),
                              );
                            },
                            separatorBuilder: (BuildContext context, index) {
                              return const Divider();
                            },
                            itemCount: newList.length);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  String parseDAte(DateTime date) {
    return '${date.day}\n${months[date.month - 1]}';
  }

  String popUpdateDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _onPressed({
    required BuildContext context,
    String? locale,
  }) async {
    final localeObj = locale != null ? Locale(locale) : null;
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: _selected ?? DateTime.now(),
      firstDate: DateTime(2013),
      lastDate: DateTime(2030),
    );
    if (selected == null) {
      return;
    } else {
      setState(() {
        _selected = selected;
      });
    }
    TransactionDb.instance.monthsoNotifier.value.clear();
    Future.forEach(TransactionDb.instance.TransactionListNotifier.value,
        (TransactionModel datas) {
      if (datas.date.month == _selected!.month) {
        TransactionDb.instance.monthsoNotifier.value.add(datas);
      }
      TransactionDb.instance.monthsoNotifier.notifyListeners();
    });
  }
}
