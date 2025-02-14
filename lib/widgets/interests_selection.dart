import 'dart:math';

import 'package:flutter/material.dart';

class InterestsSelection extends StatefulWidget {
  @override
  _InterestsSelectionState createState() => _InterestsSelectionState();
}

class _InterestsSelectionState extends State<InterestsSelection> {
  List<String> interestOptions = [
    "Gaming",
    "Music",
    "Sports",
    "Travel",
    "Movies",
    "Reading",
    "Coding",
    "Cooking"
  ];
  List<String> selectedInterests = [];

  void _showInterestSelectionSheet(BuildContext context) {
    List<String> tempSelectedInterests =
        List.from(selectedInterests); // Copy danh sách hiện tại

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Mở full-screen
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateBottomSheet) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        "Select Interests",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedInterests = List.from(
                                tempSelectedInterests); // Cập nhật danh sách chính
                          });
                          Navigator.pop(context);
                        },
                        child: Text("Done", style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                  Divider(),

                  // Hiển thị các sở thích đã chọn
                  if (tempSelectedInterests.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 6.0,
                      children: tempSelectedInterests.map((interest) {
                        return Chip(
                          label: Text(interest),
                          deleteIcon: Icon(Icons.close),
                          padding: EdgeInsets.all(6),
                          onDeleted: () {
                            setStateBottomSheet(() {
                              tempSelectedInterests.remove(interest);
                            });
                          },
                        );
                      }).toList(),
                    ),
                    Divider(),
                  ],

                  // Danh sách tất cả các sở thích
                  Expanded(
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 6.0,
                        runSpacing: 6.0,
                        children: interestOptions.map((interest) {
                          return ChoiceChip(
                            label: Text(interest),
                            padding: EdgeInsets.all(8),
                            selected: tempSelectedInterests.contains(interest),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            selectedColor: Colors.redAccent,
                            showCheckmark: false,
                            onSelected: (selected) {
                              setStateBottomSheet(() {
                                selected
                                    ? tempSelectedInterests.add(interest)
                                    : tempSelectedInterests.remove(interest);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hiển thị danh sách sở thích đã chọn
        GestureDetector(
          onTap: () => _showInterestSelectionSheet(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              
              border: Border.all(
                color: Colors.transparent,
              ),
            ),
            height: selectedInterests.isEmpty || selectedInterests.length < 3
                ? 60
                : (selectedInterests.length * 23.0 + 20),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: selectedInterests.isEmpty
                        ? []
                        : selectedInterests.map((interest) {
                            return Chip(
                              label: Text(interest),
                              padding: EdgeInsets.all(6),
                              // onDeleted: () {
                              //   setState(() {
                              //     selectedInterests.remove(interest);
                              //   });
                              // },
                            );
                          }).toList(),
                  ),
                ),
                Icon(Icons.arrow_forward_ios,color: Colors.grey,)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
