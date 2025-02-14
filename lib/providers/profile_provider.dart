import 'package:dating_app/providers/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  bool get isAuthenticated => _usertoken != null;
  String? _usertoken;
  bool isLoading = false;
  bool hasError = false;
  
   Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _usertoken = prefs.getString("token");
    notifyListeners();
  }

  Future<bool> createProfile(
      String userId,
      String displayName,
      bool isPublic,
      int age,
      String gender,
      String sexualOrientation,
      String bio,
      List<String> interests,
      String location,
      double latitude,
      double longitude) async {
    try {
      final response = await APIService.instance.request(
          '/api/v1/profiles', // enter the endpoint for required API call
          DioMethod.post,
          param: {
            "userId": userId,
            "displayName": displayName,
            "isPublic": isPublic,
            "age": age,
            "gender": gender,
            "sexualOrientation": sexualOrientation,
            "bio": bio,
            "location": location,
            "latitude": latitude,
            "longitude": longitude,
            "interests": interests,
          },
          contentType: 'application/json',
          token: _usertoken);

      if (response.statusCode == 201) {
        debugPrint('Profile created successfully');
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
}
