import 'package:flutter/material.dart';
 
// Actually I didn't add uuid to pubspec. I'll use DateTime.now().toString() for IDs.

import '../models/transaction_model.dart';
import '../services/storage_service.dart';

class BankProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  double _balance = 0.0;
  List<TransactionModel> _transactions = [];

  double get balance => _balance;
  List<TransactionModel> get transactions => _transactions;

  Future<void> loadData() async {
    _balance = await _storageService.getBalance();
    _transactions = await _storageService.getTransactions();
    // Sort transactions by date desc
    _transactions.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  Future<void> deposit(double amount) async {
    _balance += amount;
    await _storageService.saveBalance(_balance);

    final transaction = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: TransactionType.deposit,
      amount: amount,
      date: DateTime.now(),
    );

    _transactions.insert(0, transaction);
    await _storageService.saveTransactions(_transactions);
    notifyListeners();
  }

  Future<bool> withdraw(double amount) async {
    if (_balance >= amount) {
      _balance -= amount;
      await _storageService.saveBalance(_balance);

      final transaction = TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: TransactionType.withdraw,
        amount: amount,
        date: DateTime.now(),
      );

      _transactions.insert(0, transaction);
      await _storageService.saveTransactions(_transactions);
      notifyListeners();
      return true;
    }
    return false;
  }
}
