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
  String? _userId;
  Future<bool> login(String email, String password) async {
    try {
      final response = await APIService.instance.request(
          '/api/v1/auth/email/login', // enter the endpoint for required API call
          DioMethod.post,
          param: {'email': email, 'password': password},
          contentType: 'application/json',
          token: '');

      if (response.statusCode == 200) {
        String token = response.data['token'];
        _usertoken = token;
        debugPrint('_usertoken: ${_usertoken}');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        final data = response.data;
        _userId = data['user']?['id'];
        notifyListeners();
        return true;
      } else {
        debugPrint('API call failed: ${response.statusMessage}');
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Network error occurred: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(
      String email, String password, String firstName, String lastName) async {
    try {
      final response = await APIService.instance.request(
          '/api/v1/auth/email/register', // enter the endpoint for required API call
          DioMethod.post,
          param: {
            'email': email,
            'password': password,
            'firstName': firstName,
            'lastName': lastName,
          },
          contentType: 'application/json',
          token: '');

      if (response.statusCode == 201) {
        // Kiểm tra nếu response.data có chứa userId
        if (response.data['data'] == null ||
            response.data['data']['userId'] == null) {
          debugPrint("Error: API response does not contain userId");
          return false;
        }

        String userId = response.data['data']['userId'];
        debugPrint('Registered userId: $userId');

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);
        notifyListeners();

        return true;
      } else {
        debugPrint('API call failed: ${response.statusMessage}');
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Network error occurred: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> checkUserProfile(String userId) async{
    try {
      final response = await APIService.instance.request(
          '/api/v1/profiles/user/$userId', // enter the endpoint for required API call
          DioMethod.get,
          contentType: 'application/json',
          token: _usertoken);

      if (response.statusCode == 200) {
        
        return true;
      } else {
        debugPrint('API call failed: ${response.statusMessage}');
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Network error occurred: $e');
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _usertoken = null;
    notifyListeners();
  }

  String? getUserId() {
    return _userId;
  }
}
