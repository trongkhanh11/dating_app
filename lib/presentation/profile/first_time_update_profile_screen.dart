import 'package:dating_app/models/profile_model.dart';
import 'package:dating_app/providers/auth_provider.dart';
import 'package:dating_app/providers/profile_provider.dart';
import 'package:dating_app/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirstTimeUpdateProfileScreen extends StatefulWidget {
  final String userId;
  const FirstTimeUpdateProfileScreen({super.key, required this.userId});

  @override
  State<FirstTimeUpdateProfileScreen> createState() =>
      _FirstTimeUpdateProfileScreenState();
}

class _FirstTimeUpdateProfileScreenState
    extends State<FirstTimeUpdateProfileScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController avatarUrlController = TextEditingController();

  bool isPublic = true;
  String? selectedGender;
  String? selectedOrientation;
  String? selectedCity;
  String? ageErrorMessage;
  List<String>? selectedLookingFor = [];
  List<String> interests = [];
  final List<String> interestOptions = [
    "Sports",
    "Music",
    "Travel",
    "Reading",
    "Gaming",
    "Cat",
    "Dog",
    "Animal",
    "Cafe",
    "Food",
    "Drink",
    "Smoke"
  ];
  final List<String> cities = [
    "Hanoi",
    "Ho Chi Minh City",
    "Da Nang",
    "Hai Phong",
    "Nha Trang",
    "Can Tho",
    "Hue",
    "Vung Tau"
  ];
  List<Map<String, String>> genderOptions = [
    {"label": "Male", "value": "male"},
    {"label": "Female", "value": "female"},
    {"label": "Other", "value": "other"},
  ];

  List<Map<String, String>> orientationOptions = [
    {"label": "Straight", "value": "straight"},
    {"label": "Gay", "value": "gay"},
    {"label": "Lesbian", "value": "lesbian"},
    {"label": "Bisexual", "value": "bisexual"},
    {"label": "Pansexual", "value": "pansexual"},
    {"label": "Asexual", "value": "asexual"},
    {"label": "Queer", "value": "queer"},
    {"label": "Questioning", "value": "questioning"},
    {"label": "Other", "value": "other"},
  ];

  List<Map<String, String>> relationshipPreferences = [
    {"label": "Lover", "value": "lover"},
    {"label": "Long-term Relationship", "value": "long_term"},
    {"label": "Anything is possible", "value": "any"},
    {"label": "Open Relationship", "value": "open"},
    {"label": "New friends", "value": "friends"},
    {"label": "I'm not so sure", "value": "other"},
  ];

  void _nextStep() {
    if (_currentStep < 8) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      _submitForm();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _submitForm() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    CreateProfileModel createProfileModel = CreateProfileModel(
      userId: widget.userId,
      displayName: displayNameController.text,
      isPublic: isPublic,
      age: int.tryParse(ageController.text) ?? 18,
      gender: selectedGender ?? "Other",
      sexualOrientation: selectedOrientation ?? "Both",
      bio: bioController.text,
      interests: interests,
      location: selectedCity ?? "Unknown",
      longitude: 10.810370781525451,
      latitude: 106.66743096751458,
    );

    bool success =
        await profileProvider.createProfile(createProfileModel, context);
    if (success) {
      debugPrint("User profile created successfully!");
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BottomBar(profile: profileProvider.profile)),
      );
    } else {
      debugPrint("Failed to create profile");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("")),
      body: Column(
        children: [
          LinearProgressIndicator(value: (_currentStep + 1) / 8),
          Expanded(
            child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildStepNickname(),
                  _buildStepAge(),
                  _buildStepGender(),
                  _buildStepOrientation(),
                  _buildStepLookingFor(),
                  _buildStepBio(),
                  _buildStepInterested(),
                  _buildStepLocation(),
                  _buildStepIsPublic(),
                ]),
          ),
        ],
      ),
    );
  }

  Widget _buildStepNickname() {
    return _buildFormStep(
      title: "What should we call you?",
      content: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.grey, width: 1.5)),
            ),
            child: TextField(
              controller: displayNameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none)),
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text.rich(
            TextSpan(
              text: "This is how the content will appear on your profile. ",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700]), // Phần text bình thường
              children: [
                TextSpan(
                  text: "You won't be able to change it later",
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // In đậm phần này
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStepAge() {
    return _buildFormStep(
      title: "How old are you?",
      content: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.grey, width: 1.5)),
            ),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: ageController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: "Enter your age"),
              style: TextStyle(fontSize: 20),
              // onChanged: _validateAge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepGender() {
    return _buildFormStep(
      title: "Your gender is?",
      content: Column(
        children: [
          ...genderOptions.map((gender) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedGender == gender["value"]
                        ? Colors.redAccent
                        : Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedGender = gender["value"];
                    });
                  },
                  child: Text(
                    gender["label"]!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: selectedGender == gender["value"]
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStepIsPublic() {
    return _buildFormStep(
        title: "Do you want to set your profile to public?",
        content: Column(
          children: [
            Text(
              "A public profile helps others find and connect with you more easily.",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOptionButton("Public", true, Colors.green),
                _buildOptionButton("Private", false, Colors.red),
              ],
            ),
          ],
        ));
  }

  Widget _buildStepOrientation() {
    return _buildFormStep(
      title: "What is your sexual orientation?",
      content: Expanded(
        child: ListView.builder(
          itemCount: orientationOptions.length,
          itemBuilder: (context, index) {
            final option = orientationOptions[index];
            final isSelected = selectedOrientation == option["value"];
            return ListTile(
              title: Text(option["label"]!),
              trailing: isSelected
                  ? Icon(Icons.check, color: Colors.redAccent)
                  : null,
              onTap: () {
                setState(() {
                  selectedOrientation = option["value"];
                });
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildStepLookingFor() {
    return _buildFormStep(
      title: "What are you looking for in a relationship?",
      content: SizedBox(
        height: 300, // Giới hạn chiều cao để tránh tràn màn hình
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Hiển thị 3 cột
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: relationshipPreferences.length,
          itemBuilder: (context, index) {
            final preference = relationshipPreferences[index];
            bool isSelected =
                selectedLookingFor!.contains(preference["value"]!);

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedLookingFor!.clear();
                  selectedLookingFor!.add(preference["value"]!);
                });
              },
              child: Container(
                width: 100, // Đặt kích thước cố định
                height: 80, // Đặt kích thước cố định
                alignment: Alignment.center,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Màu bóng mờ
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Đổ bóng xuống dưới
                    ),
                  ],
                  border: Border.all(
                    color: isSelected ? Colors.redAccent : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Text(
                  preference["label"]!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStepBio() {
    return _buildFormStep(
        title: "Tell us about yourself",
        content: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 1.5)),
              ),
              child: TextField(
                controller: bioController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Be yourself! The more you share, the more connections you'll make.",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ));
  }

  Widget _buildStepInterested() {
    return _buildFormStep(
      title: "What do you like?",
      content: Column(
        children: [
          // Display selected interests inside a box (simulating an input field)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.grey, width: 1.5)),
            ),
            width: double.infinity,
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: interests.map((interest) {
                return Chip(
                  label: Text(interest),
                  padding: EdgeInsets.all(6),
                  onDeleted: () {
                    setState(() {
                      interests.remove(interest);
                    });
                  },
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 12),

          // List of available interests as ChoiceChips
          Wrap(
            spacing: 6.0,
            children: interestOptions.map((interest) {
              return ChoiceChip(
                label: Text(interest),
                padding: EdgeInsets.all(6),
                selected: interests.contains(interest),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                showCheckmark: false,
                selectedColor: Colors.redAccent,
                onSelected: (selected) {
                  setState(() {
                    selected
                        ? interests.add(interest)
                        : interests.remove(interest);
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLocation() {
    return _buildFormStep(
      title: "Where are you located?  ",
      content: Column(children: [
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          value: selectedCity,
          hint: Text("Select a city"),
          items: cities.map((city) {
            return DropdownMenuItem<String>(
              value: city,
              child: Text(city),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCity = value;
            });
          },
        ),
      ]),
    );
  }

  Widget _buildFormStep({required String title, required Widget content}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          content,
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentStep > 0)
                ElevatedButton(onPressed: _prevStep, child: Text("Back")),
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                onPressed: _nextStep,
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return authProvider.isLoading
                        ? CircularProgressIndicator()
                        : Text(_currentStep == 8 ? "Done" : "Next",
                            style: TextStyle(color: Colors.white));
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(String text, bool value, Color color) {
    bool isSelected = isPublic == value;

    return ElevatedButton(
      onPressed: () => setState(() {
        isPublic = value;
      }),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? color : Colors.grey[300],
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
