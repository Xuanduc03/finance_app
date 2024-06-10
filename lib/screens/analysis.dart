import 'package:finance_app/app_event/add_transaction_event.dart';
import 'package:finance_app/model/transaction.dart';
import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:finance_app/model/data_service.dart';
import 'package:finance_app/model/utils.dart';
import 'package:finance_app/widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/helpers/global.dart';
import 'package:intl/intl.dart';

class Analysis extends StatefulWidget {
  const Analysis({super.key});

  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  List<String> periods = ['Ngày', 'Tuần', 'Tháng', 'Năm'];
  int selectedPeriodIndex = 0;
  DataService dataService = DataService();
  late Future<List<Transaction>> _dataListFuture;

  @override
  void initState() {
    super.initState();
    _dataListFuture = dataService.getDataList();
    eventBus.on<AddTransactionEvent>().listen((event) {
      setState(() {
        _dataListFuture = dataService.getDataList();
      });
    });
  }

  List<Transaction> filterTransactionsByPeriod(List<Transaction> transactions, String period) {
    DateTime now = DateTime.now();
    List<Transaction> filteredTransactions = [];

    switch (period) {
      case 'Ngày':
        filteredTransactions = transactions.where((tx) =>
            tx.dateTime.year == now.year &&
            tx.dateTime.month == now.month &&
            tx.dateTime.day == now.day).toList();
        break;
      case 'Tuần':
        DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        filteredTransactions = transactions.where((tx) =>
            tx.dateTime.isAfter(startOfWeek) &&
            tx.dateTime.isBefore(startOfWeek.add(Duration(days: 7)))).toList();
        break;
      case 'Tháng':
        filteredTransactions = transactions.where((tx) =>
            tx.dateTime.year == now.year &&
            tx.dateTime.month == now.month).toList();
        break;
      case 'Năm':
        filteredTransactions = transactions.where((tx) =>
            tx.dateTime.year == now.year).toList();
        break;
    }

    return filteredTransactions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          children: [
            Text(
              "Phân tích dữ liệu",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(periods.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPeriodIndex = index;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: selectedPeriodIndex == index
                          ? Color.fromARGB(255, 47, 125, 121)
                          : const Color.fromARGB(255, 208, 207, 207),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      periods[index],
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedPeriodIndex == index ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 120,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Chi Phí",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.arrow_downward,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            FutureBuilder<List<Transaction>>(
              future: _dataListFuture,
              builder: (BuildContext context, AsyncSnapshot<List<Transaction>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Đã xảy ra lỗi'));
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Center(child: Text('Không có dữ liệu'));
                } else {
                  List<Transaction> filteredTransactions = filterTransactionsByPeriod(
                    snapshot.data!,
                    periods[selectedPeriodIndex],
                  );
                  return Column(
                    children: [
                      Container(
                        height: 300,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Chart(transactions: filteredTransactions),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            Text(
                              "Sắp xếp chi phí",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.swap_vert,
                              size: 25,
                              color: Colors.amberAccent,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                './assets/image/${filteredTransactions[index].category}.png',
                                fit: BoxFit.cover,
                                width: 60,
                                height: 60,
                              ),
                            ),
                            title: Text(
                              filteredTransactions[index].name,
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              '${getDayOfWeek(filteredTransactions[index].dateTime)}  ${filteredTransactions[index].dateTime.day}/${filteredTransactions[index].dateTime.month}/${filteredTransactions[index].dateTime.year}',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            trailing: Text(
                              NumberFormat('#,##0', 'en_US')
                                      .format(int.parse(filteredTransactions[index].amount)) +
                                  'đ',
                              style: TextStyle(
                                color: filteredTransactions[index].type == "Chi phí"
                                    ? Colors.redAccent
                                    : Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
