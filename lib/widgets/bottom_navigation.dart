import 'package:finance_app/screens/user_profile.dart';
import 'package:finance_app/screens/wallet.dart';
import 'package:flutter/material.dart';
import 'package:finance_app/screens/add.dart';
import 'package:finance_app/screens/analysis.dart';
import 'package:finance_app/screens/home.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int index_color = 0;
  List<Widget> screen = [HomeScreen(), Analysis(), Wallet(), UserProfile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[index_color],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddScreen(),
          ));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.greenAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  index_color = 0;
                });
              },
              child: Icon(
                Icons.home,
                size: 30,
                color: index_color == 0 ? Colors.green : Colors.grey,
              ),
            ),

            GestureDetector(
              onTap: () {
                setState(() {
                  index_color = 1;
                });
              },
              child: Icon(
                Icons.bar_chart_outlined,
                size: 30,
                color: index_color == 1 ? Colors.green : Colors.grey,
              ),
            ),
            SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  index_color = 2;
                });
              },
              child: Icon(
                Icons.account_balance_wallet_outlined,
                size: 30,
                color: index_color == 2 ? Colors.green : Colors.grey,
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  index_color = 3;
                });
              },
              child: Icon(
                Icons.person_outlined,
                size: 30,
                color: index_color == 3 ? Colors.green : Colors.grey, // Changed to person_outlined
              ),
            ),
          ],
        ),
      ),
    );
  }
}
