import 'package:dating_app/presentation/loveScreen/love_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final User user;

  ProfileScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            backgroundImage: NetworkImage(user.imageUrl),
            radius: 60,
          ),
          SizedBox(height: 20),
          Text(
            "${user.name}, ${user.age} tuổi",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text("${user.distance} km", style: TextStyle(fontSize: 16, color: Colors.grey)),
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Đây là phần mô tả về ${user.name}. Bạn có thể thêm các thông tin khác tại đây!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Bạn đã match với ${user.name}! ❤️")),
              );
            },
            child: Text("Thích ❤️"),
          ),
        ],
      ),
    );
  }
}
