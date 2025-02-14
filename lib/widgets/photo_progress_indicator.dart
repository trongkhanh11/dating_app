import 'package:flutter/material.dart';

class PhotoProgressIndicator extends StatelessWidget {
  final int index;
  final Map<int, int> photoIndexes;
  final List<Map<String, dynamic>> filteredUsers;

  const PhotoProgressIndicator({
    super.key,
    required this.index,
    required this.photoIndexes,
    required this.filteredUsers,
  });

  @override
  Widget build(BuildContext context) {
    int currentPhotoIndex = photoIndexes[index] ?? 0;
    int totalPhotos = filteredUsers[index]['photos'].length;

    return totalPhotos != 1
        ? Positioned(
            top: 10,
            right: 10,
            left: 10,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(totalPhotos, (i) {
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 2.5),
                      height: 4,
                      width: (MediaQuery.of(context).size.width - 40) /
                              totalPhotos -
                          4,
                      decoration: BoxDecoration(
                        color: i == currentPhotoIndex
                            ? Colors.white
                            : Colors.black54,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.5,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          )
        : SizedBox();
  }
}
