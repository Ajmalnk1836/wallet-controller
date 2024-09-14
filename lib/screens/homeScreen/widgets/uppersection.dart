import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sizer/sizer.dart';
import 'package:walletcontroller/db/transactions/transaction_db.dart';
import 'package:walletcontroller/models/category/category_model.dart';
import 'package:walletcontroller/models/transactions/transaction_model.dart';
import 'package:walletcontroller/screens/overviewScreen/overview_screen.dart';


class UpperSection extends StatelessWidget {
     UpperSection({Key? key}) : super(key: key);
   double? totalIncome;
    double? totalExpense ;
    double ?totalBalance ;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: TransactionDb().TransactionListNotifier,
      builder: (BuildContext ctx, List<TransactionModel> newList, _) {
      diaplayvalues(newList);
        return Column(
                 children: [
           const Center(
              child: Padding(
                padding:  EdgeInsets.only(top: 8.0),
                child: Text(
                 'MY PORTFOLIO',
                  style: TextStyle(
                    color: Color.fromARGB(255, 238, 239, 242),
                   // color: Color.fromARGB(255, 114, 115, 120) ,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                height: 32.h,
                width: 45.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding:  EdgeInsets.only(top: 28.0),
                      child: Text(
                        'Total Balance',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AutoSizeText(
                        "₹ $totalBalance" ,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 31,
                        ),
                        maxLines: 1,
                      ), 
                    ),
                    Row(
                      children: [ 
                        InkWell(
                          child: Sections(
                              cardName: "Income", 
                              Boxcolor: Colors.green,
                              icon: Icons.arrow_upward,
                              iconColor: Colors.white,
                              price: "$totalIncome",
                              priceColor: Colors.white),
                               onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => const IncomeScreen()));
                          },
                        ),
                        const Spacer(),
                        InkWell(
                          child: Sections(  
                              cardName: "Expense",
                              Boxcolor: Colors.red, 
                              icon: Icons.arrow_downward,
                              iconColor: Colors.white,
                              price: "$totalExpense",
                              priceColor: Colors.white),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => const IncomeScreen()));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      );
  }
 diaplayvalues(List<TransactionModel> listData)async{
   totalIncome = 0;
     totalExpense = 0;
     totalBalance = 0;
    for(TransactionModel values in listData){
       if(values.type ==  CategoryType.income){
        totalIncome = totalIncome! + values.amount;
        }
        if(values.type == CategoryType.expense){
          totalExpense = totalExpense! + values.amount;
        }
    }
       totalBalance = totalIncome! - totalExpense!;
        totalBalance! < 0 ? totalBalance = 0 : totalBalance;
  } 
}
class Sections extends StatelessWidget {
  final String cardName;
  final IconData icon;
  final Color iconColor;
  final String price;
  final Color priceColor;
  final Color Boxcolor;
 const Sections({
    required this.cardName,
    required this.icon,
    required this.iconColor,
    required this.price,
    required this.priceColor,
    required this.Boxcolor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 48.0),
      child: Container(
        width: 20.h,
        height: 12.h,
        decoration: BoxDecoration(
          color: Boxcolor,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                cardName,
                style: GoogleFonts.montserrat(
                  color: const Color.fromARGB(255, 239, 237, 237),
                  fontSize: 13.sp  ,
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 7.0, left: 10),
                  child: Icon(
                    icon,
                    color: iconColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 10),
                  child: AutoSizeText(
                    price,
                    style: GoogleFonts.montserrat(
                      color: priceColor,
                      fontSize: 18,
                    ),
                     maxLines: 1,
                     maxFontSize: 16,
                     minFontSize: 5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
