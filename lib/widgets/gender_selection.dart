import 'package:flutter/material.dart';

class GenderSelection extends StatefulWidget {
  @override
  _GenderSelectionState createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {
  List<String> genderOptions = ["Male", "Female", "Non-binary", "Other"];
  String? selectedGender;

  void _showGenderSelectionSheet(BuildContext context) {
    String? tempSelectedGender = selectedGender; // Lưu trạng thái tạm thời

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
                        "Select Gender",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedGender =
                                tempSelectedGender; // Cập nhật giới tính đã chọn
                          });
                          Navigator.pop(context);
                        },
                        child: Text("Done", style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                  Divider(),

                  // Danh sách giới tính
                  Expanded(
                    child: ListView.builder(
                      itemCount: genderOptions.length,
                      itemBuilder: (context, index) {
                        String gender = genderOptions[index];
                        return ListTile(
                          title: Text(gender),
                          trailing: tempSelectedGender == gender
                              ? Icon(Icons.check, color: Colors.redAccent)
                              : null,
                          onTap: () {
                            setStateBottomSheet(() {
                              tempSelectedGender = gender;
                            });
                          },
                        );
                      },
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
        GestureDetector(
          onTap: () => _showGenderSelectionSheet(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white, // Đổi background thành màu trắng
            ),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedGender ?? "Select Gender",
                  style: TextStyle(
                    color: selectedGender == null ? Colors.grey : Colors.black,
                    fontSize: 16
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
