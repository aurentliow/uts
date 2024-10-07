import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'transaction.dart'; // Pastikan mengimpor Transaction dari transaction.dart
import 'page2.dart'; // Pastikan mengimpor Page2 untuk navigasi ke halaman berikutnya

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State(); // Pastikan createState sudah benar
}

class _Page1State extends State<Page1> {
  double totalIncome = 0;
  double totalExpenses = 0;
  List<Transaction> transactions = []; // Daftar transaksi

  // Fungsi untuk memformat angka ke format uang
  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID', // Menggunakan format Indonesia
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // Fungsi untuk menampilkan pop-up dialog
  void _showAddTransactionDialog() {
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    String? selectedType; // income or expenses

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Transaksi'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dropdown untuk memilih tipe (Income atau Expenses)
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
                        selectedType = newValue; // Perbarui nilai terpilih
                      });
                    },
                  ),
                  // Menampilkan teks yang terpilih
                  Text(
                    selectedType != null ? 'Tipe Terpilih: $selectedType' : 'Belum dipilih',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                ],
              );
            },
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
                // Memperbarui income atau expenses berdasarkan input
                if (selectedType != null && amountController.text.isNotEmpty) {
                  setState(() {
                    double amount = double.tryParse(amountController.text) ?? 0.0;
                    if (selectedType == 'Income') {
                      totalIncome += amount;
                    } else if (selectedType == 'Expenses') {
                      totalExpenses += amount;
                    }

                    // Tambah transaksi ke daftar
                    transactions.add(Transaction(
                      category: categoryController.text,
                      amount: amount,
                      type: selectedType!,
                    ));
                  });
                  Navigator.of(context).pop(); // Tutup dialog setelah menyimpan
                } else {
                  // Tampilkan pesan kesalahan jika tipe tidak dipilih
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Silakan pilih tipe transaksi dan masukkan jumlah.')),
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
                Text(
                  'Total Uang',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  formatCurrency(totalIncome - totalExpenses),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Income',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          formatCurrency(totalIncome),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expenses',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          formatCurrency(totalExpenses),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'History',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return ListTile(
                          leading: Icon(
                            transaction.type == 'Income'
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: transaction.type == 'Income'
                                ? Colors.green
                                : Colors.red,
                          ),
                          title: Text(transaction.category),
                          subtitle: Text(transaction.type),
                          trailing: Text(
                            formatCurrency(transaction.amount),
                            style: TextStyle(
                                color: transaction.type == 'Income'
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTransactionDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Page2(transactions: transactions),
              ),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
