import 'package:finance_app/model/data_service.dart';
import 'package:finance_app/model/utils.dart';
import 'package:flutter/material.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  DataService dataService = DataService();
  // Dữ liệu giả lập cho thẻ ngân hàng
  final String cardNumber = '6886 8888 7997';
  final String balance = '1,500,000';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ví của tôi', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 7, 21, 131), Color.fromARGB(255, 100, 139, 255)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Thẻ ngân hàng',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                        Icon(
                          Icons.credit_card,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "6886 8888 7997",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Chủ thẻ',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Mai Xuân Đức",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Divider(color: Colors.white70),
                    SizedBox(height: 20),
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
                                fontSize: 25,
                                fontWeight: FontWeight.w600),
                          );
                        }
                      }),
                    SizedBox(height: 10),
                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
