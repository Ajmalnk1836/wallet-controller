
import 'package:hive/hive.dart';

import '../category/category_model.dart';
import '../transactions/transaction_model.dart';

@HiveType(typeId: 4)
class Chartmodel{
  @HiveField(0)
  CategoryModel? categoryName;

  @HiveField(1)
  TransactionModel? amount;

  @HiveField(2)
  String? id;
  
  
}

