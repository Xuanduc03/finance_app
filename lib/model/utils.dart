import 'package:finance_app/model/transaction.dart';
import 'package:intl/intl.dart';

import 'package:finance_app/model/data_service.dart';

Future<String> total() async {
  DataService dataService = DataService();
  List<Transaction> data = await dataService.getDataList();

  if (data.isEmpty) {
    return '0';
  }

  List<int> amounts = [];
  for (var entry in data) {
    int amount = int.parse(entry.amount);
    if (entry.type == "Thu nhập") {
      amounts.add(amount);
    } else {
      amounts.add(-amount);
    }
  }

  int totalAmount = amounts.reduce((value, element) => value + element);
  return NumberFormat('#,##0', 'en_US').format(totalAmount);
}

//hàm tính rổng thu nhập
Future<String> totalIncome() async {
  DataService dataService = DataService();
  List<Transaction> data = await dataService.getDataList();

  if (data.isEmpty) {
    return '0';
  }

  int totalIncome = data
      .where((entry) => entry.type == "Thu nhập")
      .map((entry) => int.parse(entry.amount))
      .reduce((value, element) => value + element);

  return NumberFormat('#,##0', 'en_US').format(totalIncome);
}

//hàm tính tổng chi phí
Future<String> totalExpenses() async {
  DataService dataService = DataService();
  List<Transaction> data = await dataService.getDataList();

  if (data.isEmpty) {
    return '0';
  }

  int totalExpenses = data
      .where((entry) => entry.type != "Thu nhập")
      .map((entry) => int.parse(entry.amount))
      .reduce((value, element) => value + element);

  return NumberFormat('#,##0', 'en_US').format(totalExpenses);
}

String getDayOfWeek(DateTime date) {
  if (DateTime.now().day == date.day &&
      DateTime.now().month == date.month &&
      DateTime.now().year == date.year) {
    return "Hôm nay";
  } else {
    return DateFormat('EEEE').format(date);
  }
}
