import 'package:flutter/material.dart';

class GenderSelection extends StatefulWidget {
  final String? initialGender;
  final ValueChanged<String>? onChanged;

  const GenderSelection({
    super.key,
    this.initialGender,
    this.onChanged,
  });

  @override
  _GenderSelectionState createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {
  List<Map<String, String>> genderOptions = [
    {"label": "Male", "value": "male"},
    {"label": "Female", "value": "female"},
    {"label": "Non-binary", "value": "non-binary"},
    {"label": "Other", "value": "other"},
  ];
  String? selectedGender;

 @override
void didUpdateWidget(covariant GenderSelection oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (widget.initialGender != oldWidget.initialGender) {
    setState(() {
      selectedGender = widget.initialGender;
    });
  }
}

  void _showGenderSelectionSheet(BuildContext context) {
    String? tempSelectedGender = selectedGender;

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
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            // 🔥 Cập nhật lại UI sau khi chọn xong
                            selectedGender = tempSelectedGender;
                          });
                          widget.onChanged?.call(tempSelectedGender!);
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
                        String label = genderOptions[index]['label']!;
                        String value = genderOptions[index]['value']!;
                        return ListTile(
                          title: Text(label),
                          trailing: tempSelectedGender == value
                              ? Icon(Icons.check, color: Colors.redAccent)
                              : null,
                          onTap: () {
                            setStateBottomSheet(() {
                              tempSelectedGender = value;
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
    String selectedLabel = genderOptions.firstWhere(
      (gender) => gender['value'] == selectedGender,
      orElse: () => {"label": "Select Gender", "value": "unknown"},
    )['label']!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _showGenderSelectionSheet(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedLabel,
                  style: TextStyle(
                      color:
                          selectedGender == null ? Colors.grey : Colors.black,
                      fontSize: 16),
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
