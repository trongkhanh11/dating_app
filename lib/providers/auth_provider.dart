import 'package:dating_app/models/profile_model.dart';
import 'package:dating_app/models/user_model.dart';
import 'package:dating_app/providers/profile_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dating_app/providers/api_service.dart';

class AuthProvider with ChangeNotifier {
  bool isLoading = false;
  bool isLoggingOut = false;
  bool hasError = false;
  UserModel? _userModel;
  Profile? _profile;
  String errorMessage = '';

  UserModel? get userModel => _userModel;
  Profile? get profile => _profile;

  Future<bool> login(String email, String password) async {
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      final response = await APIService.instance.request(
        '/auth/email/login', // enter the endpoint for required API call
        DioMethod.post,
        param: {'email': email, 'password': password},
        contentType: 'application/json',
      );

      if (response.statusCode == 200) {
        _userModel = UserModel.fromJson(response.data);
        notifyListeners();
        return true;
      } else {
        debugPrint('API call failed: ${response.statusMessage}');
        return false;
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 422) {
          errorMessage = "Invalid login credentials. Please try again.";
        } else {
          errorMessage = "An error occurred. Please try again later.";
        }
      } else {
        errorMessage = "An error occurred. Please try again later.";
      }
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(RegisterModel model, BuildContext context) async {
    try {
      final response = await APIService.instance.request(
        '/auth/email/register', // enter the endpoint for required API call
        DioMethod.post,
        param: model.toJson(),
        contentType: 'application/json',
      );

      if (response.statusCode == 201) {
        notifyListeners();
        return true;
      } else {
        debugPrint('API call failed: ${response.statusMessage}');
        return false;
      }
    } catch (e) {
      errorMessage = "An error occurred. Please try again later.";
      return false;
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      isLoggingOut = true;
      _userModel = null;
      _profile = null;
      errorMessage = '';
      notifyListeners();
      // ignore: use_build_context_synchronously
      Provider.of<ProfileProvider>(context, listen: false).clearData();
    } catch (e) {
      // ignore: use_build_context_synchronously
      debugPrint('Network error occurred: $e');
    } finally {
      isLoggingOut = false;
      isLoading = false;
      errorMessage = '';
      notifyListeners();
    }
    // ignore: use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
