import 'package:dating_app/providers/api_service.dart';
import 'package:dating_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MatchProvider with ChangeNotifier {
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';

  Future<bool> match(
      String userId, String matchedUserId, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.userModel?.token;

    try {
      isLoading = true;
      errorMessage = ''; // Clear previous errors
      notifyListeners();

      final response = await APIService.instance.request(
        '/matches/$userId/$matchedUserId', // enter the endpoint for required API call
        DioMethod.post,
        contentType: 'application/json',
        token: token,
      );

      if (response.statusCode == 201) {
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
