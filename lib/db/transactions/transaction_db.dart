import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:walletcontroller/models/category/category_model.dart';
import 'package:walletcontroller/models/transactions/transaction_model.dart';


DateTime dateTime = DateTime.now();

const tranasactiondbname = "transaction-database";

abstract class TransactionDbFunctions {
  Future<void> addTransactions(TransactionModel obj);
  Future<List<TransactionModel>> getAllTransactions();
  Future<void> deleteTransaction(String transactionId);
  Future<void> updateTransaction(TransactionModel value);
  Future<void> clearAllTransaction();

  //Future<void> sortedList(String selected);

}

class TransactionDb implements TransactionDbFunctions {
  TransactionDb._internal(); //craete a internal named constructor
  static TransactionDb instance =
      TransactionDb._internal(); //assigning  that construcor in here

  factory TransactionDb() {
    return instance;
  }

  // ignore: non_constant_identifier_names
  ValueNotifier<List<TransactionModel>> TransactionListNotifier =
      ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> sortingNotifier = ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> todaysortingNotifier =
      ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> yesterdaysortingNotifier =
      ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> monthsortingNotifier =
      ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> customNotifier = ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> monthsoNotifier = ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> overviewallsoNotifier =
      ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> overviewexpenseallNotifier =
      ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> overviewtodaysoNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> overviewincometodayseallNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> overviewincomeyesterdayeallNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> overviewincomethismontheallNotifier =
      ValueNotifier([]);

  ValueNotifier<List<TransactionModel>> overviewexpenseyesterdayeallNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> overviewexpensetodayeallNotifier =
      ValueNotifier([]);

  @override
  Future<void> addTransactions(TransactionModel obj) async {
    final _db = await Hive.openBox<TransactionModel>(tranasactiondbname);
    _db.put(obj.id, obj);
  }

  Future<void> refresh() async {
    final _list = await getAllTransactions();
    _list.sort((first, second) => second.date.compareTo(first.date));
    TransactionListNotifier.value.clear();
    TransactionListNotifier.value.addAll(_list);
    TransactionListNotifier.notifyListeners();
    todaysortingNotifier.value.clear();
    yesterdaysortingNotifier.value.clear();
    monthsortingNotifier.value.clear();
    sortingNotifier.value.clear();

    overviewallsoNotifier.value.clear();

    overviewexpenseallNotifier.value.clear();

    final today = DateFormat().add_yMMMMd().format(DateTime.now());
    final yesterday = DateFormat()
        .add_yMMMMd()
        .format(DateTime.now().subtract(const Duration(days: 1)));
    final month = DateFormat().add_yMMM().format(DateTime.now());

    await Future.forEach(_list, (TransactionModel lists) {
      final dates = DateFormat().add_yMMMMd().format(lists.date);
      final months = DateFormat().add_yMMM().format(lists.date);

      if (dates == today) {
        todaysortingNotifier.value.add(lists);
      }
      if (dates == yesterday) {
        yesterdaysortingNotifier.value.add(lists);
      }
      if (months == month) {
        monthsortingNotifier.value.add(lists);
      }
      if (lists.type == CategoryType.income) {
        overviewallsoNotifier.value.add(lists);
      }
      if (lists.type == CategoryType.expense) {
        overviewexpenseallNotifier.value.add(lists);
      }

      final ___list = overviewexpenseallNotifier.value;
      overviewexpensetodayeallNotifier.value.clear();
      overviewexpenseyesterdayeallNotifier.value.clear();
      overviewincomethismontheallNotifier.value.clear();

      Future.forEach(___list, (TransactionModel data) {
        final dates = DateFormat().add_yMMMMd().format(data.date);
        final months = DateFormat().add_yMMM().format(data.date);
        if (dates == today) {
          overviewexpensetodayeallNotifier.value.add(data);
        }

        if (dates == yesterday) {
          overviewexpenseyesterdayeallNotifier.value.add(lists);
        }
        if (months == month) {
          overviewincomethismontheallNotifier.value.add(data);
        }

        overviewexpensetodayeallNotifier.notifyListeners();
        overviewexpenseyesterdayeallNotifier.notifyListeners();
      });

      overviewincometodayseallNotifier.value.clear();
      overviewincomeyesterdayeallNotifier.value.clear();
      overviewincomethismontheallNotifier.value.clear();

      final __list = overviewallsoNotifier.value;
      Future.forEach(
        __list,
        (TransactionModel data) {
          final dates = DateFormat().add_yMMMMd().format(data.date);
          final months = DateFormat().add_yMMM().format(data.date);
          if (dates == today) {
            overviewincometodayseallNotifier.value.add(data);
          }

          if (dates == yesterday) {
            overviewincomeyesterdayeallNotifier.value.add(lists);
          }
          if (months == month) {
            overviewincomethismontheallNotifier.value.add(data);
          }
          overviewincomethismontheallNotifier.notifyListeners();
          overviewincometodayseallNotifier.notifyListeners();
          overviewincomeyesterdayeallNotifier.notifyListeners();
        },
      );
    });

    overviewexpenseyesterdayeallNotifier.notifyListeners();
    overviewexpensetodayeallNotifier.notifyListeners();
    todaysortingNotifier.notifyListeners();
    yesterdaysortingNotifier.notifyListeners();
    monthsortingNotifier.notifyListeners();
    sortingNotifier.notifyListeners();
    overviewallsoNotifier.notifyListeners();
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final _db = await Hive.openBox<TransactionModel>(tranasactiondbname);
    return _db.values.toList();
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    final _db = await Hive.openBox<TransactionModel>(tranasactiondbname);

    await _db.delete(transactionId);
    refresh();
  }

  @override
  Future<void> updateTransaction(TransactionModel value) async {
    final _db = await Hive.openBox<TransactionModel>(tranasactiondbname);
    _db.put(value.id, value);
    //refresh();
    getAllTransactions();
  }

  @override
  Future<void> clearAllTransaction() async {
   
    final _db = await Hive.openBox<TransactionModel>(tranasactiondbname);
   await _db.clear();
  
  }   
}   
