import 'package:flutter/material.dart';
import 'transaction.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'page3.dart';
import 'page4.dart';
import 'page5.dart';

class Page2 extends StatefulWidget {
  final List<Transaction> transactions;

  Page2({required this.transactions});

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  String selectedButton = 'Expenses'; // State untuk menyimpan button terpilih
  List<PieChartSectionData> pieSections = [];

  @override
  void initState() {
    super.initState();
    _updatePieSections();
  }

  void _updatePieSections() {
    double totalExpenses = widget.transactions
        .where((t) => t.type == 'Expenses')
        .fold(0, (sum, t) => sum + t.amount);
    double totalIncome = widget.transactions
        .where((t) => t.type == 'Income')
        .fold(0, (sum, t) => sum + t.amount);

    Map<String, double> expensesData = {};
    Map<String, double> incomeData = {};

    widget.transactions.where((t) => t.type == 'Expenses').forEach((transaction) {
      expensesData[transaction.category] = (expensesData[transaction.category] ?? 0) + transaction.amount;
    });

    widget.transactions.where((t) => t.type == 'Income').forEach((transaction) {
      incomeData[transaction.category] = (incomeData[transaction.category] ?? 0) + transaction.amount;
    });

    if (selectedButton == 'Expenses') {
      pieSections = expensesData.entries.map((entry) {
        return PieChartSectionData(
          color: Colors.primaries[expensesData.keys.toList().indexOf(entry.key) % Colors.primaries.length],
          value: entry.value,
          title: '${entry.key}\n${(entry.value / totalExpenses * 100).toStringAsFixed(1)}%',
          radius: 60,
          titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        );
      }).toList();
    } else {
      pieSections = incomeData.entries.map((entry) {
        return PieChartSectionData(
          color: Colors.primaries[incomeData.keys.toList().indexOf(entry.key) % Colors.primaries.length],
          value: entry.value,
          title: '${entry.key}\n${(entry.value / totalIncome * 100).toStringAsFixed(1)}%',
          radius: 60,
          titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        );
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalExpenses = widget.transactions
        .where((t) => t.type == 'Expenses')
        .fold(0, (sum, t) => sum + t.amount);
    double totalIncome = widget.transactions
        .where((t) => t.type == 'Income')
        .fold(0, (sum, t) => sum + t.amount);

    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildButton('Expenses', () {
                  setState(() {
                    selectedButton = 'Expenses';
                    _updatePieSections();
                  });
                }),
                SizedBox(width: 8),
                _buildButton('Income', () {
                  setState(() {
                    selectedButton = 'Income';
                    _updatePieSections();
                  });
                }),
                SizedBox(width: 8),
                _buildButton('Budget', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Page4(transactions: widget.transactions)),
                  );
                }),
                SizedBox(width: 8),
                _buildButton('Graphic', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Page5(transactions: widget.transactions)),
                  );
                }),
              ],
            ),
          ),
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
                    selectedButton == 'Expenses'
                        ? 'Total Expenses\n${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0).format(totalExpenses)}'
                        : 'Total Income\n${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0).format(totalIncome)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
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
                  ...widget.transactions
                      .where((transaction) => transaction.type == selectedButton)
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

  Widget _buildButton(String text, Function onPressed) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      child: Text(text),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
