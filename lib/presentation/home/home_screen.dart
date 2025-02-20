import 'package:dating_app/models/interaction_model.dart';
import 'package:dating_app/models/profile_model.dart';
import 'package:dating_app/presentation/home/filter_screen.dart';
import 'package:dating_app/providers/auth_provider.dart';
import 'package:dating_app/providers/discovery_provider.dart';
import 'package:dating_app/providers/interaction_provider.dart';
import 'package:dating_app/providers/preferences_provider.dart';
import 'package:dating_app/themes/theme.dart';
import 'package:dating_app/widgets/custom_action_button.dart';
import 'package:dating_app/widgets/photo_progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CardSwiperController controller = CardSwiperController();
  final ScrollController scrollController = ScrollController();
  final BaseCacheManager cacheManager = DefaultCacheManager();

  List<Profile> filteredUsers = [];
  double minAge = 18;
  double maxAge = 35;
  double maxDistance = 50;

  Map<int, int> photoIndexes = {};
  Map<int, List<String>> interests = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        _applyFilter();
      }
    });
  }

  Future<void> _fetchInterests(int index, Profile user) async {
    final preferencesProvider =
        Provider.of<PreferencesProvider>(context, listen: false);
    if (user.id.isNotEmpty && !interests.containsKey(index)) {
      await preferencesProvider.getUserPreferences(user.id, context);
      List<String> hobbies = preferencesProvider.preferences?.hobbies ?? [];
      if (mounted) {
        setState(() {
          interests[index] = hobbies;
        });
      }
    }
  }

  void _changePhoto(int index, int change) {
    setState(() {
      if (!photoIndexes.containsKey(index)) {
        photoIndexes[index] = 0;
      }
      int currentIndex = photoIndexes[index]!;
      int maxIndex = filteredUsers[index].files != null
          ? filteredUsers[index].files!.length - 1
          : 0;
      int newIndex = (currentIndex + change).clamp(0, maxIndex);

      if (newIndex != currentIndex) {
        photoIndexes[index] = newIndex;
      }
    });
  }

  Future<void> _applyFilter() async {
    final discoveryProvider =
        Provider.of<DiscoveryProvider>(context, listen: false);
    await discoveryProvider.discovery(
        [minAge.toInt(), maxAge.toInt()], maxDistance.toInt(), context);

    setState(() {
      if (discoveryProvider.listProfile?.profiles != null) {
        filteredUsers = discoveryProvider.listProfile!.profiles!;
      }
    });
    for (int i = 0; i < filteredUsers.length; i++) {
      _fetchInterests(i, filteredUsers[i]);
    }
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

  bool onSwipe(int prev, int? curr, CardSwiperDirection direction) {
    final interactionProvider =
        Provider.of<InteractionProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserId = authProvider.userModel?.user.id;
    if (direction == CardSwiperDirection.left) {
      Interaction interaction = Interaction(
        senderId: currentUserId!,
        receiverId: filteredUsers[prev].user.id,
        type: "DISLIKE",
      );
      interactionProvider.interact(interaction, context);
    } else if (direction == CardSwiperDirection.right) {
      Interaction interaction = Interaction(
        senderId: currentUserId!,
        receiverId: filteredUsers[prev].user.id,
        type: "LIKE",
      );
      interactionProvider.interact(interaction, context);
    } else {
      return false;
    }
    setState(() {
      photoIndexes = {};
    });
    scrollController.jumpTo(0.0);
    return true;
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
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
        automaticallyImplyLeading: false,
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
                filteredUsers.isNotEmpty
                    ? CardSwiper(
                        controller: controller,
                        cardsCount: filteredUsers.length,
                        onSwipe: onSwipe,
                        padding: EdgeInsets.zero,
                        numberOfCardsDisplayed: 1,
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
                            controller: scrollController,
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
                                    height: MediaQuery.of(context).size.height -
                                        180,
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
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width;
                                              double tapPosition =
                                                  details.localPosition.dx;

                                              if (tapPosition <
                                                  screenWidth / 2) {
                                                _changePhoto(index, -1);
                                              } else {
                                                _changePhoto(index, 1);
                                              }
                                            },
                                            child: filteredUsers[index].files !=
                                                        null &&
                                                    filteredUsers[index]
                                                        .files!
                                                        .isNotEmpty
                                                ? Image.network(
                                                    filteredUsers[index].files![
                                                        currentPhotoIndex],
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    'assets/images/placeholder.png',
                                                    fit: BoxFit.cover),
                                          ),
                                          _buildUserInfo(
                                              user, interests[index]),
                                          if (label != null)
                                            Positioned(
                                              top: label == "SUPER LIKE"
                                                  ? null
                                                  : 10,
                                              bottom: label == "SUPER LIKE"
                                                  ? 20
                                                  : null,
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
                                                    height:
                                                        label == "SUPER LIKE"
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    decoration:
                                        BoxDecoration(color: Colors.white),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "\"${filteredUsers[index].bio}\"",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                        _buildInterests(interests[index]),
                                      ],
                                    ),
                                  ),
                                  _buildBottomButtons(),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(Profile user, List<String>? interest) {
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
                    user.displayName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    '${user.age}',
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
                    '10 km away',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              interest != null
                  ? Row(
                      children: [
                        Icon(
                          CupertinoIcons.square_favorites_alt,
                          color: Colors.white70,
                        ),
                        SizedBox(width: 10),
                        Text(
                          interest.join(', '),
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    )
                  : SizedBox(),
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

  Widget _buildInterests(List<String>? interests) {
    return interests != null
        ? Column(
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
          )
        : SizedBox();
  }
}
