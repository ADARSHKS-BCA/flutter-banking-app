import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../models/transaction_model.dart';

class StorageService {
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUser = 'user_data';
  static const String _keyBalance = 'account_balance';
  static const String _keyTransactions = 'transactions';

  Future<void> saveLoginState(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, isLoggedIn);
  }

  Future<bool> getLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, user.toJson());
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString(_keyUser);
    if (userJson == null) return null;
    return User.fromJson(userJson);
  }

  Future<void> saveBalance(double balance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyBalance, balance);
  }

  Future<double> getBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyBalance) ?? 0.0;
  }

  Future<void> saveTransactions(List<TransactionModel> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList =
        transactions.map((t) => t.toJson()).toList();
    await prefs.setStringList(_keyTransactions, jsonList);
  }

  Future<List<TransactionModel>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList(_keyTransactions);
    if (jsonList == null) return [];
    return jsonList.map((s) => TransactionModel.fromJson(s)).toList();
  }
  
  Future<void> clearAll() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
  }
}
