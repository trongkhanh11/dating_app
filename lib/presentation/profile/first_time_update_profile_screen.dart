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
  String? selectedType;
  String? selectedCity;
  String? ageErrorMessage;
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
    "Tokyo",
    "Yokohama",
    "Osaka",
    "Nagoya",
    "Sapporo",
    "Fukuoka",
    "Kobe",
    "Kyoto",
    "Kawasaki",
    "Saitama",
    "Hiroshima",
    "Sendai",
    "Chiba",
    "Niigata",
    "Hamamatsu",
    "Shizuoka",
    "Okayama",
    "Sagamihara",
    "Kumamoto",
    "Kagoshima",
    "Funabashi",
    "Hachioji",
    "Utsunomiya",
    "Matsuyama",
    "Nagasaki",
    "Oita",
    "Kanazawa",
    "Naha",
    "Akita",
    "Fukushima",
    "Toyama",
    "Gifu"
  ];
  List<String> genderOptions = ["Male", "Female", "Other"];
  List<String> typeOption = ["Male", "Female", "Both"];
  void _nextStep() {
    // if(_currentStep == 1 ){
    //   _validateAge(ageController.text);
    //   if(ageErrorMessage != null){
    //     return;
    //   }
    // }
    if (_currentStep < 7) {
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

  // void _validateAge(String value) {
  //   setState(() {
  //     int? age = int.tryParse(ageController.text);
  //     if (age == null || age < 18) {
  //       ageErrorMessage = "You must be at least 18 years old";
  //     } else {
  //       ageErrorMessage = null;
  //     }
  //   });
  // }

  void _submitForm() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    await profileProvider.loadToken();
    bool success = await profileProvider.createProfile(
        widget.userId,
        displayNameController.text,
        isPublic,
        int.tryParse(ageController.text) ?? 18,
        selectedGender ?? "Other",
        selectedType ?? "Both",
        bioController.text,
        interests,
        selectedCity ?? "Unknown",
        10.810370781525451,
        106.66743096751458);
    if (success) {
      debugPrint("User profile created successfully!");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BottomBar()),
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
          LinearProgressIndicator(value: (_currentStep + 1) / 5),
          Expanded(
            child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildStepNickname(),
                  _buildStepAge(),
                  _buildStepGender(),
                  _buildStepType(),
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
                width: double.infinity, // Chiếm toàn bộ chiều rộng
                height: 60, // Độ cao cố định của từng nút
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedGender == gender
                        ? Colors.redAccent
                        : Colors.grey[200], // Màu khi chọn hoặc chưa chọn
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Bo góc
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedGender = gender;
                    });
                  },
                  child: Text(
                    gender,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: selectedGender == gender
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          }),
          if (selectedGender == null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                "Please select a gender",
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
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

  Widget _buildStepType() {
    return _buildFormStep(
      title: "What Are You Looking For?",
      content: Column(
        children: [
          ...typeOption.map((gender) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                width: double.infinity, // Chiếm toàn bộ chiều rộng
                height: 60, // Độ cao cố định của từng nút
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedType == gender
                        ? Colors.redAccent
                        : Colors.grey[200], // Màu khi chọn hoặc chưa chọn
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Bo góc
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedType = gender;
                    });
                  },
                  child: Text(
                    gender,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color:
                          selectedType == gender ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          }),
          if (selectedType == null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                "Please select a type of person you are interested in",
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
        ],
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
                child: Text(_currentStep == 7 ? "Submit" : "Next",
                    style: TextStyle(color: Colors.white)),
              ),
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
