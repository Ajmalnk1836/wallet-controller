import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:walletcontroller/db/transactions/transaction_db.dart';
import 'package:walletcontroller/models/transactions/transaction_model.dart';
import 'package:walletcontroller/screens/overviewScreen/overview_screen.dart';
import '../../../db/peichart/peichart.dart';

class Incomescreen extends StatefulWidget {
  const Incomescreen({Key? key}) : super(key: key);

  @override
  State<Incomescreen> createState() => _IncomescreenState();
}

class _IncomescreenState extends State<Incomescreen> {
  final colorList = <Color>[
    Colors.greenAccent,
  ];
  //late List<TransactionModel> _getchartData;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    //_getchartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Chart> _getchartData =
        chartCalculation(TransactionDb.instance.overviewallsoNotifier.value);
    List<Chart> _getTodayList = chartCalculation(
        TransactionDb.instance.overviewincometodayseallNotifier.value);
    List<Chart> _getYesterdayList = chartCalculation(
        TransactionDb.instance.overviewincomeyesterdayeallNotifier.value);
    List<Chart> _getThismonthList = chartCalculation(
        TransactionDb.instance.overviewincomethismontheallNotifier.value);

    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),
        Container(
          height: 35.h,
          width: 42.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: SfCircularChart(
            title:
                ChartTitle(text: "Income", textStyle: GoogleFonts.montserrat()),
            legend: Legend(
                isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
            series: <CircularSeries>[
              DoughnutSeries<Chart, String>(
                dataSource: dropdownvalue == "All"
                    ? _getchartData
                    : dropdownvalue == "Today"
                        ? _getTodayList
                        : dropdownvalue == "Yesterday"
                            ? _getYesterdayList
                            : dropdownvalue == "This month"
                                ? _getThismonthList
                                : null,
                xValueMapper: (Chart data, _) => data.category,
                yValueMapper: (Chart data, _) => data.amount,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                enableTooltip: true,
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(child: IncomeDetails()),
      ],
    );
  }
}

final today = DateFormat().add_yMMMMd().format(DateTime.now());
final yesterday = DateFormat()
    .add_yMMMMd()
    .format(DateTime.now().subtract(const Duration(days: 1)));
final month = DateFormat().add_yMMM().format(DateTime.now());

Future sortList() async {
  dropdownvalue == "All"
      ? TransactionDb.instance.TransactionListNotifier
      : dropdownvalue == "Today"
          ? TransactionDb.instance.todaysortingNotifier
          : TransactionDb.instance.yesterdaysortingNotifier;
}

class IncomeDetails extends StatelessWidget {
  IncomeDetails({
    Key? key,
  }) : super(key: key);
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
      valueListenable: dropdownvalue == "Today"
          ? TransactionDb.instance.overviewincometodayseallNotifier
          : dropdownvalue == "Yesterday"
              ? TransactionDb.instance.overviewincomeyesterdayeallNotifier
              : dropdownvalue == " This Month"
                  ? TransactionDb.instance.monthsortingNotifier
                  : TransactionDb.instance.overviewallsoNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newList, _) {
        return newList.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning,
                    color: Colors.white,
                    size: 25,
                  ),
                  Text(
                    "No Transaction yet, Please add transaction",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : ListView.separated(
                itemBuilder: (BuildContext ctx, index) {
                  final category = newList[index];

                  return Container(
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
                          color: const Color.fromARGB(255, 231, 229, 229),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  ParseDAte(category.date),
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                  ),
                                ))
                          ],
                        ),
                      ),
                      title: Text(
                        'Income',
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        category.category,
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
                                  const Icon(
                                    Icons.arrow_upward,
                                    color: Colors.green,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: AutoSizeText(
                                      "₹ ${category.amount}",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.green,
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
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, index) {
                  return const Divider();
                },
                itemCount: newList.length);
      },
    );
  }

  // ignore: non_constant_identifier_names
  String ParseDAte(DateTime date) {
    return '${date.day}\n${months[date.month - 1]}';
  }
}
