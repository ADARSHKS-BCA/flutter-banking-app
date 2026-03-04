import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/transaction_model.dart';
import '../models/savings_goal_model.dart';
import '../models/favorite_contact_model.dart';
import '../services/api_service.dart';

class BankProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  double _balance = 0.0;
  List<TransactionModel> _transactions = [];
  List<SavingsGoal> _savingsGoals = [];
  List<FavoriteContact> _favoriteContacts = [];
  List<double> _balanceHistory = [];
  DateTime? _lastLoginTime;

  double get balance => _balance;
  List<TransactionModel> get transactions => _transactions;
  List<SavingsGoal> get savingsGoals => _savingsGoals;
  List<FavoriteContact> get favoriteContacts => _favoriteContacts;
  List<double> get balanceHistory => _balanceHistory;
  DateTime? get lastLoginTime => _lastLoginTime;

  // ── Computed getters from real transaction data ──

  double get totalIncome {
    return _transactions
        .where((t) => t.type == TransactionType.deposit)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalExpense {
    return _transactions
        .where((t) =>
            t.type == TransactionType.withdraw ||
            t.type == TransactionType.transfer)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get monthlyIncome {
    final now = DateTime.now();
    return _transactions
        .where((t) =>
            t.type == TransactionType.deposit &&
            t.date.month == now.month &&
            t.date.year == now.year)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get monthlyExpense {
    final now = DateTime.now();
    return _transactions
        .where((t) =>
            (t.type == TransactionType.withdraw ||
                t.type == TransactionType.transfer) &&
            t.date.month == now.month &&
            t.date.year == now.year)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // ── Load All Data ──

  Future<void> loadData() async {
    final accountData = await _apiService.getAccount();
    if (accountData != null) {
      _balance = double.tryParse(accountData['balance'].toString()) ?? 0.0;
    }

    final transactionsData = await _apiService.getTransactions();
    _transactions =
        transactionsData.map((t) => TransactionModel.fromMap(t)).toList();

    // Load locally persisted data
    await _loadSavingsGoals();
    await _loadFavoriteContacts();
    await _loadLastLoginTime();
    await _recordBalanceHistory();

    notifyListeners();
  }

  // ── Deposit / Withdraw / Transfer ──

  Future<void> deposit(double amount) async {
    final success = await _apiService.deposit(amount);
    if (success) {
      await loadData();
    }
  }

  Future<bool> withdraw(double amount) async {
    final success = await _apiService.withdraw(amount);
    if (success) {
      await loadData();
      return true;
    }
    return false;
  }

  Future<bool> transfer(String recipientUsername, double amount) async {
    final success = await _apiService.transfer(recipientUsername, amount);
    if (success) {
      await loadData();
      return true;
    }
    return false;
  }

  // ── Savings Goals ──

  Future<void> addSavingsGoal(SavingsGoal goal) async {
    _savingsGoals.add(goal);
    await _persistSavingsGoals();
    notifyListeners();
  }

  Future<void> updateSavingsGoal(String id,
      {double? currentAmount, double? targetAmount, String? name}) async {
    final index = _savingsGoals.indexWhere((g) => g.id == id);
    if (index != -1) {
      _savingsGoals[index] = _savingsGoals[index].copyWith(
        currentAmount: currentAmount,
        targetAmount: targetAmount,
        name: name,
      );
      await _persistSavingsGoals();
      notifyListeners();
    }
  }

  Future<void> addToSavingsGoal(String id, double amount) async {
    final index = _savingsGoals.indexWhere((g) => g.id == id);
    if (index != -1) {
      final goal = _savingsGoals[index];
      final newAmount =
          (goal.currentAmount + amount).clamp(0.0, goal.targetAmount);
      _savingsGoals[index] = goal.copyWith(currentAmount: newAmount);
      await _persistSavingsGoals();
      notifyListeners();
    }
  }

  Future<void> deleteSavingsGoal(String id) async {
    _savingsGoals.removeWhere((g) => g.id == id);
    await _persistSavingsGoals();
    notifyListeners();
  }

  Future<void> _persistSavingsGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _savingsGoals.map((g) => g.toJson()).toList();
    await prefs.setStringList('savings_goals', jsonList);
  }

  Future<void> _loadSavingsGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('savings_goals');
    if (jsonList != null) {
      _savingsGoals =
          jsonList.map((s) => SavingsGoal.fromJson(s)).toList();
    }
  }

  // ── Favorite Contacts ──

  Future<void> addFavoriteContact(FavoriteContact contact) async {
    // Prevent duplicates
    if (_favoriteContacts.any((c) => c.username == contact.username)) return;
    _favoriteContacts.add(contact);
    await _persistFavoriteContacts();
    notifyListeners();
  }

  Future<void> removeFavoriteContact(String id) async {
    _favoriteContacts.removeWhere((c) => c.id == id);
    await _persistFavoriteContacts();
    notifyListeners();
  }

  Future<void> _persistFavoriteContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _favoriteContacts.map((c) => c.toJson()).toList();
    await prefs.setStringList('favorite_contacts', jsonList);
  }

  Future<void> _loadFavoriteContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('favorite_contacts');
    if (jsonList != null) {
      _favoriteContacts =
          jsonList.map((s) => FavoriteContact.fromJson(s)).toList();
    }
  }

  // ── Balance History (last 7 data points) ──

  Future<void> _recordBalanceHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList('balance_history') ?? [];
    _balanceHistory = existing.map((s) => double.tryParse(s) ?? 0.0).toList();

    // Add current balance if different from last recorded
    if (_balanceHistory.isEmpty || _balanceHistory.last != _balance) {
      _balanceHistory.add(_balance);
    }

    // Keep only the last 7 entries
    if (_balanceHistory.length > 7) {
      _balanceHistory =
          _balanceHistory.sublist(_balanceHistory.length - 7);
    }

    await prefs.setStringList(
      'balance_history',
      _balanceHistory.map((b) => b.toString()).toList(),
    );
  }

  // ── Last Login Time ──

  Future<void> recordLogin() async {
    _lastLoginTime = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_login_time', _lastLoginTime!.toIso8601String());
  }

  Future<void> _loadLastLoginTime() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('last_login_time');
    if (stored != null) {
      _lastLoginTime = DateTime.parse(stored);
    }
  }
}
