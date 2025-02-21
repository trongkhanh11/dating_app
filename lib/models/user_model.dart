class ListUser {
  List<User>? users;

  ListUser({this.users});

  factory ListUser.fromJson(Map<String, dynamic> json) {
    return ListUser(
      users: json["data"] != null
          ? List<User>.from(json["data"].map((x) => User.fromJson(x)))
          : [],
    );
  }
}

class UserModel {
  final User user;
  final String token;

  UserModel({
    required this.user,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      user: User.fromJson(json['user']),
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
    };
  }
}

class User {
  final String id;
  final String? email;
  final String firstName;
  final String lastName;
  final Role? role;
  final String? createdAt;
  final String? updatedAt;

  User({
    required this.id,
    this.email,
    required this.firstName,
    required this.lastName,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      role: json['role'] != null ? Role.fromJson(json['role']) : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
    };
  }
}

class Role {
  final int id;
  final String name;

  Role({
    required this.id,
    required this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
    );
  }
}

class RegisterModel {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  RegisterModel({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}

class UserInChat {
  final String id;
  final int age;
  final String displayName;
  final String? image;

  UserInChat({
    required this.id,
    required this.age,
    required this.displayName,
    this.image,
  });

  factory UserInChat.fromJson(Map<String, dynamic> json) {
    return UserInChat(
      id: json['id'],
      age: json['age'],
      displayName: json['displayName'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'age': age,
      'displayName': displayName,
      'image': image,
    };
  }
}
