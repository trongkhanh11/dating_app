import 'package:dating_app/models/profile_model.dart';
import 'package:dating_app/providers/api_service.dart';
import 'package:dating_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscoveryProvider with ChangeNotifier {
  bool isLoading = false;
  bool hasError = false;
  ListProfile? listProfile;
  String errorMessage = '';

  Future<void> discovery(
      List<int> ageRange, int distanceRange, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.userModel?.token;

    try {
      isLoading = true;
      errorMessage = ''; // Clear previous errors
      notifyListeners();

      final response = await APIService.instance.request(
        '/discovery/search', // enter the endpoint for required API call
        DioMethod.get,
        contentType: 'application/json',
        token: token,
        param: {
          'ageRange': ageRange,
          'distanceRange': distanceRange,
        },
      );
      if (response.statusCode == 200) {
        listProfile = ListProfile.fromJson(response.data);
        notifyListeners();
      } else {
        debugPrint('API call failed: ${response.statusMessage}');
      }
    } catch (e) {
      debugPrint('Network error occurred: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearData() {
    isLoading = false;
    listProfile = null;
    notifyListeners();
  }
}
