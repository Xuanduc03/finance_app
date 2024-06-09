import 'package:finance_app/model/transaction.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatefulWidget {
  final List<Transaction> transactions;

  const Chart({super.key, required this.transactions});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      child: SfCartesianChart(
        primaryXAxis: DateTimeAxis(), // Use DateTimeAxis for date-time based data
        series: <SplineSeries<Transaction, DateTime>>[
          SplineSeries<Transaction, DateTime>(
            dataSource: widget.transactions,
            xValueMapper: (Transaction transaction, _) => transaction.dateTime,
            yValueMapper: (Transaction transaction, _) => double.parse(transaction.amount),
            dataLabelSettings: DataLabelSettings(isVisible: true), // Display labels on data points
          ),
        ],
      ),
    );
  }
}
