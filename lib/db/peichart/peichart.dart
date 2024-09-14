import '../../models/transactions/transaction_model.dart';

class Chart {
  Chart({required this.category,required this.amount});
  String? category;
  double? amount;
}
 List<Chart> chartCalculation(List<TransactionModel> data) {
    String categoryName;
    double values;
    List visited = [];
    List<Chart> datas = [];

    for (var i = 0; i < data.length; i++) {
      visited.add(0);
    }

    for (var i = 0; i < data.length; i++) {
      values = data[i].amount;
      categoryName = data[i].category.toString();

      for (var j = i + 1; j < data.length; j++) {
        if (data[i].category.toString() == data[j].category.toString()) {
          values += data[j].amount;
          visited[j] = -1;
        }
      } 

      // ignore: unrelated_type_equality_checks
      if (visited[i]  != -1) {
          datas.add((Chart(category: categoryName,amount:  values))
      );
      } 
    }

    return datas;
  }