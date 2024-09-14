import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class LenghtNullview extends StatelessWidget {
  const LenghtNullview({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 33.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
              image: AssetImage(
                  "assets/images/preview-bg.png"))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "No Transaction yet , Please add transactions",
            style: GoogleFonts.montserrat(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
class  CategoryNullWidget extends StatelessWidget {
  const CategoryNullWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Text(
            "Please Add categories",
            style: GoogleFonts.montserrat(color: Colors.white),
          ),
          const Icon(
            Icons.warning,
            color: Colors.white,
          ),
        ],
      );
  }
}



       