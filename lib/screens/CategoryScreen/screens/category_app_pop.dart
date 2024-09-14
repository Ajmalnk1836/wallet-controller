import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:walletcontroller/db/category/category_db.dart';
import 'package:walletcontroller/models/category/category_model.dart';


ValueNotifier<CategoryType> selectedCategoryNotifier = 
                                ValueNotifier(CategoryType.income);

Future<void> showCategoryPopup(BuildContext context) async {
  final _nameEditingcolntorller = TextEditingController();
  showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text("Add"),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
             
              inputFormatters: [LengthLimitingTextInputFormatter(15)],  
            
                // ignore: prefer_const_constructors
                controller: _nameEditingcolntorller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Row(
              children:const [
                RadioButton(title: "Income", type: CategoryType.income),
                RadioButton(title: "Expense", type: CategoryType.expense)
              ],
            ),
            ElevatedButton(onPressed: () {
              final _name = _nameEditingcolntorller.text; 
              if(_name.isEmpty){
                return ;
              }
              final _type = selectedCategoryNotifier.value;
              final _category = CategoryModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                 name: _name,
                  type: _type);
                  CategoryDB.instance.insertCategory(_category);
                 
                  Navigator.of(ctx).pop();
              
            
            
                        }, child: const Text("add")),
          ],
        );
      });
}

class RadioButton extends StatelessWidget{
  final String title;
  final CategoryType type;
  //final CategoryType selectedCategoryType;

 const RadioButton({Key? key, required this.title, required this.type})
      : super(key: key);

  @override

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
       ValueListenableBuilder(
         valueListenable: selectedCategoryNotifier ,
          builder: (BuildContext ctx, CategoryType newCategory, _){
            return  Radio<CategoryType>(
            value: type,
            groupValue:selectedCategoryNotifier.value,
            onChanged: (value) {
              //print(value);
              if(value==null){
                return;
              }
             selectedCategoryNotifier.value =value;
             selectedCategoryNotifier.notifyListeners();

              });
          }),
            
        Text(title),
      ],
    );
  }
}
