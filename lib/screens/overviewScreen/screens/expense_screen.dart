import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



//import 'package:pie_chart/pie_chart.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:walletcontroller/db/transactions/transaction_db.dart';
import 'package:walletcontroller/models/category/category_model.dart';
import 'package:walletcontroller/models/transactions/transaction_model.dart';
import 'package:walletcontroller/screens/overviewScreen/overview_screen.dart';

import '../../../db/peichart/peichart.dart';
//import '../../homeScreen/wigets/lowersection.dart';

class Expense extends StatefulWidget {
 const Expense({Key? key}) : super(key: key);

  @override
  State<Expense> createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  Map<String, double> dataMap = {
    "Flutter": 14,
    "React": 3,
    "Xamarin": 2,
    "Ionic": 2,
  };

  final colorList = <Color>[
    const Color.fromARGB(255, 143, 166, 155),
  ];
  //late List<TransactionModel> _getchartData;
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    // _getchartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Chart> _getchartData = chartCalculation(
        TransactionDb.instance.overviewexpenseallNotifier.value);
    List<Chart> _getTodayList = chartCalculation(
        TransactionDb.instance.overviewexpensetodayeallNotifier.value);
    List<Chart> _getYesterdayList = chartCalculation(
        TransactionDb.instance.overviewexpenseyesterdayeallNotifier.value);
    List<Chart> _getThismonthList =
        chartCalculation(TransactionDb.instance.monthsortingNotifier.value);
    return Column(
      children: [
        const SizedBox(
          height: 10, 
        ),
        Container(
          height: 35.h,  
          width: 42.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), 
            color: Colors.white,
          ),
          child: SfCircularChart(
            title: ChartTitle(text: "Expense",textStyle: GoogleFonts.montserrat()),
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
        Expanded(child: ExpenseDetails())
      ],
    );
  } 
}

class ExpenseDetails extends StatelessWidget {
  ExpenseDetails({
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
          ? TransactionDb.instance.overviewexpensetodayeallNotifier
          : dropdownvalue == "Yesterday"
              ? TransactionDb.instance.overviewexpenseyesterdayeallNotifier 
              : dropdownvalue == " This Month"
                  ? TransactionDb.instance.monthsortingNotifier
                  : TransactionDb.instance.overviewexpenseallNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newList,_) {
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
                      child: category.type == CategoryType.expense
                          ? ListTile(
                              leading: Container(
                                height: 6.h,
                                width: 8.h,
                                decoration: BoxDecoration(
                                
                                    color:const Color.fromARGB(255, 231, 229, 229),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          ParseDate(category.date),
                                          style: GoogleFonts.montserrat(
                                            fontSize: 16,
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                              title: Text(
                                'Expense',
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
                                            Icons.arrow_downward,
                                            color: Colors.red,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2),
                                            child: AutoSizeText(
                                              "₹ ${category.amount}",
                                              style: GoogleFonts.montserrat(
                                                color: Colors.red,
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
                              ))
                          : null);
                },
                separatorBuilder: (BuildContext context, index) {
                  return const Divider();
                },
                itemCount: newList.length);
      },
    );
  }

  String ParseDate(DateTime date) {
    return '${date.day}\n ${months[date.month - 1]}';
  }
}
