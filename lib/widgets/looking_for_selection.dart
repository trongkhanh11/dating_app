import 'package:flutter/material.dart';

class LookingForSelection extends StatefulWidget {
  final String? initialSelection;
  final ValueChanged<String>? onChanged;

  const LookingForSelection({
    super.key,
    this.initialSelection,
    this.onChanged,
  });

  @override
  _LookingForSelectionState createState() => _LookingForSelectionState();
}

class _LookingForSelectionState extends State<LookingForSelection> {
  List<Map<String, String>> lookingForOptions = [
    {"label": "Lover", "value": "lover"},
    {"label": "Long-term Relationship", "value": "long_term"},
    {"label": "Anything is possible", "value": "any"},
    {"label": "Open Relationship", "value": "open"},
    {"label": "New friends", "value": "friends"},
    {"label": "I'm not so sure", "value": "other"},
  ];

  String? selectedLookingFor;

  @override
  void didUpdateWidget(covariant LookingForSelection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelection != oldWidget.initialSelection) {
      setState(() {
        selectedLookingFor = widget.initialSelection;
      });
    }
  }

  void _showLookingForSelectionSheet(BuildContext context) {
    String? tempSelected = selectedLookingFor;

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
              height: MediaQuery.of(context).size.height * 0.6,
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
                        "What are you looking for?",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedLookingFor = tempSelected;
                          });
                          widget.onChanged?.call(tempSelected!);
                          Navigator.pop(context);
                        },
                        child: Text("Done", style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: lookingForOptions.length,
                      itemBuilder: (context, index) {
                        String label = lookingForOptions[index]['label']!;
                        String value = lookingForOptions[index]['value']!;
                        return ListTile(
                          title: Text(label),
                          trailing: tempSelected == value
                              ? Icon(Icons.check, color: Colors.redAccent)
                              : null,
                          onTap: () {
                            setStateBottomSheet(() {
                              tempSelected = value;
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
    String selectedLabel = lookingForOptions.firstWhere(
      (item) => item['value'] == selectedLookingFor,
      orElse: () => {"label": "Select your purpose", "value": "unknown"},
    )['label']!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _showLookingForSelectionSheet(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.transparent),
              borderRadius: BorderRadius.circular(8)
              ,
            ),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedLabel,
                  style: TextStyle(
                    color:
                        selectedLookingFor == null ? Colors.grey : Colors.black,
                    fontSize: 16,
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
