import 'package:finance_app/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      // height: 300,
      // child: SfCartesianChart(
      //   primaryXAxis: CategoryAxis(),
      //   series: <SplineSeries<Transaction, String>>[
      //     SplineSeries<Transaction, String>(
      //       dataSource: <Transaction>[
      //         Transaction(100, 'Mon'),
      //         Transaction(200, 'Tue'),
      //         Transaction(50, 'Wed'),
      //         Transaction(65, 'Sat'),
      //       ],
      //       xValueMapper: (Transaction transaction, _) => transaction.dateTime,
      //       yValueMapper: (Transaction transaction, _) => transaction.amount,
      //     ),
      //   ],
      // ),
    );
  }
}

