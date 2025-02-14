import 'package:dating_app/providers/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  bool get isAuthenticated => _usertoken != null;
  String? _usertoken;
  bool isLoading = false;
  bool hasError = false;

  // Thông tin profile
  String? userId;
  String? displayName;
  bool? isPublic;
  int? age;
  String? gender;
  String? sexualOrientation;
  String? bio;
  List<String> interests = [];
  String? location;
  double? latitude;
  double? longitude;
  String? avatarUrl;

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

  Future<bool> getProfileByUserId(String userId) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await APIService.instance.request(
        '/api/v1/profiles/$userId', // Endpoint để lấy profile
        DioMethod.get,
        token: _usertoken,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        this.userId = data['userId'];
        displayName = data['displayName'];
        isPublic = data['isPublic'];
        age = data['age'];
        gender = data['gender'];
        sexualOrientation = data['sexualOrientation'];
        bio = data['bio'];
        location = data['location'];
        latitude = data['latitude'];
        longitude = data['longitude'];
        avatarUrl = data['avatarUrl'];
        interests = List<String>.from(data['interests'] ?? []);

        isLoading = false;
        hasError = false;
        notifyListeners();
        return true;
      } else {
        debugPrint('API call failed: ${response.statusMessage}');
        hasError = true;
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Network error occurred: $e');
      hasError = true;
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
