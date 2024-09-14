import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:walletcontroller/db/category/category_db.dart';
import 'package:walletcontroller/models/category/category_model.dart';
import 'package:walletcontroller/screens/CategoryScreen/screens/cate_income.dart';
import '../../common_widgets/commonwidget.dart';

class CategoryExpense extends StatelessWidget {
  const CategoryExpense({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
       
         CategoryTiles(),
       //  Expanded(child: tapListtile()),
      
      ],
    );
  }
}

class CategoryTiles extends StatelessWidget {
  const CategoryTiles({
    Key? key, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CategoryDB.instance.refreshUI();
    return Container(
      width: 39.h,
      height: 50.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        //vcolor: Color.fromARGB(255, 243, 238, 237),
      ),
      child: ValueListenableBuilder(
        valueListenable: CategoryDB().expenseeCategoryListNotifier ,
        builder: (BuildContext context, List<CategoryModel> newList, _){
         return newList.isEmpty
         ? const CategoryNullWidget()
         :
           GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 19.0,
          mainAxisSpacing: 19.0,
        children:List.generate(newList.length, (index) {
          final category = newList[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onLongPress: (() => showDialog(context: context, 
              builder: (ctx){
                return Categorydelete(category: category);
              })), 
              child: Container(  
               
               // color: Colors.red,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(20),
                 border: Border.all(color: const Color.fromARGB(255, 142, 139, 139),
                 ),
                 color: const Color.fromARGB(255, 243, 238, 237)
               ),
               child: Center(child: Text(category.name)),
                     
                     ),
            )
          );
         
        }
         )
         );
    
        }
         )
    );
  }
}



