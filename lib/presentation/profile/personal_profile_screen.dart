import 'package:dating_app/presentation/authentication/login/login_screen.dart';
import 'package:dating_app/providers/auth_provider.dart';
import 'package:dating_app/providers/profile_provider.dart';
import 'package:dating_app/widgets/cities_selection.dart';
import 'package:dating_app/widgets/gender_selection.dart';
import 'package:dating_app/widgets/image_picker_box.dart';
import 'package:dating_app/widgets/interests_selection.dart';
import 'package:dating_app/widgets/looking_for_selection.dart';
import 'package:dating_app/widgets/sexualOrientation_selection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalProfileScreen extends StatefulWidget {
  const PersonalProfileScreen({super.key});

  @override
  State<PersonalProfileScreen> createState() => _PersonalProfileScreenState();
}

class _PersonalProfileScreenState extends State<PersonalProfileScreen> {
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController avatarUrlController = TextEditingController();

  bool isPublic = true;
  String? selectedGender;
  String? selectedType;
  String? selectedCity;
  List<String> interests = [];
  List<String> lookingFor= [];
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    await profileProvider.loadToken();
    await profileProvider.getProfileByUserId(userId!);
    setState(() {
      //displayNameController.text = profileProvider.displayName ?? "";
      //ageController.text = profileProvider.age.toString();
      bioController.text = profileProvider.bio ?? "";
      latitudeController.text = profileProvider.latitude.toString();
      longitudeController.text = profileProvider.longitude.toString();
      avatarUrlController.text = profileProvider.avatarUrl ?? "";
      isPublic = profileProvider.isPublic ?? true;
      selectedGender = profileProvider.gender;
      selectedType = profileProvider.sexualOrientation;
      selectedCity = profileProvider.location;
      interests = profileProvider.interests;
    });
  }

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
      body: Consumer<ProfileProvider>(
          builder: (context, profileProvider, Widget? child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Avatar
                CircleAvatar(
                  radius: 50,
                  // backgroundImage: AssetImage(
                  //     'assets/avatar.png'), // Thay thế bằng NetworkImage nếu có URL
                ),
                SizedBox(height: 16),
                //Name
                Text(
                  profileProvider.displayName ?? "Your Name",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                //Age
                Text(
                  '${profileProvider.age} years old',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                //Photo & Video
                Container(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'PHOTOS AND VIDEOS',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                Container(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Pick some that show the true you.",
                    )),
                Container(
                    padding: EdgeInsets.all(8), child: MultiImagePicker()),
                SizedBox(height: 16),
                //Bio
                Container(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'SAY SOMETHING ABOUT YOURSELF',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                    controller: bioController,
                    maxLength: 500,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                //Interests Box
                Container(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'INTERESTS',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                Container(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Get specific about the things you love.",
                    )),
                Container(
                  color: Colors.white,
                  height: 70,
                  child: InterestsSelection(
                    interests: interests,
                    onChanged: (newInterests) {
                      profileProvider.interests = newInterests;
                    },
                  ),
                ),
                SizedBox(height: 16),
                //Dating Purpose
                Container(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'DATING PURPOSE',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                Container(
                  color: Colors.white,
                  height: 70,
                  child: LookingForSelection(
                    // initialSelection: lookingFor.isNotEmpty ? lookingFor.first : null,
                    // onChanged: (newInterests) {
                    //   //profileProvider.interests = newInterests;
                    // },
                  ),
                ),
                SizedBox(height: 16,),
                //Gender selection
                Container(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'GENDER',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                Container(
                  color: Colors.white,
                  child: GenderSelection(
                    initialGender: selectedGender,
                    onChanged: (newGender) {
                      setState(() {
                        selectedGender = newGender;
                      });
                      profileProvider.gender = newGender;
                    },
                  ),
                ),
                SizedBox(height: 16),
                //Sexual Orientation selection
                Container(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'SEXSUAL ORIENTATION',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                Container(
                  color: Colors.white,
                  child: SexualOrientationSelection(
                      initialOrientation: selectedType,
                      onChanged: (newType) {
                        setState(() {
                          selectedType = newType;
                        });
                        profileProvider.sexualOrientation = newType;
                      }),
                ),
                SizedBox(height: 16),
                //Location
                Container(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'LOCATION',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                Container(
                  color: Colors.white,
                  child: CityDropdownField(
                      initialCity: selectedCity,
                      onChanged: (newCity) {
                        setState(() {
                          selectedCity = newCity;
                        });
                        profileProvider.location = newCity;
                      }),
                ),
                SizedBox(
                  height: 32,
                ),
                //Log Out
                SizedBox(
                  width: double.infinity,
                  child: Material(
                    color: Colors.white, // Để hiệu ứng gợn sóng hiển thị
                    child: InkWell(
                      onTap: () {
                        Provider.of<AuthProvider>(context, listen: false)
                            .logout();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      splashColor:
                          Colors.grey.withOpacity(0.3), // Màu hiệu ứng gợn sóng
                      highlightColor:
                          Colors.grey.withOpacity(0.1), // Màu nhấn giữ
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Log out",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16),
                //Button
                
              ],
            ),
          ),
        );
      }),
    );
  }
}
