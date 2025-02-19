import 'package:flutter/material.dart';

class LanguageSelection extends StatefulWidget {
  final List<String>? initialLanguages;
  final ValueChanged<List<String>>? onChanged;

  const LanguageSelection({
    super.key,
    this.initialLanguages,
    this.onChanged,
  });

  @override
  _LanguageSelectionState createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  List<Map<String, String>> languageOptions = [
    {"label": "English", "value": "english"},
    {"label": "Vietnamese", "value": "vietnamese"},
    {"label": "French", "value": "french"},
    {"label": "Spanish", "value": "spanish"},
  ];
  List<String> selectedLanguages = [];

  @override
  void initState() {
    super.initState();
    selectedLanguages = widget.initialLanguages ?? [];
  }

  void _showLanguageSelectionSheet(BuildContext context) {
    List<String> tempSelectedLanguages = List.from(selectedLanguages);

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
                        "Select Languages",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedLanguages = tempSelectedLanguages;
                          });
                          widget.onChanged?.call(tempSelectedLanguages);
                          Navigator.pop(context);
                        },
                        child: Text("Done", style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: languageOptions.length,
                      itemBuilder: (context, index) {
                        String label = languageOptions[index]['label']!;
                        String value = languageOptions[index]['value']!;
                        bool isSelected = tempSelectedLanguages.contains(value);
                        return ListTile(
                          title: Text(label),
                          trailing: isSelected
                              ? Icon(Icons.check, color: Colors.redAccent)
                              : null,
                          onTap: () {
                            setStateBottomSheet(() {
                              if (isSelected) {
                                tempSelectedLanguages.remove(value);
                              } else {
                                tempSelectedLanguages.add(value);
                              }
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
    String selectedLabels = selectedLanguages
        .map((lang) => languageOptions.firstWhere((option) => option['value'] == lang, orElse: () => {"label": "Unknown"})['label']!)
        .join(", ");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _showLanguageSelectionSheet(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedLabels.isEmpty ? "Select Languages" : selectedLabels,
                    style: TextStyle(
                        color: selectedLabels.isEmpty ? Colors.grey : Colors.black,
                        fontSize: 16),
                    overflow: TextOverflow.ellipsis,
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