import 'package:flutter/foundation.dart';

class Transaction {
  final String category; // Kategori transaksi (misalnya: makanan, transportasi)
  final double amount;   // Jumlah uang yang terlibat dalam transaksi
  final String type;     // Tipe transaksi (Income atau Expenses)
  final DateTime date;   // Tanggal transaksi

  Transaction({
    required this.category,
    required this.amount,
    required this.type,
    required this.date, // Tambahkan parameter untuk tanggal
  });
}
