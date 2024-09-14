import 'package:hive/hive.dart';

import '../category/category_model.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 3)
class TransactionModel{
  @HiveField(0)
  CategoryType type;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  final double amount;
  @HiveField(3)
  final String category;
  @HiveField(5) 
   String? id;

  TransactionModel({
  required  this.type,
   required this.date,
   required this.amount,
    required this.category,
    this.id});
    // {
    //   id = DateTime.now().millisecondsSinceEpoch.toString();
    // }
}