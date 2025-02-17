import 'package:dating_app/models/profile_model.dart';
import 'package:dating_app/providers/api_service.dart';
import 'package:dating_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileProvider with ChangeNotifier {
  bool isLoading = false;
  bool hasError = false;
  Profile? _profile;
  String errorMessage = '';

  Profile? get profile => _profile;

  Future<bool> createProfile(
      CreateProfileModel model, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.userModel?.token;

    try {
      errorMessage = '';
      isLoading = true;
      notifyListeners();

      final response = await APIService.instance.request(
        '/profiles', // enter the endpoint for required API call
        DioMethod.post,
        param: model.toJson(),
        contentType: 'application/json',
        token: token,
      );

      if (response.statusCode == 201) {
        debugPrint('Profile created successfully');
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

  Future<bool> getUserProfile(String userId, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.userModel?.token;

    try {
      isLoading = true;
      errorMessage = ''; // Clear previous errors
      notifyListeners();

      final response = await APIService.instance.request(
          '/profiles/user/$userId', // enter the endpoint for required API call
          DioMethod.get,
          contentType: 'application/json',
          token: token);

      if (response.statusCode == 200) {
        _profile = Profile.fromJson(response.data);
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

  void clearData() {
    isLoading = false;
    notifyListeners();
  }
}
