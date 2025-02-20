import 'package:dating_app/models/interaction_model.dart';
import 'package:dating_app/providers/api_service.dart';
import 'package:dating_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InteractionProvider with ChangeNotifier {
  bool isLoading = false;
  bool hasError = false;
  Interaction? _interaction;
  InteractionLike? _interactionLike;
  String errorMessage = '';

  Interaction? get interaction => _interaction;
  InteractionLike? get interactionLike => _interactionLike;

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

  Future<void> getRecievedLikes(String userId, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.userModel?.token;

    try {
      isLoading = true;
      errorMessage = ''; // Clear previous errors
      notifyListeners();

      final response = await APIService.instance.request(
        '/interactions/received-likes/$userId', // enter the endpoint for required API call
        DioMethod.get,
        contentType: 'application/json',
        token: token,
      );

      if (response.statusCode == 200) {
        _interactionLike = InteractionLike.fromJson(response.data);

        print('✅ Total Likes: ${_interactionLike?.totalItems}');
        print('✅ Parsed Data: ${_interactionLike?.data}');
        notifyListeners();
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
    _interaction = null;
    notifyListeners();
  }
}
