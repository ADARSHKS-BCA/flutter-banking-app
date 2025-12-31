import 'package:flutter/material.dart';
 
// Actually I didn't add uuid to pubspec. I'll use DateTime.now().toString() for IDs.

import '../models/transaction_model.dart';
import '../services/api_service.dart';

class BankProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  double _balance = 0.0;
  List<TransactionModel> _transactions = [];

  double get balance => _balance;
  List<TransactionModel> get transactions => _transactions;

  Future<void> loadData() async {
    final accountData = await _apiService.getAccount();
    if (accountData != null) {
      _balance = double.tryParse(accountData['balance'].toString()) ?? 0.0;
    }
    
    final transactionsData = await _apiService.getTransactions();
    _transactions = transactionsData
        .map((t) => TransactionModel.fromMap(t))
        .toList();
    
    notifyListeners();
  }

  Future<void> deposit(double amount) async {
    final success = await _apiService.deposit(amount);
    if (success) {
      await loadData(); // Refresh data from server
    }
  }

  Future<bool> withdraw(double amount) async {
    final success = await _apiService.withdraw(amount);
    if (success) {
      await loadData(); // Refresh data from server
      return true;
    }
    return false;
  }

  Future<bool> transfer(String recipientUsername, double amount) async {
    final success = await _apiService.transfer(recipientUsername, amount);
    if (success) {
      await loadData(); // Refresh data from server
      return true;
    }
    return false;
  }
}
