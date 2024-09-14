import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:moneymanagement/db/category/category_db.dart';
//import 'package:moneymanagement/models/category/category_model.dart';

Future ShowcategorydeletePopup(BuildContext context) async {
  await showDialog(
      context: context,
      builder: (ctx) {
              return SimpleDialog(
                title: const Text("Delete this category"),
                children: [
                  Row(
                  
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            // CategoryDB.instance.DeleteCategory();
                          //  print("Deleted")
                          },
                          child: const Text("Yes")),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("no")),
                    ],
                  ),
                ],
              );
            });
      
}
