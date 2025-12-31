import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  User? _currentUser;
  bool _isLoggedIn = false;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkLoginStatus() async {
    _isLoggedIn = await _storageService.getLoginState();
    if (_isLoggedIn) {
      _currentUser = await _storageService.getUser();
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    // In a real app, this would verify against a backend.
    // For this demo, we'll check against the stored user or allow a "demo" login if no user exists yet
    // BUT the requirement says "Sign-Up Page... Automatically redirect to login".
    // So we should expect a stored user.
    
    final storedUser = await _storageService.getUser();
    
    if (storedUser != null && storedUser.email == email && storedUser.password == password) {
      _currentUser = storedUser;
      _isLoggedIn = true;
      await _storageService.saveLoginState(true);
      notifyListeners();
      return true;
    }
    
    return false;
  }

  Future<void> signUp(User user) async {
    await _storageService.saveUser(user);
    // Auto login after signup? Requirements say "Automatically redirect to login".
    // So we just save the user.
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _currentUser = null;
    await _storageService.saveLoginState(false);
    notifyListeners();
  }
}
