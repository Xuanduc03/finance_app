import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'transaction.dart';

class DataService {
  final String dataListKey = 'items';

  //lưu đối tượng vào share
  Future<void> saveData(Transaction data) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? items = prefs.getStringList('items');
    if (items == null) {
      data.id = 0;
    } else {
      data.id = items.length;
    }
    String jsonData = jsonEncode(data.toJson());
    if (items != null) {
      items.add(jsonData);
      prefs.setStringList(dataListKey, items);
    } else {
      prefs.setStringList(dataListKey, <String>[jsonData]);
    }

    await prefs.setString('add_data', jsonData);
  }

  //lay doi tuong tu share
  Future<Transaction?> getData() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('add_data');
    if (jsonData == null) return null;
    Map<String, dynamic> jsonMap = jsonDecode(jsonData);
    return Transaction.fromJson(jsonMap);
  }

// Lấy danh sách đối tượng từ SharedPreferences
  Future<List<Transaction>> getDataList() async {
    List<Transaction> dataList = [];
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonDataList = prefs.getStringList(dataListKey);
    if (jsonDataList != null && jsonDataList.isNotEmpty) {
      for (final json in jsonDataList) {
        Map<String, dynamic> jsonMap = jsonDecode(json);
        dataList.add(Transaction.fromJson(jsonMap));
      }
    }
    return dataList;
  }

  //xoa du lieu tu share
  Future<void> removeData(Transaction data) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? items = prefs.getStringList(dataListKey);
    if (items != null && items.isNotEmpty) {
      items.removeWhere((json) {
        final Map<String, dynamic> jsonMap = jsonDecode(json);
        final Transaction item = Transaction.fromJson(jsonMap);
        // return item.name == data.name &&
        //     item.category == data.category &&
        //     item.type == data.type &&
        //     item.amount == data.amount &&
        //     item.dateTime == data.dateTime;
        return item.id == data.id;
      });
      prefs.setStringList(dataListKey, items);
    }
  }

  // cập nhật dữ liệu
  Future<void> updateData(Transaction newData) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? items = prefs.getStringList(dataListKey);
    // items?.map((item) {
    //   Transaction transaction = Transaction.fromJson(jsonDecode(item));
    //   return transaction.id == newData.id;
    // });
    if (items != null && items.isNotEmpty) {
      items = items.map((json) {
        Map<String, dynamic> jsonMap = jsonDecode(json);
        // if (jsonMap['name'] == newData.name &&
        //     jsonMap['category'] == newData.category &&
        //     jsonMap['type'] == newData.type &&
        //     jsonMap['amount'] == newData.amount &&
        //     jsonMap['dateTime'] == newData.dateTime.toIso8601String()) {
        //   return jsonEncode(newData.toJson());
        // }
        if (jsonMap['id'] == newData.id) {
          return jsonEncode(newData.toJson());
        }
        return json;
      }).toList();
      prefs.setStringList(dataListKey, items);
    }
  }
}
