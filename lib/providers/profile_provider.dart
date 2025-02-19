import 'dart:io';

import 'package:dating_app/models/profile_model.dart';
import 'package:dating_app/providers/api_service.dart';
import 'package:dating_app/providers/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
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

  Future<List<String>?> uploadPhotos(
      String userId, List<File?> images, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.userModel?.token;

    try {
      isLoading = true;
      errorMessage = ''; // Clear previous errors
      notifyListeners();

      // Duyệt qua danh sách ảnh đã chọn (_images)
      List<MultipartFile> imageFiles = await Future.wait(
        images.where((image) => image != null).map(
              (image) => MultipartFile.fromFile(image!.path,
                  filename: basename(image.path)),
            ),
      );

      FormData formData = FormData.fromMap({
        "photos": imageFiles,
      });

      final response = await APIService.instance.request(
          '/profiles/$userId/upload-photos', DioMethod.post,
          formData: formData, token: token);

      if (response.statusCode == 200) {
        List<String> imageIds = List<String>.from(response.data);
        print("Ảnh đã tải lên thành công!");
        debugPrint('API call Success: ${response.statusMessage}');
        return imageIds;
      } else {
        errorMessage = "Lỗi tải ảnh lên server!";
        debugPrint('API call failed: ${response.statusMessage}');
        return null;
      }
    } catch (e) {
      errorMessage = "Lỗi: ${e.toString()}";

      debugPrint('Network error occurred: $e');
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List? _images;
  List? get images => _images;

  Future<void> getProfilePhotos(
      List<String> fileIds, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.userModel?.token;

    try {
      errorMessage = '';
      isLoading = true;
      notifyListeners();

      final response = await APIService.instance.request(
        '/profiles/photos', // enter the endpoint for required API call
        DioMethod.post,
        param: {'fileIds': fileIds},
        contentType: 'application/json',
        token: token,
      );

      if (response.statusCode == 201) {
        _images = response.data['images'];
        debugPrint('Get photos created successfully');
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
    notifyListeners();
  }
}
