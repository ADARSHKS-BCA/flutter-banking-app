import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService(); // Keep for other settings if needed
  User? _currentUser;
  bool _isLoggedIn = false;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkLoginStatus() async {
    final token = await _apiService.getToken();
    _isLoggedIn = token != null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    // We treat 'email' as 'username' for the backend
    final success = await _apiService.login(email, password);
    
    if (success) {
      _isLoggedIn = true;
      // create a temporary user object since API doesn't return full profile yet
      _currentUser = User(name: email, email: email, phone: '', password: '');
      notifyListeners();
      return true;
    }
    
    return false;
  }

  Future<void> signUp(User user) async {
    await _apiService.register(user.name, user.email, user.password);
    // After signup, user usually needs to login. 
  }

  Future<void> logout() async {
    await _apiService.clearToken();
    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();
  }
}
