import 'package:dating_app/widgets/cities_selection.dart';
import 'package:dating_app/widgets/gender_selection.dart';
import 'package:dating_app/widgets/image_picker_box.dart';
import 'package:dating_app/widgets/interests_selection.dart';
import 'package:dating_app/widgets/sexualOrientation_selection.dart';
import 'package:flutter/material.dart';

class PersonalProfileScreen extends StatefulWidget {
  const PersonalProfileScreen({super.key});

  @override
  State<PersonalProfileScreen> createState() => _PersonalProfileScreenState();
}

class _PersonalProfileScreenState extends State<PersonalProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                // backgroundImage: AssetImage(
                //     'assets/avatar.png'), // Thay thế bằng NetworkImage nếu có URL
              ),
              SizedBox(height: 16),
              Text(
                'Your Name',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '18 years old',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Container(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'PHOTOS AND VIDEOS',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Pick some that show the true you.",
                  )),
              Container(padding: EdgeInsets.all(8), child: MultiImagePicker()),
              SizedBox(height: 16),
              Container(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'SAY SOMETHING ABOUT YOURSELF',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Write a fun and punchy intro.",
                  )),
              Container(
                color: Colors.white,
                child: TextField(
                  maxLength: 500,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'INTERESTS',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Get specific about the things you love.",
                  )),
              Container(color: Colors.white, child: InterestsSelection()),
              SizedBox(height: 16),
              Container(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'GENDER',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              Container(
                color: Colors.white,
                child: GenderSelection(),
              ),
              SizedBox(height: 16),
              Container(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'SEXSUAL ORIENTATION',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              Container(
                color: Colors.white,
                child: SexualOrientationSelection(),
              ),
              SizedBox(height: 16),
              Container(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'LOCATION',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              Container(
                color: Colors.white,
                child: CityDropdownField(),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Thêm logic cập nhật thông tin ở đây
                },
                child: Text('Edit Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
