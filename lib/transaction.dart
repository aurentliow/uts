// transaction.dart
class Transaction {
  final String category;
  final double amount;
  final String type; // "Income" or "Expenses"

  Transaction({required this.category, required this.amount, required this.type});
}
