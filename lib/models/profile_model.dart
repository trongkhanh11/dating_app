import 'package:dating_app/models/user_model.dart';

class Profile {
  final String id;
  final User user;
  final String displayName;
  final int age;
  final String gender;
  final String bio;
  final String location;
  final List<String>? files;
  final String createdAt;
  final String updatedAt;
  final bool isPublic;
  final String longitude;
  final String latitude;
  final List<String>? sexualOrientation;

  Profile({
    required this.id,
    required this.user,
    required this.displayName,
    required this.age,
    required this.gender,
    required this.bio,
    required this.location,
    this.files,
    required this.createdAt,
    required this.updatedAt,
    required this.isPublic,
    required this.longitude,
    required this.latitude,
    required this.sexualOrientation,
  });

  // Factory constructor to create Profile from JSON
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      user: User.fromJson(json['user']),
      displayName: json['displayName'],
      age: json['age'],
      gender: json['gender'],
      bio: json['bio'],
      location: json['location'],
      files: (json['imageUrls'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      isPublic: json['isPublic'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      sexualOrientation: (json['sexualOrientation'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
    );
  }
}

class CreateProfileModel {
  final String userId;
  final String displayName;
  final bool isPublic;
  final int age;
  final String gender;
  final List<String> sexualOrientation;
  final String bio;
  final List<String> interests;
  final String location;
  final double longitude;
  final double latitude;

  CreateProfileModel({
    required this.userId,
    required this.displayName,
    required this.isPublic,
    required this.age,
    required this.gender,
    required this.sexualOrientation,
    required this.bio,
    required this.interests,
    required this.location,
    required this.longitude,
    required this.latitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
      'isPublic': isPublic,
      'age': age,
      'gender': gender,
      'sexualOrientation': sexualOrientation,
      'bio': bio,
      'interests': interests,
      'location': location,
      'longitude': longitude,
      'latitude': latitude,
    };
  }
}
