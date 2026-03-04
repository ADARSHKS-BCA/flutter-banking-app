import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();
  User? _currentUser;
  bool _isLoggedIn = false;
  DateTime? _loginTime;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  DateTime? get loginTime => _loginTime;

  Future<void> checkLoginStatus() async {
    final token = await _apiService.getToken();
    _isLoggedIn = token != null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final success = await _apiService.login(email, password);
    
    if (success) {
      _isLoggedIn = true;
      _loginTime = DateTime.now();
      _currentUser = User(name: email, email: email, phone: '', password: '');
      notifyListeners();
      return true;
    }
    
    return false;
  }

  Future<void> signUp(User user, {String? username}) async {
    final registrationUsername = username ?? user.name;
    await _apiService.register(registrationUsername, user.email, user.password);
  }

  Future<void> logout() async {
    await _apiService.clearToken();
    _isLoggedIn = false;
    _currentUser = null;
    _loginTime = null;
    notifyListeners();
  }
}
