import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sizer/sizer.dart';
import 'package:walletcontroller/db/transactions/transaction_db.dart';
import 'package:walletcontroller/models/category/category_model.dart';
import 'package:walletcontroller/models/transactions/transaction_model.dart';
import 'package:walletcontroller/screens/common_widgets/commonwidget.dart';
import 'package:walletcontroller/screens/updatescreens/updatescreentwo.dart';

int itemcount = 5;

class TransDetails extends StatefulWidget {
  const TransDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<TransDetails> createState() => _TransDetailsState();
}

class _TransDetailsState extends State<TransDetails> {
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

  @override
  Widget build(BuildContext context) {
    TransactionDb.instance.refresh();
    return ValueListenableBuilder(
        valueListenable: TransactionDb.instance.TransactionListNotifier,
        builder: (BuildContext ctx, List<TransactionModel> newList, _) {
          return newList.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    LenghtNullview(),
                  ],
                )
              : ListView.separated(
                  itemBuilder: (BuildContext ctx, index) {
                    final _value = newList[index];
                    return Slidable(
                      key: Key(_value.id!),
                      startActionPane:
                          ActionPane(motion: const DrawerMotion(), children: [
                        SlidableAction(
                          backgroundColor: Colors.red,
                          onPressed: (ctx) {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Confirm Delete"),
                                content: const Text(
                                    "Are you sure you want to delete this item?"),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: const Text("Cancel")),
                                  TextButton(
                                    onPressed: () {
                                      TransactionDb.instance
                                          .deleteTransaction(_value.id!);
                                      // ignore: deprecated_member_use
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          duration: Duration(seconds: 2),
                                          backgroundColor: Colors.red,
                                          content: Text('Item Deleted'),
                                        ),
                                      );
                                      Navigator.of(context).pop();
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
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (ctx) {
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
                                const SnackBar(content: Text('Item Updated')));
                          },
                          icon: Icons.edit,
                          label: "Edit",
                        ),
                      ]),
                      child: Stack(children: [
                        Container(
                          margin: const EdgeInsets.only(
                            left: 10,
                            right: 20,
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
                          child: GestureDetector(
                            onLongPress: () => showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SimpleDialog(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              _value.type == CategoryType.income
                                                  ? const Text("Income",
                                                      style: TextStyle(
                                                          color: Colors.green))
                                                  : const Text(
                                                      "Expense",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text("Category :"),
                                              _value.type == CategoryType.income
                                                  ? Text(_value.category)
                                                  : Text(_value.category),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text("Date :"),
                                              Text(popUpdateDate(_value.date))
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text("Amount :"),
                                              Text(
                                                "${_value.amount}",
                                                style: TextStyle(
                                                    color: _value.type ==
                                                            CategoryType.income
                                                        ? Colors.green
                                                        : Colors.red),
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                }),
                            child: ListTile(
                                leading: Container(
                                  height: 6.h,
                                  width: 8.h,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 231, 229, 229),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        parseDAte(_value.date),
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                        ),
                                      )
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
                                      padding: const EdgeInsets.only(left: .0),
                                      child: SizedBox(
                                        height: 5.h,
                                        width: 15.h,
                                        child: Row(
                                          children: [
                                            Icon(
                                              _value.type == CategoryType.income
                                                  ? Icons.arrow_upward
                                                  : Icons.arrow_downward,
                                              color: _value.type ==
                                                      CategoryType.income
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 2),
                                              child: AutoSizeText(
                                                "₹ ${_value.amount}",
                                                style: GoogleFonts.montserrat(
                                                  color: _value.type ==
                                                          CategoryType.income
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
                        ),
                      ]),
                    );
                  },
                  separatorBuilder: (BuildContext context, index) {
                    return const Divider();
                  },
                  itemCount: newList.length < 5 ? newList.length : itemcount);
        });
  }

  String parseDAte(DateTime date) {
    return '${date.day}\n${months[date.month - 1]}';
  }

  String popUpdateDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
