import 'package:dating_app/presentation/authentication/login/login_screen.dart';
import 'package:dating_app/providers/auth_provider.dart';
import 'package:dating_app/providers/preferences_provider.dart';
import 'package:dating_app/providers/profile_provider.dart';
import 'package:dating_app/widgets/profile_widgets/cities_selection.dart';
import 'package:dating_app/widgets/profile_widgets/custom_selection.dart';
import 'package:dating_app/widgets/profile_widgets/gender_selection.dart';
import 'package:dating_app/widgets/profile_widgets/image_picker_box.dart';
import 'package:dating_app/widgets/profile_widgets/interests_selection.dart';
import 'package:dating_app/widgets/profile_widgets/languages_selection.dart';
import 'package:dating_app/widgets/profile_widgets/looking_for_selection.dart';
import 'package:dating_app/widgets/profile_widgets/sexualOrientation_selection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonalProfileScreen extends StatefulWidget {
  const PersonalProfileScreen({super.key});

  @override
  State<PersonalProfileScreen> createState() => _PersonalProfileScreenState();
}

class _PersonalProfileScreenState extends State<PersonalProfileScreen> {
  bool isLoading = true;

  final TextEditingController bioController = TextEditingController();
  bool isPublic = true;
  String? selectedGender;
  List<String> selectedOrientation = [];
  String? selectedCity;
  List<String> interests = [];
  List<String> lookingFor = [];
  List? imagesUrl = [];
  String displayName = "";
  int age = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        _loadUserProfile();
      }
    });
  }

  void _loadUserProfile() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final preferencesProvider =
        Provider.of<PreferencesProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.userModel?.user.id ?? "";

    List<String> fileIds = profileProvider.profile?.files ?? [];
    await profileProvider.getProfilePhotos(fileIds, context);
    //imagesUrl = profileProvider.images;
    await profileProvider.getUserProfile(userId, context);
    await preferencesProvider.getUserPreferences(userId, context);
    lookingFor = preferencesProvider.preferences!.lookingFor;
    selectedOrientation = profileProvider.profile?.sexualOrientation ?? [];
    selectedGender = profileProvider.profile?.gender;
    selectedCity = profileProvider.profile?.location;
    print("preferences id: ${preferencesProvider.preferences?.id}");
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
      body: Consumer3<ProfileProvider, PreferencesProvider, AuthProvider>(
          builder: (context, profileProvider, preferencesProvider, authProvider,
              child) {
        return authProvider.isLoggingOut ||
                profileProvider.isLoading ||
                preferencesProvider.isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Avatar
                      CircleAvatar(
                        radius: 53,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage(profileProvider.images!.first),
                        ),
                      ),
                      SizedBox(height: 16),
                      //Name
                      Text(
                        profileProvider.profile!.displayName,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      //Age
                      Text(
                        '${profileProvider.profile!.age} years old',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      //Photo & Video
                      Container(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'PHOTOS AND VIDEOS',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                      Container(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Pick some that show the true you.",
                          )),
                      Container(
                          padding: EdgeInsets.all(8),
                          child: MultiImagePicker(
                            imageUrls: profileProvider.images,
                          )),
                      SizedBox(height: 16),
                      //Bio
                      Container(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'SAY SOMETHING ABOUT YOURSELF',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
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
                          controller: TextEditingController(
                              text: profileProvider.profile!.bio),
                          maxLength: 500,
                          decoration: InputDecoration(
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
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
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
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
                          interests:
                              preferencesProvider.preferences?.hobbies ?? [],
                          onChanged: (newInterests) {
                            setState(() {
                              interests =
                                  newInterests; // Cập nhật lại danh sách sở thích
                            });
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
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                      Container(
                        color: Colors.white,
                        //   3height: 50,
                        child: LookingForSelection(
                          initialSelection: lookingFor.isNotEmpty == true
                              ? lookingFor.first
                              : null,
                          onChanged: (newLookingFor) {
                            setState(() {
                              preferencesProvider.preferences?.lookingFor = [
                                newLookingFor
                              ];
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),

                      SizedBox(height: 16),
                      //Gender selection
                      Container(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'GENDER',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                      Container(
                        color: Colors.white,
                        child: GenderSelection(
                          initialGender: selectedGender,
                          // onChanged: (newGender) {
                          //   setState(() {
                          //     selectedGender = newGender;
                          //   });
                          //   profileProvider.profile?.gender = newGender;
                          // },
                        ),
                      ),
                      SizedBox(height: 16),
                      //Languages
                      Container(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'LANGUAGES',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                      Container(
                        color: Colors.white,
                        //   3height: 50,
                        child: LanguageSelection(
                            initialLanguages:
                                preferencesProvider.preferences?.languages),
                      ),

                      SizedBox(height: 16),
                      //More about Me
                      Container(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'MORE ABOUT ME',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),

                      Container(
                        color: Colors.white,
                        //height: 300,
                        child: Column(
                          children: [
                            SelectionWidget(
                                title: "Zodiac Sign",
                                initialSelection: preferencesProvider
                                    .preferences?.zodiacSigns,
                                options: [
                                  {"label": "Aries", "value": "aries"},
                                  {"label": "Taurus", "value": "taurus"},
                                  {"label": "Gemini", "value": "gemini"},
                                  {"label": "Cancer", "value": "cancer"},
                                  {"label": "Leo", "value": "leo"},
                                  {"label": "Virgo", "value": "virgo"},
                                  {"label": "Libra", "value": "libra"},
                                  {"label": "Scorpio", "value": "scorpio"},
                                  {
                                    "label": "Sagittarius",
                                    "value": "sagittarius"
                                  },
                                  {"label": "Capricorn", "value": "capricorn"},
                                  {"label": "Aquarius", "value": "aquarius"},
                                  {"label": "Pisces", "value": "pisces"},
                                ]),
                            SelectionWidget(
                                title: "Education",
                                initialSelection:
                                    preferencesProvider.preferences?.education,
                                options: [
                                  {
                                    "label": "High School",
                                    "value": "high_school"
                                  },
                                  {
                                    "label": "Bachelor's Degree",
                                    "value": "bachelor"
                                  },
                                  {
                                    "label": "Master's Degree",
                                    "value": "master"
                                  },
                                  {"label": "PhD", "value": "phd"},
                                  {"label": "Other", "value": "other"},
                                ]),
                            SelectionWidget(
                                title: "Future Family",
                                initialSelection: preferencesProvider
                                    .preferences?.futureFamily,
                                options: [
                                  {"label": "Single", "value": "single"},
                                  {"label": "Married", "value": "married"},
                                  {"label": "With Kids", "value": "with_kids"},
                                  {"label": "Other", "value": "other"},
                                ]),
                            SelectionWidget(
                                title: "Personality Style",
                                initialSelection: preferencesProvider
                                    .preferences?.personalityTypes,
                                options: [
                                  {"label": "Introvert", "value": "introvert"},
                                  {"label": "Extrovert", "value": "extrovert"},
                                  {"label": "Ambivert", "value": "ambivert"},
                                  {"label": "Other", "value": "other"},
                                ]),
                            SelectionWidget(
                                title: "Communication Style",
                                initialSelection: preferencesProvider
                                    .preferences?.communicationStyles,
                                options: [
                                  {"label": "Direct", "value": "direct"},
                                  {"label": "Indirect", "value": "indirect"},
                                  {"label": "Assertive", "value": "assertive"},
                                  {"label": "Passive", "value": "passive"},
                                ])
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      //Life styles
                      Container(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'LIFE STYLES',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                      Container(
                        color: Colors.white,
                        //height: 300,
                        child: Column(
                          children: [
                            SelectionWidget(
                                title: "Pet",
                                initialSelection: preferencesProvider
                                    .preferences?.petPreferences,
                                options: [
                                  {"label": "Dog", "value": "dog"},
                                  {"label": "Cat", "value": "cat"},
                                  {"label": "Bird", "value": "bird"},
                                  {"label": "Fish", "value": "fish"},
                                ]),
                            SelectionWidget(
                              title: "Drinking",
                              initialSelection:
                                  preferencesProvider.preferences?.drinking,
                              options: [
                                {"label": "Never", "value": "never"},
                                {"label": "Social", "value": "social"},
                                {"label": "Often", "value": "often"},
                              ],
                            ),
                            SelectionWidget(
                                title: "Smoking",
                                initialSelection:
                                    preferencesProvider.preferences?.smoking,
                                options: [
                                  {"label": "Never", "value": "never"},
                                  {
                                    "label": "Occasionally",
                                    "value": "occasionally"
                                  },
                                  {"label": "Regularly", "value": "regularly"},
                                ]),
                            SelectionWidget(
                              title: "Exercise",
                              initialSelection:
                                  preferencesProvider.preferences?.exercise,
                              options: [
                                {"label": "Rarely", "value": "rarely"},
                                {"label": "Weekly", "value": "weekly"},
                                {"label": "Daily", "value": "daily"},
                              ],
                            ),
                            SelectionWidget(
                                title: "Diet",
                                initialSelection:
                                    preferencesProvider.preferences?.diet,
                                options: [
                                  {"label": "Omnivore", "value": "omnivore"},
                                  {
                                    "label": "Vegetarian",
                                    "value": "vegetarian"
                                  },
                                  {"label": "Vegan", "value": "vegan"},
                                  {
                                    "label": "Pescatarian",
                                    "value": "pescatarian"
                                  },
                                  {"label": "Keto", "value": "keto"},
                                  {"label": "Paleo", "value": "paleo"},
                                  {
                                    "label": "Gluten-Free",
                                    "value": "gluten_free"
                                  },
                                  {
                                    "label": "Dairy-Free",
                                    "value": "dairy_free"
                                  },
                                  {"label": "Low-Carb", "value": "low_carb"},
                                  {
                                    "label": "High-Protein",
                                    "value": "high_protein"
                                  },
                                ]),
                            SelectionWidget(
                                title: "Social Media",
                                initialSelection: preferencesProvider
                                    .preferences?.socialMedia,
                                options: [
                                  {"label": "Facebook", "value": "facebook"},
                                  {"label": "Instagram", "value": "instagram"},
                                  {"label": "Twitter/X", "value": "twitter"},
                                  {"label": "TikTok", "value": "tiktok"},
                                  {"label": "Snapchat", "value": "snapchat"},
                                  {"label": "LinkedIn", "value": "linkedin"},
                                  {"label": "YouTube", "value": "youtube"},
                                  {"label": "Reddit", "value": "reddit"},
                                  {"label": "Pinterest", "value": "pinterest"},
                                  {"label": "Discord", "value": "discord"},
                                  {"label": "Telegram", "value": "telegram"},
                                  {"label": "WhatsApp", "value": "whatsapp"},
                                ]),
                            SelectionWidget(
                                title: "Sleep Habit",
                                initialSelection: preferencesProvider
                                    .preferences?.sleepHabits,
                                options: [
                                  {
                                    "label": "Early Bird",
                                    "value": "early_bird"
                                  },
                                  {"label": "Night Owl", "value": "night_owl"},
                                  {
                                    "label": "Biphasic Sleeper",
                                    "value": "biphasic"
                                  },
                                  {
                                    "label": "Light Sleeper",
                                    "value": "light_sleeper"
                                  },
                                  {
                                    "label": "Heavy Sleeper",
                                    "value": "heavy_sleeper"
                                  },
                                  {
                                    "label": "Irregular Sleep",
                                    "value": "irregular"
                                  },
                                ])
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      //Sexual Orientation selection
                      Container(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'SEXSUAL ORIENTATION',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                      Container(
                        color: Colors.white,
                        child: SexualOrientationSelection(
                          initialOrientation: selectedOrientation.isNotEmpty
                              ? selectedOrientation.first
                              : "",
                          // onChanged: (newType) {
                          //   setState(() {
                          //     selectedOrientation = newType;
                          //   });
                          //   profileProvider.sexualOrientation = newType;
                          // }
                        ),
                      ),
                      SizedBox(height: 16),
                      //Location
                      Container(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'LOCATION',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                      Container(
                        color: Colors.white,
                        child: CityDropdownField(
                            initialCity: selectedCity,
                            onChanged: (newCity) {
                              // setState(() {
                              //   selectedCity = newCity;
                              // });
                              // profileProvider.location = newCity;
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
                              authProvider.logout(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            },
                            splashColor: Colors.grey
                                .withOpacity(0.3), // Màu hiệu ứng gợn sóng
                            highlightColor:
                                Colors.grey.withOpacity(0.1), // Màu nhấn giữ
                            child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "Log out",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),

                      //   SizedBox(height: 16),
                      //   //Button
                    ],
                  ),
                ),
              );
      }),
    );
  }
}
