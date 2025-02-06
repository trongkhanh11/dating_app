// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dating_app/providers/api_service.dart';

class AuthProvider with ChangeNotifier {
  bool get isAuthenticated => _usertoken != null;
  String? _usertoken;
  bool isLoading = false;
  bool hasError = false;

  Future<void> login(String email, String password) async {
    try {
      final response = await APIService.instance.request(
          '/User/auth', // enter the endpoint for required API call
          DioMethod.post,
          param: {'userName': email, 'password': password},
          contentType: 'application/json',
          token: '');

      if (response.statusCode == 200) {
        String token = response.data['data']['token'];
        _usertoken = token;
        debugPrint('_usertoken: ${_usertoken}');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        notifyListeners();
      } else {
        debugPrint('API call failed: ${response.statusMessage}');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Network error occurred: $e');
      notifyListeners();
    }
  }

  void logout() {
    _usertoken = null;
    notifyListeners();
  }
}
