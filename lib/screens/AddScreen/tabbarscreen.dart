import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:walletcontroller/screens/AddScreen/expense_screen.dart';
import 'package:walletcontroller/screens/AddScreen/income_screen.dart';



class AddSections extends StatefulWidget {
  const AddSections({Key? key}) : super(key: key);

  @override
  State<AddSections> createState() => _AddSectionsState();
}

class _AddSectionsState extends State<AddSections>
    with SingleTickerProviderStateMixin {
  late TabController tabcontroller;
  @override
  void initState() {
    tabcontroller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 45, 49),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28.0, top: 12),
                child: Text(
                  "Add Transactions",
                  style:
                      GoogleFonts.montserrat(fontSize: 23, color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: Text(
                  "Add the Latest transactions",
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400, color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // height: 50,
                  width: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: TabBar(
                            controller: tabcontroller,
                            labelColor: const Color.fromARGB(255, 23, 56, 74),
                            unselectedLabelColor:
                                const Color.fromARGB(255, 153, 204, 43),
                            indicator: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            tabs: const [
                              Tab(text: "Income"),
                              Tab(text: "Expenses"),
                            ]),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: TabBarView(controller: tabcontroller, children: const [
                AddIncome(),
                AddExpense(),
              ])),
              //  FloatingActionButton(onPressed: (){}),
            ],
          ),
        ),
      ),
    );
  }
}
