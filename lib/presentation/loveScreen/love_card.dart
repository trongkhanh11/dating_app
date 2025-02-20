import 'package:dating_app/models/profile_model.dart';
import 'package:dating_app/presentation/loveScreen/profile_screen.dart';
import 'package:flutter/material.dart';

class LoveCard extends StatelessWidget {
  final Profile profile;

  LoveCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileScreen(profile: profile)),
              );
            },
            child: ListTile(
              contentPadding: EdgeInsets.all(15),
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage("https://avatar.iran.liara.run/public/41"),
                radius: 30,
              ),
              title: Text(
                profile.displayName,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              subtitle: Text("${profile.age} tuổi",
                  style: TextStyle(color: Colors.grey[700])),
              trailing: Icon(Icons.favorite, color: Colors.red, size: 28),
            ),
          ),
        ),
      ),
    );
  }
}
