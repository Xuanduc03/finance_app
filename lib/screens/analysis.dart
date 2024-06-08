import 'package:finance_app/app_event/add_transaction_event.dart';
import 'package:finance_app/app_event/update_transaction_event.dart';
import 'package:finance_app/model/transaction.dart';
import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:finance_app/model/data_service.dart';
import 'package:finance_app/model/utils.dart';
import 'package:finance_app/screens/update_transaction.dart';
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
  List day = ['Ngày', 'Tuần', 'Tháng', 'Năm'];
  int indexColor = 0;
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
                children: List.generate(day.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        indexColor = index;
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: indexColor == index
                            ? Color.fromARGB(255, 47, 125, 121)
                            : const Color.fromARGB(255, 208, 207, 207),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        day[index],
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              indexColor == index ? Colors.white : Colors.black,
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
              Container(
                height: 300,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Chart(),
              ),
              SizedBox(
                height: 20,
              ),
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
              SizedBox(
                height: 20,
              ),
              FutureBuilder<List<Transaction>>(
                future: dataService.getDataList(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Transaction>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SliverToBoxAdapter(
                      child: Center(
                          child:
                              CircularProgressIndicator()), // Hiển thị indicator khi đang tải dữ liệu
                    );
                  } else {
                    if (snapshot.hasError) {
                      return SliverToBoxAdapter(
                        child: Center(
                            child: Text(
                                'Đã xảy ra lỗi')), // Hiển thị thông báo lỗi nếu có
                      );
                    } else {
                      if (snapshot.data == null ||
                          snapshot.data?.isEmpty == true) {
                        return SliverToBoxAdapter(
                          child: Center(
                              child: Text(
                                  'Không có dữ liệu')), // Hiển thị thông báo nếu không có dữ liệu
                        );
                      } else {
                        // Hiển thị dữ liệu nếu không có lỗi
                        List<Transaction> data = snapshot.data!;
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.asset(
                                      './assets/image/${data[index].category}.png',
                                      fit: BoxFit.cover,
                                      width: 60,
                                      height: 60,
                                    ),
                                  ),
                                  title: Text(
                                    data[index].name as String,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    '${getDayOfWeek(data[index].dateTime)}  ${data[index].dateTime.day}/${data[index].dateTime.month}/${data[index].dateTime.year}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                  trailing: Text(
                                    NumberFormat('#,##0', 'en_US').format(
                                            int.parse(data[index].amount)) +
                                        'đ',
                                    style: TextStyle(
                                      color: data[index].type == "Chi phí"
                                          ? Colors.redAccent
                                          : Colors.green,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onTap: () async {
                                    Transaction? updatedData =
                                        await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateTransaction(
                                            data: data[index]),
                                      ),
                                    );
                                    if (updatedData != null) {
                                      await dataService.updateData(updatedData);
                                      setState(
                                          () {}); // Cập nhật lại danh sách sau khi chỉnh sửa
                                    }
                                  });
                            },
                            childCount: data.length,
                          ),
                        );
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
      );
    }
  }

