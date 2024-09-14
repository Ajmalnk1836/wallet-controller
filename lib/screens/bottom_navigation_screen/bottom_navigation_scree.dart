import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import '../AddScreen/tabbarscreen.dart';
import '../CategoryScreen/Categoryscreen.dart';
import '../homeScreen/homescreen.dart';
import '../overviewScreen/overview_screen.dart';
import '../settingsScreen/settingsscreen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({ Key? key }) : super(key: key);

  @override 
  State<BottomNavigation> createState() => _BottomNavigationState();
} 

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentindex = 0;
  final List _children =const [ 
     HomeScreen(),
     IncomeScreen(),
     AddSections(),
     CategoryScreen(),
    SettingsScreen(),
    
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentindex],
     bottomNavigationBar: ConvexAppBar(
       color:const Color.fromARGB(255, 249, 249, 251),   
       backgroundColor: const Color.fromARGB(255, 2, 22, 39),
      initialActiveIndex: _currentindex,
      onTap: (newIndex){
        setState(() {
          _currentindex =newIndex;
        });
      },
    items: const[
      TabItem(icon: Icons.home, title: 'Home',),
      TabItem(icon: Icons.map, title: 'Overview'),
      TabItem(icon: Icons.add, title: 'Add'),
      TabItem(icon: Icons.message, title: 'Categories'),
      TabItem(icon: Icons.settings, title: 'Settings'),   
    ],
  ),
    );
  }

 
}