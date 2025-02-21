import 'package:dating_app/models/conversation_model.dart';
import 'package:dating_app/providers/api_service.dart';
import 'package:dating_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConversationProvider with ChangeNotifier {
  bool isLoading = false;
  bool hasError = false;
  ListConversation? _listConversation;
  ListMessage? _listMessage;
  String errorMessage = '';

  ListConversation? get listConversation => _listConversation;
  ListMessage? get listMessage => _listMessage;

  Future<void> getListConversation(String userId, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.userModel?.token;

    try {
      isLoading = true;
      errorMessage = ''; // Clear previous errors
      notifyListeners();

      final response = await APIService.instance.request(
        '/conversations', // enter the endpoint for required API call
        DioMethod.get,
        contentType: 'application/json',
        token: token,
        param: {'userId': userId},
      );

      if (response.statusCode == 200) {
        _listConversation = ListConversation.fromJson(response.data);
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

  Future<void> getMessages(
      String user1Id, String user2Id, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.userModel?.token;

    try {
      isLoading = true;
      errorMessage = ''; // Clear previous errors
      notifyListeners();

      final response = await APIService.instance.request(
          '/messages', // enter the endpoint for required API call
          DioMethod.get,
          contentType: 'application/json',
          token: token,
          param: {
            'user1Id': user1Id,
            'user2Id': user2Id,
          });

      if (response.statusCode == 200) {
        _listMessage = ListMessage.fromJson(response.data);
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

  Future<bool> sendMessage(SendMessageModel model, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.userModel?.token;

    try {
      isLoading = true;
      errorMessage = ''; // Clear previous errors
      notifyListeners();

      final response = await APIService.instance.request(
        '/messages', // enter the endpoint for required API call
        DioMethod.post,
        contentType: 'application/json',
        token: token,
        param: model.toJson(),
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
