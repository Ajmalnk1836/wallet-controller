import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:walletcontroller/screens/homeScreen/widgets/lowersection.dart';
import 'package:walletcontroller/screens/homeScreen/widgets/lowersectionTwo.dart';
import 'package:walletcontroller/screens/homeScreen/widgets/uppersection.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 41, 45, 49),
      body: SafeArea(
        child: Column(
          children: [
            UpperSection(),

            //const dateSection(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Recent Transaction",
                    style: GoogleFonts.montserrat(
                        fontSize: 25, 
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) {
                        return const ViewAll();
                      }));
                    },
                    child: const Text("View All"),
                  ),
                ),
              ],
            ),
          const  Expanded(child: TransDetails()),
          ],
        ),
      ),
    );
  }
}
