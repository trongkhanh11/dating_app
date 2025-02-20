import 'package:flutter/material.dart';

class InterestsSelection extends StatefulWidget {
  final List<String> interests;
  final ValueChanged<List<String>>? onChanged;

  const InterestsSelection({
    super.key,
    required this.interests,
    this.onChanged,
  });

  @override
  _InterestsSelectionState createState() => _InterestsSelectionState();
}

class _InterestsSelectionState extends State<InterestsSelection> {
  List<String> interestOptions = [
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
  List<String> selectedInterests = [];

  @override
  void initState() {
    super.initState();
    selectedInterests = List.from(widget.interests);
  }

  void _updateSelectedInterests(List<String> newInterests) {
    setState(() {
      selectedInterests = List.from(newInterests);
    });
    widget.onChanged?.call(selectedInterests); // Gửi dữ liệu lên cha
  }

  void _showInterestSelectionSheet(BuildContext context) {
    List<String> tempSelectedInterests = List.from(selectedInterests);
    TextEditingController searchController = TextEditingController();
    String searchQuery = "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateBottomSheet) {
            List<String> filteredInterests = interestOptions
                .where((interest) =>
                    interest.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.fromLTRB(16, 50, 16, 16),
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
                          _updateSelectedInterests(tempSelectedInterests);
                          Navigator.pop(context);
                        },
                        child: Text("Done", style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Display selected interests
                  if (tempSelectedInterests.isNotEmpty) ...[
                    SizedBox(
                      height: 40, // Đặt chiều cao cố định cho danh sách ngang
                      child: ListView.builder(
                        scrollDirection:
                            Axis.horizontal, // Kích hoạt cuộn ngang
                        itemCount: tempSelectedInterests.length,
                        itemBuilder: (context, index) {
                          final interest = tempSelectedInterests[index];
                          return Padding(
                            padding: EdgeInsets.only(
                                right: 6.0), // Khoảng cách giữa các Chip
                            child: Chip(
                              label: Text(interest),
                              labelStyle: TextStyle(color: Colors.white),
                              deleteIcon:
                                  Icon(Icons.close, color: Colors.white),
                              padding: EdgeInsets.all(6),
                              backgroundColor:
                                  const Color.fromARGB(255, 31, 30, 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Colors.grey),
                              ),
                              onDeleted: () {
                                setStateBottomSheet(() {
                                  tempSelectedInterests.remove(interest);
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ] else ...[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                          "Let people know what you're passionate about by adding 5 hobbies to your profile."),
                    ),
                  ],

                  // Search bar
                  TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setStateBottomSheet(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search interests...",
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Display filtered list of interests
                  Expanded(
                    child: SingleChildScrollView(
                        child: Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: filteredInterests.map((interest) {
                        return ChoiceChip(
                          label: Text(interest),
                          padding: EdgeInsets.all(6),
                          selected: tempSelectedInterests.contains(interest),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.grey),
                          ),
                          selectedColor: Colors.redAccent,
                          showCheckmark: false,
                          onSelected: (selected) {
                            setStateBottomSheet(() {
                              if (selected) {
                                tempSelectedInterests.add(interest);
                              } else {
                                tempSelectedInterests.remove(interest);
                              }
                            });
                          },
                        );
                      }).toList(),
                    )),
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
            height: 60,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(
                  selectedInterests.isEmpty
                      ? "Select your interests..."
                      : selectedInterests.join(", "),
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        selectedInterests.isEmpty ? Colors.grey : Colors.black,
                  ),
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis, // Nếu quá dài sẽ có dấu "..."
                )),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
