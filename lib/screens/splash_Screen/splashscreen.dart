import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:walletcontroller/screens/bottom_navigation_screen/bottom_navigation_scree.dart';
import 'package:walletcontroller/screens/splash_Screen/welcome_screen.dart';


class SharePref extends StatefulWidget {
  const SharePref({Key? key}) : super(key: key);

  @override
  State<SharePref> createState() => _SharePrefState();
}

class _SharePrefState extends State<SharePref> {
  @override
  void initState() {
    
   checkVisited(); 
    super.initState(); 
  }

  @override 
  Widget build(BuildContext context) { 
  return Scaffold(
    // backgroundColor: Color.fromARGB(255, 221, 213, 213),
   // backgroundColor: Color.fromARGB(255, 146, 204, 251),
      body: SafeArea(
          child: Column(
        children: [
          const SizedBox(height: 125,),
          Lottie.asset("assets/images/lottie.json"),
        ///  SizedBox(height: 30),
       Column(
         children: [
           Text("ROZO MONEY ",style: GoogleFonts.montserrat(
             fontSize: 4.h,
            fontWeight: FontWeight.bold,
           ),),
           Text("Your Complete wallet controller",style: GoogleFonts.montserrat(),),

         ],
       ),
           
        ],
      )),
    );
  }

  Future<void> checkVisited() async {
    final pref = await SharedPreferences.getInstance();
    final getVisited = pref.getBool("Checkvisisted");
    if (getVisited == null || getVisited == false) {
      gotologin();
    } else {
      await Future.delayed(const Duration(seconds: 4));
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx1) => const BottomNavigation()));
    }
  }

  gotologin() async {
    await Future.delayed(const Duration(seconds: 4)); 
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => const WelcomeScreen())));
  }
}
