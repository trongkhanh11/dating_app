import 'package:dating_app/models/profile_model.dart';
import 'package:dating_app/providers/api_service.dart';
import 'package:dating_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreferencesProvider extends ChangeNotifier {
  bool isLoading = false;
  bool hasError = false;
  Preferences? _preferences;
  String errorMessage = '';

  Preferences? get preferences => _preferences;

  Future<bool> createUserPreferences(
      Preferences model, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.userModel?.token;

    try {
      errorMessage = '';
      isLoading = true;
      notifyListeners();

      final response = await APIService.instance.request(
        '/users/preferences', // enter the endpoint for required API call
        DioMethod.post,
        param: model.toJson(),
        contentType: 'application/json',
        token: token,
      );

      if (response.statusCode == 201) {
        debugPrint('User Preferences created successfully');
        return true;
      } else {
        debugPrint('API call failed: ${response.statusMessage}');
        return false;
      }
    } catch (e) {
      debugPrint('Network error occurred: $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateUserPreferences(String id,
      Map<String, dynamic> updatedField, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.userModel?.token;
    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();
      final response = await APIService.instance.request(
        '/users/preferences/$id',
        DioMethod.patch,
        param: updatedField,
        contentType: 'application/json',
        token: token,
      );
      if (response.statusCode == 200) {
        debugPrint('User Preferences Updated successfully');
        return true;
      } else {
        debugPrint('API call failed: ${response.statusMessage}');
        return false;
      }
    } catch (e) {
      debugPrint('Network error occurred: $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> getUserPreferences(String userId, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.userModel?.token;

    try {
      isLoading = true;
      errorMessage = '';
      notifyListeners();

      final response = await APIService.instance.request(
          '/users/preferences/user/$userId', // enter the endpoint for required API call
          DioMethod.get,
          contentType: 'application/json',
          token: token);
      if (response.statusCode == 200) {
        _preferences = Preferences.fromJson(response.data);
        notifyListeners();
        return true;
      } else {
        debugPrint('API call failed: ${response.statusMessage}');
        return false;
      }
    } catch (e) {
      debugPrint('Network error occurred: $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
