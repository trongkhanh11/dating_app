import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/presentation/home/filter_screen.dart';
import 'package:dating_app/themes/theme.dart';
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
  final CardSwiperController controller = CardSwiperController();

  final List<String> images = [
    'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg',
    'https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg',
    'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg',
    'https://images.pexels.com/photos/428338/pexels-photo-428338.jpeg',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Future(() async {
      for (var imageUrl in images) {
        await precacheImage(CachedNetworkImageProvider(imageUrl), context);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool onSwipe(
      int previousIndex,
      int? currentIndex,
      CardSwiperDirection direction,
    ) {
      debugPrint(
        'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
      );
      return true;
    }

    bool onUndo(
      int? previousIndex,
      int currentIndex,
      CardSwiperDirection direction,
    ) {
      debugPrint(
        'The card $currentIndex was undod from the ${direction.name}',
      );
      return true;
    }

    return Scaffold(
      backgroundColor: AppTheme.colors.bgColor,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: AppTheme.colors.bgColor,
        title: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            "Dating App",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.slider_horizontal_3,
              size: 22,
              color: Colors.grey,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => FilterScreen(),
              );
            },
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: CardSwiper(
                  controller: controller,
                  cardsCount: images.length,
                  onSwipe: onSwipe,
                  onUndo: onUndo,
                  numberOfCardsDisplayed: 3,
                  backCardOffset: const Offset(0, 0),
                  padding: const EdgeInsets.all(24.0),
                  cardBuilder: (
                    context,
                    index,
                    horizontalThresholdPercentage,
                    verticalThresholdPercentage,
                  ) {
                    double opacity = (horizontalThresholdPercentage.abs() * 2.0)
                        .clamp(0.0, 1.0);

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: images[index],
                            cacheManager: DefaultCacheManager(),
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Image.asset(
                                'assets/images/placeholder.png',
                                fit: BoxFit.cover),
                          ),

                          Positioned(
                            top: 40,
                            left: 20,
                            child: Opacity(
                              opacity: horizontalThresholdPercentage > 0
                                  ? opacity
                                  : 0,
                              child: Transform.rotate(
                                angle: -0.3,
                                child: Text(
                                  "LIKE",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            top: 40,
                            right: 20,
                            child: Opacity(
                              opacity: horizontalThresholdPercentage < 0
                                  ? opacity
                                  : 0,
                              child: Transform.rotate(
                                angle: 0.3,
                                child: Text(
                                  "NOPE",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Thông tin người dùng
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              decoration: BoxDecoration(color: Colors.black38),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Meera ${22 + index}',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.verified,
                                          color: Colors.blue, size: 20),
                                    ],
                                  ),
                                  Text(
                                    '💬 I just realized that...\n2020 was 3 years ago... I also just realized time isn\'t real.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: () => controller.swipe(CardSwiperDirection.left),
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    child: const Icon(
                      FontAwesomeIcons.xmark,
                      size: 28,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 24),
                  FloatingActionButton(
                    onPressed: () => controller.swipe(CardSwiperDirection.top),
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    child: const Icon(
                      FontAwesomeIcons.solidStar,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 24),
                  FloatingActionButton(
                    onPressed: () =>
                        controller.swipe(CardSwiperDirection.right),
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    child: const Icon(
                      FontAwesomeIcons.solidHeart,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
