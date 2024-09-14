import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart'; 
import 'package:url_launcher/url_launcher.dart';
import 'package:walletcontroller/db/category/category_db.dart';
import 'package:walletcontroller/db/transactions/transaction_db.dart';
import 'package:walletcontroller/screens/bottom_navigation_screen/bottom_navigation_scree.dart';

bool showToggle = false;
 
class SettingsScreen extends StatelessWidget {
 const SettingsScreen({Key? key}) : super(key: key);

final  bool showToggle = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 45, 49),
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20, 
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, top: 12),
            child: Text(
              "Settings",
              style: GoogleFonts.montserrat(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              "Configure Your settings",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 35,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              height: 70.h,
              width: MediaQuery.of(context).size.width,
              //color: Colors.red,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    //exception cas
                    height: 60,
                  ),

              const    Notificationtitle(),    

                  //
                  const SizedBox(
                    height: 20,
                  ),
                  SettingsTile(
                    tilename: "Reset",
                    subTilename:
                        "Are you sure to reset..!? The All data will be removed",
                    resetButton: true,
                    cancelButton: true, 
                    okbutton: true,
                    ontap: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SettingsTile(
                    tilename: "About",
                    subTilename:
                        "This is a Offline Income Expense tracker app, developed by Muhammed Ajmal NK",
                    resetButton: false,
                    cancelButton: false,
                    okbutton: false,
                    ontap: false,
                  ),
                
                  const SizedBox(
                    height: 20,
                  ), 
                  SettingsTile(
                    tilename: "Contact me ",
                    subTilename:
                        "IAM MUHAMMED AJMAL NK , GRADUATED IN COMPUTER SCIENE",
                    resetButton: false,
                    cancelButton: false,
                    okbutton: false,
                    ontap: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}

class Notificationtitle extends StatefulWidget {
 const Notificationtitle({
    Key? key,
  }) : super(key: key);

  @override
  State<Notificationtitle> createState() => _NotificationtitleState();
}

class _NotificationtitleState extends State<Notificationtitle> {
  // TimeOfDay time = TimeOfDay(hour: 10, minute: 30);
  static TimeOfDay time = TimeOfDay.now();

  late FlutterLocalNotificationsPlugin Fltrnotification;

  @override
  void initState() {
    super.initState();
  //  NotificationWidget().init(sheduled: true);

    //listenNotification();
  }

  // void listenNotification() =>
  //     NotificationWidget.onNotifications.stream.listen(onClickedNotification);
  // void onClickedNotification(String payload) =>
  //     Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
  //       return const BottomNavigation();
  //     }));

  static final now = DateTime.now();
  var dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  var format = DateFormat.jm();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: 39.h,
        height: 7.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 209, 204, 204),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Notification",
                style: GoogleFonts.montserrat(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            CupertinoSwitch(
                value: showToggle,
                onChanged: (newvalue) {
                  setState(() {
                    showToggle = newvalue;
                  });
                }),
          ],
        ),
      ),
      const SizedBox(
        height: 12,
      ),
      showToggle == true
          ? Container(
              width: 39.h,
              height: 7.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 209, 204, 204),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Reminder Set for ${time.hour}:${time.minute} ${time.hour < 12 ? 'AM' : 'PM'}",
                      style: GoogleFonts.montserrat(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await _timeSelector(context);

                    },
                    icon: const Icon(Icons.lock_clock_rounded),
                  )
                ],
              ),
            )
          : const SizedBox(
              width: .1,
            ),
    ]);
  }

  _timeSelector(BuildContext context) async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: time,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (newTime != null && newTime != time) {
      setState(() {
        time = newTime;
      });
      // NotificationWidget.showsheduledNotification(
      //     title: "Money Tracker",
      //     body: "Add your Transaction",
      //     payload: "Dont miss it",
      //     scheduleDate: Time(newTime.hour, newTime.minute, 0));
    }
  }
}

//*bool resetButton =true;
class SettingsTile extends StatelessWidget {
  final String tilename;
  final String subTilename;
   bool resetButton = true;
 bool cancelButton = true;
  bool okbutton = true;
  bool ontap = true;
  final bool _isExpanded = true;
  SettingsTile({
    required this.tilename,
    required this.subTilename,
    required this.resetButton,
    required this.cancelButton,
    required this.okbutton,
    required this.ontap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 39.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color.fromARGB(255, 209, 204, 204)),
      child: GestureDetector(
        onTap: () => showDialog(
            context: context,
            builder: (_) {
              return Container(
                height: 7.h,
                width: 8.h,
                // color: Colors.red,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AlertDialog(
                  title: Text(
                    tilename,
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w400),
                  ),
                  content: Text(
                    subTilename,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel")),
                    resetButton == true
                        ? TextButton(
                            onPressed: () async{  
                            
                             await  CategoryDB.instance.clearCategory();
                            await  TransactionDb.instance.clearAllTransaction();
                              // print("Cleared");
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (ctx) {
                                return const BottomNavigation();
                              }));
                            },   
                            child: const Text("Ok")) 
                        : const SizedBox()
                  ],
                ),  
              );
           
            }),
        child: ontap == true
            ? ListTile(
                onTap: () async {
                  // ignore: deprecated_member_use
                  if (!await launch("https://ajmalnk1836.github.io/profile/")) {
                    throw 'could not match';
                  }
                },
                title: Text(
                  tilename,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: _isExpanded
                          ? const Color.fromARGB(255, 16, 16, 16)
                          : const Color.fromARGB(255, 226, 231, 226)),
                ),

              )
            : ListTile(
                title: Text(
                  tilename,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: _isExpanded
                          ? const Color.fromARGB(255, 16, 16, 16)
                          : const Color.fromARGB(255, 226, 231, 226)),
                ),

              ),
      ),
    );
  }
}
