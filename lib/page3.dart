import 'package:flutter/material.dart';
import 'transaction.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class Page3 extends StatelessWidget {
  final List<Transaction> transactions;

  Page3({required this.transactions});

  @override
  Widget build(BuildContext context) {
    double totalIncome = transactions.where((t) => t.type == 'Income').fold(0, (sum, t) => sum + t.amount);
    Map<String, double> incomeData = {};

    transactions.where((t) => t.type == 'Income').forEach((transaction) {
      incomeData[transaction.category] = (incomeData[transaction.category] ?? 0) + transaction.amount;
    });

    List<PieChartSectionData> pieSections = incomeData.entries.map((entry) {
      return PieChartSectionData(
        color: Colors.primaries[incomeData.keys.toList().indexOf(entry.key) % Colors.primaries.length],
        value: entry.value,
        title: '${entry.key}\n${(entry.value / totalIncome * 100).toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Income Analytics'),
      ),
      body: Column(
        children: [
          // Tombol Horizontal
          Container(
            margin: EdgeInsets.all(16),
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildButton(context, 'Expenses'),
                SizedBox(width: 8),
                _buildButton(context, 'Income', isSelected: true),
                SizedBox(width: 8),
                _buildButton(context, 'Budget'),
                SizedBox(width: 8),
                _buildButton(context, 'Graphic'),
              ],
            ),
          ),

          // Pie Chart
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sections: pieSections,
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2,
                    ),
                  ),
                  Text(
                    'Total Income\n${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0).format(totalIncome)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          // History
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...transactions
                      .where((transaction) => transaction.type == 'Income')
                      .map((transaction) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      '${transaction.category}  ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0).format(transaction.amount)}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ))
                      .toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Membuat tombol dengan gaya
  Widget _buildButton(BuildContext context, String text, {bool isSelected = false}) {
    return ElevatedButton(
      onPressed: () {
        // Implement navigasi sesuai kebutuhan
      },
      child: Text(text),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: isSelected ? Colors.blue : Colors.grey, // Ganti primary dengan backgroundColor
      ),
    );
  }
}
