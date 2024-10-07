import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'transaction.dart';
import 'package:intl/intl.dart';
import 'page2.dart';
import 'page3.dart';
import 'page4.dart';

class Page5 extends StatelessWidget {
  final List<Transaction> transactions;

  Page5({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Keuangan Bulanan'),
      ),
      body: Column(
        children: [
          _buildButtonRow(context),
          Expanded(
            child: _buildMonthlyLineChart(),
          ),
          _buildSummary(),
        ],
      ),
    );
  }

  Widget _buildButtonRow(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildButton('Home', () {
            Navigator.pop(context);
          }),
          SizedBox(width: 8),
          _buildButton('Analytics', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Page2(transactions: transactions)),
            );
          }),
          SizedBox(width: 8),
          _buildButton('Income', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Page3(transactions: transactions)),
            );
          }),
          SizedBox(width: 8),
          _buildButton('Budget', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Page4(transactions: transactions)),
            );
          }),
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

  Widget _buildMonthlyLineChart() {
    Map<String, double> monthlyIncome = {};
    Map<String, double> monthlyExpenses = {};

    for (var transaction in transactions) {
      String month = DateFormat('MMMM').format(transaction.date);
      if (transaction.type == 'Income') {
        monthlyIncome[month] = (monthlyIncome[month] ?? 0) + transaction.amount;
      } else {
        monthlyExpenses[month] = (monthlyExpenses[month] ?? 0) + transaction.amount;
      }
    }

    List<FlSpot> incomeSpots = monthlyIncome.entries.map((entry) {
      int monthIndex = DateFormat('MMMM').parse(entry.key).month;
      return FlSpot(monthIndex.toDouble(), entry.value);
    }).toList();

    List<FlSpot> expenseSpots = monthlyExpenses.entries.map((entry) {
      int monthIndex = DateFormat('MMMM').parse(entry.key).month;
      return FlSpot(monthIndex.toDouble(), entry.value);
    }).toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: SideTitles(
            showTitles: true,
            reservedSize: 40, // Ruang untuk label vertikal
            margin: 16, // Margin untuk memberi jarak
          ),
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 38,
            margin: 8, // Margin untuk memberi jarak pada label bawah
          ),
        ),
        borderData: FlBorderData(show: true),
        minX: 0,
        maxX: 12, // Total bulan
        minY: 0,
        maxY: monthlyIncome.values.isNotEmpty ? monthlyIncome.values.reduce((a, b) => a > b ? a : b) + 1000 : 1000,
        lineBarsData: [
          LineChartBarData(
            spots: incomeSpots,
            isCurved: false, // Menggunakan garis lurus
            colors: [Colors.green],
            barWidth: 4,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: true), // Menampilkan titik pada garis
          ),
          LineChartBarData(
            spots: expenseSpots,
            isCurved: false, // Menggunakan garis lurus
            colors: [Colors.red],
            barWidth: 4,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: true), // Menampilkan titik pada garis
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    double totalIncome = transactions
        .where((t) => t.type == 'Income')
        .fold(0, (sum, t) => sum + t.amount);
    double totalExpenses = transactions
        .where((t) => t.type == 'Expenses')
        .fold(0, (sum, t) => sum + t.amount);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ringkasan Bulanan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text('Total Income: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ').format(totalIncome)}'),
          Text('Total Expenses: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ').format(totalExpenses)}'),
          Text('Total: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ').format(totalIncome - totalExpenses)}'),
        ],
      ),
    );
  }
}
