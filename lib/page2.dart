import 'package:flutter/material.dart';
import 'transaction.dart'; // Impor kelas Transaction di sini
import 'package:fl_chart/fl_chart.dart'; // Impor untuk pie chart
import 'package:intl/intl.dart';
import 'page3.dart';
import 'page4.dart';

class Page2 extends StatelessWidget {
  final List<Transaction> transactions; // Tambahkan ini

  Page2({required this.transactions});

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    // Menghitung total expenses dan data untuk pie chart
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

    List<PieChartSectionData> pieSections = [];

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
    } else if (selectedButton == 'Income') {
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
      ),
      body: Column(
        children: [
          // Tombol Horizontal
          Container(
            margin: EdgeInsets.all(16),
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              _buildButton('Expenses', onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Page3(transactions: widget.transactions),
                  ),
                );
              }),
              _buildButton('Income', onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Page4(transactions: widget.transactions),
                  ),
                );
              }),
              _buildButton('Budget', onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Page4(transactions: widget.transactions),
                  ),
                );
              }),
              _buildButton('Graphic', onPressed: () {
                // Tindakan untuk tombol Graphic jika ada
              }),
            ),
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
                  ...widget.transactions
                      .where((transaction) => transaction.type == selectedButton)
                      .map((transaction) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            transaction.category,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(width: 16), // Jarak antara kategori dan harga
                        Text(
                          NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: 'Rp. ',
                            decimalDigits: 0,
                          ).format(transaction.amount),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
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

  Widget _buildButton(String text, {required Function onPressed}) {
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
