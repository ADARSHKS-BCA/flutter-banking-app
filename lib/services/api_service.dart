import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart';

class ApiService {
  // ---------------------------------------------------------------------------
  // CHANGE THIS URL BASED ON YOUR DEVICE:
  // 1. Web / iOS Simulator:       'http://127.0.0.1:8000/api'
  // 2. Android Emulator:          'http://10.0.2.2:8000/api'
  // 3. Physical Device (Phone):   'http://YOUR_PC_IP_ADDRESS:8000/api' (e.g. 192.168.1.5)
  // ---------------------------------------------------------------------------
  
  static String get baseUrl {
    // Production URL (Render)
    return 'https://flutter-banking-app.onrender.com/api';

    /* 
    // Local Development
    if (kIsWeb) {
      return 'http://127.0.0.1:8000/api';
    }
    return 'http://10.0.2.2:8000/api'; // Android Emulator
    */
  } 
  
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;

  Future<String?> getToken() async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token;
  }

  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Auth Headers
  Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // --- Auth Endpoints ---

  Future<bool> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    return response.statusCode == 201;
  }

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await setToken(data['access']);
      return true;
    }
    return false;
  }

  // --- Bank Endpoints ---

  Future<Map<String, dynamic>?> getAccount() async {
    final response = await http.get(
      Uri.parse('$baseUrl/account/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  Future<List<dynamic>> getTransactions() async {
    final response = await http.get(
      Uri.parse('$baseUrl/transactions/'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  Future<bool> deposit(double amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/account/deposit/'),
      headers: await _getHeaders(),
      body: jsonEncode({'amount': amount}),
    );
    return response.statusCode == 200;
  }

  Future<bool> withdraw(double amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/account/withdraw/'),
      headers: await _getHeaders(),
      body: jsonEncode({'amount': amount}),
    );
    return response.statusCode == 200;
  }

  Future<bool> transfer(String recipientUsername, double amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/account/transfer/'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'recipient_username': recipientUsername,
        'amount': amount
      }),
    );
    return response.statusCode == 200;
  }
}
