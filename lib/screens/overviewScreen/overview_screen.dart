import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:walletcontroller/screens/bottom_navigation_screen/bottom_navigation_scree.dart';
import 'package:walletcontroller/screens/overviewScreen/screens/expense_screen.dart';
import 'package:walletcontroller/screens/overviewScreen/screens/income_scree.dart';

String dropdownvalue = "All";

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({Key? key}) : super(key: key);

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabcontroller;
  var items = [
    'All',
    'Today',
    'Yesterday',
    // 'This Month',
  ];

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
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 53.0),
                        child: Text(
                          "Overview",
                          style: GoogleFonts.montserrat(
                            fontSize: 23,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Your transaction details",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: DropdownButtonHideUnderline(
                  child: Container(
                    width: 19.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
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
                          //te
                          color: Colors.black, //Font color
                          fontSize: 20 //font size on dropdown button,

                          ),
                    ),
                  ),
                ),
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
                              Tab(text: "Expense"),
                            ]),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: TabBarView(controller: tabcontroller, children:const [
                Incomescreen(),
                Expense(),
              ]))
            ],
          ),
        ),
      ),
    );
  }
}
