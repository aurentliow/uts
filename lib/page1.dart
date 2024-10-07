import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'transaction.dart';
import 'page2.dart';

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  double totalIncome = 0;
  double totalExpenses = 0;
  List<Transaction> transactions = [];
  DateTime selectedDate = DateTime.now(); // Tambahkan variabel untuk tanggal

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  void _showAddTransactionDialog() {
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    String? selectedType;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Transaksi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                hint: Text('Pilih Tipe'),
                value: selectedType,
                items: <String>['Income', 'Expenses'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedType = newValue;
                  });
                },
              ),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Kategori'),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Harga (Rp.)'),
              ),
              // Tambahkan pemilih tanggal
              ListTile(
                title: Text('Tanggal: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != selectedDate) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedType != null && amountController.text.isNotEmpty) {
                  double amount = double.tryParse(amountController.text) ?? 0.0;
                  setState(() {
                    if (selectedType == 'Income') {
                      totalIncome += amount;
                    } else {
                      totalExpenses += amount;
                    }
                    transactions.add(Transaction(
                      category: categoryController.text,
                      amount: amount,
                      type: selectedType!,
                      date: selectedDate, // Simpan tanggal transaksi
                    ));
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Silakan pilih tipe dan masukkan jumlah.')),
                  );
                }
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengelolaan Keuangan'),
      ),
      body: Column(
        children: [
          // Total Uang
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.pink[100],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Uang', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(formatCurrency(totalIncome - totalExpenses), style: TextStyle(fontSize: 30, color: Colors.green)),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Income
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Income', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(formatCurrency(totalIncome), style: TextStyle(fontSize: 16, color: Colors.green)),
                      ],
                    ),
                    // Expenses
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Expenses', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(formatCurrency(totalExpenses), style: TextStyle(fontSize: 16, color: Colors.red)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // List Transaksi
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return ListTile(
                  leading: Icon(transaction.type == 'Income' ? Icons.arrow_upward : Icons.arrow_downward,
                      color: transaction.type == 'Income' ? Colors.green : Colors.red),
                  title: Text(transaction.category),
                  subtitle: Text(transaction.type),
                  trailing: Text(formatCurrency(transaction.amount), style: TextStyle(color: transaction.type == 'Income' ? Colors.green : Colors.red)),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTransactionDialog,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Page2(transactions: transactions)),
            );
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analytics'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
    );
  }
}
