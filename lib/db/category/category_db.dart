

// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:walletcontroller/models/category/category_model.dart';



const categorydbname="category-database";

abstract class CategoryDbfunctions{
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void> DeleteCategory(String CategoryId);
  Future<void> clearCategory();

}

class CategoryDB implements CategoryDbfunctions{

  CategoryDB._internal();
   static CategoryDB instance =CategoryDB._internal();
  factory CategoryDB(){
     return instance;
   }

 
ValueNotifier<List<CategoryModel>> incomeCategoryListNotifier = ValueNotifier([]);
ValueNotifier<List<CategoryModel>> expenseeCategoryListNotifier = ValueNotifier([]);
  @override
  Future<void> insertCategory(CategoryModel value) async {
   final _categoryDb = await Hive.openBox<CategoryModel>(categorydbname);
  await _categoryDb.put(value.id,value);
 refreshUI();
  }

  @override
  Future <List<CategoryModel>> getCategories()async {
    final _categoryDb = await Hive.openBox<CategoryModel>(categorydbname);
    return _categoryDb.values.toList();
   
  }
  
  Future<void> refreshUI()async{
    final _getAllCategories = await getCategories();
    incomeCategoryListNotifier.value.clear();

    expenseeCategoryListNotifier.value.clear();

   await Future.forEach(_getAllCategories, (CategoryModel category){
     if(category.type == CategoryType.income){
        incomeCategoryListNotifier.value.add(category);
     }else{
       expenseeCategoryListNotifier.value.add(category);
     }
    },);
    

    incomeCategoryListNotifier.notifyListeners();

    expenseeCategoryListNotifier.notifyListeners();
  }

  @override
  Future<void> DeleteCategory(String CategoryId) async {
     final _categoryDb = await Hive.openBox<CategoryModel>(categorydbname);
     _categoryDb.delete(CategoryId);
     refreshUI();
    
  }

  @override
  Future<void> clearCategory() async {
     final _categoryDb = await Hive.openBox<CategoryModel>(categorydbname);
     _categoryDb.clear();
  }
} 