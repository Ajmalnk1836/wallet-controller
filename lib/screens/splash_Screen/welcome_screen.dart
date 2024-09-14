import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../Bottom_navigation_screen/bottom_navigation_scree.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 41, 45, 49),
      body: SafeArea(
          child: Column(
        children: [
          const SizedBox(
            height: 150,
          ),
          Image.asset("assets/images/welcomescreenimage-removebg-preview.png"),

          //Image.asset("assets/images/welcomescreenimage.png",width: 49.h,),
          Text(
            "Starts Savings",
            style: GoogleFonts.montserrat(
              fontSize: 4.h,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("Your Wallet Controle in one App..!",
              style: GoogleFonts.montserrat()),
          const SizedBox(
            height: 20,
          ),
          Container(
              height: 7.h,
              width: 7.h,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [],
              ),
              child: IconButton(
                  onPressed: () async {
                    await Future.delayed(const Duration(milliseconds: 200));
                    checkLogin(context);
                  },
                  icon: const Icon(
                    Icons.arrow_right_alt_rounded,
                    color: Colors.white,
                  ))),
          // SizedBox(
          //   height: 22.7.h,
          // ),
        ],
      )),
    );
  }

  void checkLogin(BuildContext ctx) async {
    final _sharedPreference = await SharedPreferences.getInstance();
    await _sharedPreference.setBool("Checkvisisted", true);
    Navigator.of(ctx)
        .push(MaterialPageRoute(builder: (ctx) => const BottomNavigation()));
  }
}
