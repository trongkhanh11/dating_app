import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/presentation/home/filter_screen.dart';
import 'package:dating_app/themes/theme.dart';
import 'package:dating_app/widgets/custom_action_button.dart';
import 'package:dating_app/widgets/photo_progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = CardSwiperController();
  final BaseCacheManager cacheManager = DefaultCacheManager();

  final List<Map<String, dynamic>> allUsers = [
    {
      'name': 'Ethan',
      'age': 22,
      'distance': 5,
      'photos': [
        'https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg',
        'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg',
        'https://images.pexels.com/photos/428338/pexels-photo-428338.jpeg',
      ],
      'hobbies': ['Reading', 'Traveling']
    },
    {
      'name': 'Sophia',
      'age': 27,
      'distance': 15,
      'photos': [
        'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
        'https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg',
        'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg'
      ],
      'hobbies': ['Cooking', 'Dancing']
    },
    {
      'name': 'Emma',
      'age': 30,
      'distance': 8,
      'photos': [
        'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg',
      ],
      'hobbies': ['Photography', 'Hiking']
    },
    {
      'name': 'Olivia',
      'age': 25,
      'distance': 20,
      'photos': [
        'https://images.pexels.com/photos/428338/pexels-photo-428338.jpeg',
        'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg'
      ],
      'hobbies': ['Music', 'Gaming']
    },
  ];

  List<Map<String, dynamic>> filteredUsers = [];
  double minAge = 18;
  double maxAge = 35;
  double maxDistance = 10;

  Map<int, int> photoIndexes = {};

  @override
  void initState() {
    super.initState();
    _applyFilter();
  }

  void _changePhoto(int index, int change) {
    setState(() {
      if (!photoIndexes.containsKey(index)) {
        photoIndexes[index] = 0;
      }
      int currentIndex = photoIndexes[index]!;
      int maxIndex = filteredUsers[index]['photos'].length - 1;
      int newIndex = (currentIndex + change).clamp(0, maxIndex);

      if (newIndex != currentIndex) {
        photoIndexes[index] = newIndex;
      }
    });
  }

  void _applyFilter() {
    setState(() {
      filteredUsers = allUsers.where((user) {
        return user['age'] >= minAge &&
            user['age'] <= maxAge &&
            user['distance'] <= maxDistance;
      }).toList();
    });
    photoIndexes.clear();
  }

  void _openFilterScreen() async {
    final result = await showModalBottomSheet<Map<String, double>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
          FilterScreen(minAge: minAge, maxAge: maxAge, distance: maxDistance),
    );

    if (result != null) {
      setState(() {
        minAge = result['minAge']!;
        maxAge = result['maxAge']!;
        maxDistance = result['distance']!;
      });
      _applyFilter();
    }
  }

  bool onSwipe(int prev, int? curr, CardSwiperDirection dir) {
    debugPrint('Card $prev swiped ${dir.name}, now $curr is on top');
    setState(() {
      photoIndexes = {};
    });
    return true;
  }

  void viewProfile(Map<String, dynamic> user) {}

  @override
  void dispose() {
    controller.dispose();
    cacheManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.bgColor,
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: AppTheme.colors.bgColor,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Dating App",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.slider_horizontal_3,
                color: Colors.grey),
            onPressed: _openFilterScreen,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                CardSwiper(
                  controller: controller,
                  cardsCount: filteredUsers.length,
                  onSwipe: onSwipe,
                  padding: EdgeInsets.zero,
                  numberOfCardsDisplayed: filteredUsers.length,
                  backCardOffset: Offset.zero,
                  cardBuilder: (context, index, hThreshold, vThreshold) {
                    final user = filteredUsers[index];
                    int currentPhotoIndex = photoIndexes[index] ?? 0;

                    final absH = hThreshold.abs();
                    final absV = vThreshold.abs();

                    String? label;
                    String imageUrl = "";
                    double rotationAngle = 0;

                    if (absV > absH && vThreshold < 0) {
                      label = "SUPER LIKE";
                      imageUrl = "assets/images/super_like.png";
                    } else if (hThreshold < 0) {
                      label = "LIKE";
                      imageUrl = "assets/images/like.png";
                      rotationAngle = 0.3;
                    } else if (hThreshold > 0) {
                      label = "NOPE";
                      imageUrl = "assets/images/nope.png";
                      rotationAngle = -0.3;
                    }

                    return SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height - 180,
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                  bottom: Radius.circular(16),
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    GestureDetector(
                                      onTapUp: (details) async {
                                        double screenWidth =
                                            MediaQuery.of(context).size.width;
                                        double tapPosition =
                                            details.localPosition.dx;

                                        if (tapPosition < screenWidth / 2) {
                                          _changePhoto(index, -1);
                                        } else {
                                          _changePhoto(index, 1);
                                        }
                                      },
                                      child: CachedNetworkImage(
                                        key: ValueKey(
                                            user['photos'][currentPhotoIndex]),
                                        imageUrl: user['photos']
                                            [currentPhotoIndex],
                                        cacheManager: cacheManager,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                'assets/images/placeholder.png'),
                                      ),
                                    ),
                                    _buildUserInfo(user),
                                    if (label != null)
                                      Positioned(
                                        top: label == "SUPER LIKE" ? null : 10,
                                        bottom:
                                            label == "SUPER LIKE" ? 20 : null,
                                        left: (label == "NOPE" ||
                                                label == "SUPER LIKE")
                                            ? 10
                                            : null,
                                        right: (label == "LIKE" ||
                                                label == "SUPER LIKE")
                                            ? 10
                                            : null,
                                        child: Opacity(
                                          opacity: ((label == "SUPER LIKE"
                                                      ? absV
                                                      : absH) *
                                                  2.0)
                                              .clamp(0.0, 1.0),
                                          child: Transform.rotate(
                                            angle: rotationAngle,
                                            child: Image.asset(
                                              imageUrl,
                                              width: label == "SUPER LIKE"
                                                  ? 200
                                                  : 140,
                                              height: label == "SUPER LIKE"
                                                  ? 200
                                                  : 140,
                                            ),
                                          ),
                                        ),
                                      ),
                                    PhotoProgressIndicator(
                                      index: index,
                                      photoIndexes: photoIndexes,
                                      filteredUsers: filteredUsers,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 30),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(color: Colors.white),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "\"Adventurer at heart, tech enthusiast by day. Love exploring new places, good coffee, and deep conversations. Let’s make memories one swipe at a time!\"",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  _buildInterests(user['hobbies']),
                                ],
                              ),
                            ),
                            _buildBottomButtons(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(Map<String, dynamic> user) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 22),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black,
              Colors.black,
              Colors.black87,
              Colors.black54,
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    '${user['name']}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    '${user['age']}',
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    CupertinoIcons.placemark,
                    color: Colors.white70,
                  ),
                  SizedBox(width: 10),
                  Text(
                    '${user['distance']} km away',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    CupertinoIcons.square_favorites_alt,
                    color: Colors.white70,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Hobbies: ${user['hobbies'].join(', ')}',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ]),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomActionButton(
            onPressed: () => controller.swipe(CardSwiperDirection.left),
            icon: FontAwesomeIcons.xmark,
            color: Colors.red,
          ),
          const SizedBox(width: 24),
          CustomActionButton(
            onPressed: () => controller.swipe(CardSwiperDirection.top),
            icon: FontAwesomeIcons.solidStar,
            color: Colors.blue,
          ),
          const SizedBox(width: 24),
          CustomActionButton(
            onPressed: () => controller.swipe(CardSwiperDirection.right),
            icon: FontAwesomeIcons.solidHeart,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildInterests(List<String> interests) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "My Interests",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: interests.map((interest) {
            return Chip(
              label: Text(
                interest,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                ),
              ),
              backgroundColor: Colors.white,
              avatar: Icon(
                Icons.favorite,
                size: 18,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            );
          }).toList(),
        ),
      ],
    );
  }
}
