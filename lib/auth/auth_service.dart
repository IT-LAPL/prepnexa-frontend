import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  static const String _baseUrl = 'https://prepnexa-api.stpindia.org';
  // change to http://localhost:8000 for local dev

  String? accessToken = 'demo-token-abc123';
  String? email;
  String? name;
  bool isLoggedIn = false;

  /// ---------------- SIGN UP ----------------
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/users/');

    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (res.statusCode == 201) {
      // auto-login after signup
      return await signIn(email: email, password: password);
    } else {
      debugPrint('Signup failed: ${res.body}');
      return false;
    }
  }

  /// ---------------- SIGN IN ----------------
  Future<bool> signIn({required String email, required String password}) async {
    final url = Uri.parse('$_baseUrl/users/login');

    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      accessToken = data['access_token'];
      this.email = email;
      isLoggedIn = true;
      return true;
    } else {
      debugPrint('Login failed: ${res.body}');
      return false;
    }
  }

  /// ---------------- LOGOUT ----------------
  void logout() {
    accessToken = null;
    email = null;
    isLoggedIn = false;
  }

  /// ---------------- AUTH HEADER ----------------
  Map<String, String> authHeader() {
    return {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
  }
}
