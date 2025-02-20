import 'package:dating_app/models/interaction_model.dart';
import 'package:dating_app/providers/api_service.dart';
import 'package:dating_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InteractionProvider with ChangeNotifier {
  bool isLoading = false;
  bool hasError = false;
  Interaction? _interaction;
  String errorMessage = '';

  Interaction? get interaction => _interaction;

  Future<void> interact(InteractModel interaction, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.userModel?.token;

    try {
      isLoading = true;
      errorMessage = ''; // Clear previous errors
      notifyListeners();

      final response = await APIService.instance.request(
        '/interactions', // enter the endpoint for required API call
        DioMethod.post,
        contentType: 'application/json',
        token: token,
        param: interaction.toJson(),
      );

      if (response.statusCode == 200) {
        _interaction = Interaction.fromJson(response.data);
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

  Future<bool> checkMatch(
      String userId1, String userId2, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.userModel?.token;

    try {
      isLoading = true;
      errorMessage = ''; // Clear previous errors
      notifyListeners();

      final response = await APIService.instance.request(
        '/interactions/match/$userId1/$userId2', // enter the endpoint for required API call
        DioMethod.post,
        contentType: 'application/json',
        token: token,
      );

      if (response.statusCode == 200) {
        notifyListeners();
        return response.data;
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
    _interaction = null;
    notifyListeners();
  }
}
