import 'package:finance_app/app_event/add_transaction_event.dart';
import 'package:finance_app/app_event/update_transaction_event.dart';
import 'package:finance_app/model/transaction.dart';
import 'package:event_bus_plus/event_bus_plus.dart';
import 'package:finance_app/model/data_service.dart';
import 'package:finance_app/model/utils.dart';
import 'package:finance_app/screens/update_transaction.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/helpers/global.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

    // lang nghe su kien update
    eventBus.on<UpdateTransactionEvent>().listen((event) {
      setState(() {
        _dataListFuture = dataService.getDataList();
      });
    });
  }

  

  Future<void> _refreshDataList() async {
    setState(() {
      _dataListFuture = dataService.getDataList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 340,
                child: _head(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Lịch sử giao dịch",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 19),
                    ),
                    Text(
                      "Xem tất cả",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    )
                  ],
                ),
              ),
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
                            //xóa phần tử bằng vuốt
                            return Dismissible(
                              key: Key(data[index].name),
                              onDismissed: (direction) async {
                                await dataService.removeData(data[index]);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            '${data[index].name} đã bị xóa')));
                                _refreshDataList();
                              },
                              child: ListTile(
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
                                    Transaction? updatedData = await Navigator.push(
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
                                  }),
                            );
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

  Widget _head() {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              height: 240,
              decoration: BoxDecoration(
                  color: Color(0xff368983),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              child: Stack(
                children: [
                  Positioned(
                      top: 16,
                      left: 350,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Container(
                          height: 40,
                          width: 40,
                          color: Color.fromRGBO(250, 250, 250, 0.1),
                          child: Icon(
                            Icons.notification_add_outlined,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Chào buổi tối",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                        Text(
                          "Mai Xuan Duc",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.white),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Positioned(
            top: 140,
            left: 37,
            child: Container(
              height: 170,
              width: 340,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(47, 125, 121, 0.3),
                        offset: Offset(0, 6),
                        blurRadius: 12,
                        spreadRadius: 6)
                  ],
                  color: Color.fromARGB(255, 30, 52, 52),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tổng cộng",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                        Icon(
                          Icons.more_horiz,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  FutureBuilder(
                      future: total(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(
                            color: Colors.white,
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                            "Error",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          );
                        } else {
                          return Text(
                            '${snapshot.data} VND',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          );
                        }
                      }),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 13,
                              backgroundColor:
                                  Color.fromARGB(255, 85, 145, 141),
                              child: Icon(
                                Icons.arrow_downward,
                                color: Colors.white,
                                size: 19,
                              ),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              "Chi Phí",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 216, 216, 216)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 13,
                              backgroundColor:
                                  Color.fromARGB(255, 85, 145, 141),
                              child: Icon(
                                Icons.arrow_upward,
                                color: Colors.white,
                                size: 19,
                              ),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              "Thu Nhập",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 216, 216, 216)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FutureBuilder(
                            future: totalExpenses(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(
                                  color: Colors.white,
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  "Error",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                );
                              } else {
                                return Text(
                                  '${snapshot.data} Đ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                );
                              }
                            }),
                        FutureBuilder(
                            future: totalIncome(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(
                                  color: Colors.white,
                                );
                              } else if (snapshot.hasError) {
                                return Text(
                                  "Error",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                );
                              } else {
                                return Text(
                                  '${snapshot.data} Đ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                );
                              }
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ))
      ],
    );
  }
}
