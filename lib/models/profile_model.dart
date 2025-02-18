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
  final List<String> sexualOrientation;

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
      latitude: json['latitude'],
      longitude: json['longitude'],
      sexualOrientation: List<String>.from(json['sexualOrientation']),
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
  final String location;

  final double latitude;
  final double longitude;
  CreateProfileModel({
    required this.userId,
    required this.displayName,
    required this.isPublic,
    required this.age,
    required this.gender,
    required this.sexualOrientation,
    required this.bio,
    required this.location,
    required this.latitude,
    required this.longitude,
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
      'location': location,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    };
  }
}

class UpdateProfileModel {
  final String firstName;
  final String lastName;
  final String birthday;

  UpdateProfileModel({
    required this.firstName,
    required this.lastName,
    required this.birthday,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'birthday': birthday,
    };
  }
}

class Preferences {
  final String userId;
  List<String> hobbies;
  List<String> lookingFor;
  List<String>? languages;
  List<String>? zodiacSigns;
  List<String>? education;
  List<String>? futureFamily;
  List<String>? personalityTypes;
  List<String>? communicationStyles;
  List<String>? petPreferences;
  List<String>? drinking;
  List<String>? smoking;
  List<String>? exercise;
  List<String>? diet;
  List<String>? socialMedia;
  List<String>? sleepHabits;

  Preferences({
    required this.userId,
    required this.hobbies,
    required this.lookingFor,
    this.languages,
    this.zodiacSigns,
    this.education,
    this.futureFamily,
    this.personalityTypes,
    this.communicationStyles,
    this.petPreferences,
    this.drinking,
    this.smoking,
    this.exercise,
    this.diet,
    this.socialMedia,
    this.sleepHabits,
  });

  /// Chuyển đổi từ JSON sang object Preferences
  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      userId: json['userId'] ?? '',
      hobbies: List<String>.from(json['hobbies'] ?? []),
      lookingFor: List<String>.from(json['lookingFor'] ?? []),
      languages: json['languages'] != null
          ? List<String>.from(json['languages'])
          : null,
      zodiacSigns: json['zodiacSigns'] != null
          ? List<String>.from(json['zodiacSigns'])
          : null,
      education: json['education'] != null
          ? List<String>.from(json['education'])
          : null,
      futureFamily: json['futureFamily'] != null
          ? List<String>.from(json['futureFamily'])
          : null,
      personalityTypes: json['personalityTypes'] != null
          ? List<String>.from(json['personalityTypes'])
          : null,
      communicationStyles: json['communicationStyles'] != null
          ? List<String>.from(json['communicationStyles'])
          : null,
      petPreferences: json['petPreferences'] != null
          ? List<String>.from(json['petPreferences'])
          : null,
      drinking:
          json['drinking'] != null ? List<String>.from(json['drinking']) : null,
      smoking:
          json['smoking'] != null ? List<String>.from(json['smoking']) : null,
      exercise:
          json['exercise'] != null ? List<String>.from(json['exercise']) : null,
      diet: json['diet'] != null ? List<String>.from(json['diet']) : null,
      socialMedia: json['socialMedia'] != null
          ? List<String>.from(json['socialMedia'])
          : null,
      sleepHabits: json['sleepHabits'] != null
          ? List<String>.from(json['sleepHabits'])
          : null,
    );
  }

  /// Chuyển đổi từ object Preferences sang JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'hobbies': hobbies,
      'lookingFor': lookingFor,
      'languages': languages ?? [],
      'zodiacSigns': zodiacSigns ?? [],
      'education': education ?? [],
      'futureFamily': futureFamily ?? [],
      'personalityTypes': personalityTypes ?? [],
      'communicationStyles': communicationStyles ?? [],
      'petPreferences': petPreferences ?? [],
      'drinking': drinking ?? [],
      'smoking': smoking ?? [],
      'exercise': exercise ?? [],
      'diet': diet ?? [],
      'socialMedia': socialMedia ?? [],
      'sleepHabits': sleepHabits ?? [],
    };
  }
}
