import 'package:flutter/material.dart';
import 'transaction.dart'; // Pastikan untuk mengimpor model transaksi
import 'package:intl/intl.dart';

class Page4 extends StatelessWidget {
  final List<Transaction> transactions;

  Page4({required this.transactions});

  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  List<Map<String, dynamic>> budgets = []; // Menyimpan kategori dan anggaran

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan Budget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Budget List',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: budgets.length,
                itemBuilder: (context, index) {
                  final budget = budgets[index];
                  return Card(
                    child: ListTile(
                      title: Text(budget['category']),
                      trailing: Text(
                        'Rp. ${budget['amount'].toString()}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Kategori Budget'),
            ),
            TextField(
              controller: budgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Jumlah Budget (Rp.)'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (categoryController.text.isNotEmpty && budgetController.text.isNotEmpty) {
                  setState(() {
                    budgets.add({
                      'category': categoryController.text,
                      'amount': double.tryParse(budgetController.text) ?? 0.0,
                    });
                  });
                  categoryController.clear();
                  budgetController.clear();
                }
              },
              child: Text('Tambah Budget'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic untuk menambah anggaran bisa ditempatkan di sini jika perlu
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
