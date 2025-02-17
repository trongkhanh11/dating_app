import 'package:flutter/material.dart';

class SexualOrientationSelection extends StatefulWidget {
  final String? initialOrientation;
  final ValueChanged<String>? onChanged;

  const SexualOrientationSelection({
    super.key,
    this.initialOrientation,
    this.onChanged,
  });

  @override
  _SexualOrientationSelectionState createState() =>
      _SexualOrientationSelectionState();
}

class _SexualOrientationSelectionState
    extends State<SexualOrientationSelection> {
  // final List<Map<String, String>> orientationOptions = [
  //   {"label": "Heterosexual", "value": "heterosexual"},
  //   {"label": "Homosexual", "value": "homosexual"},
  //   {"label": "Bisexual", "value": "bisexual"},
  //   {"label": "Asexual", "value": "asexual"},
  //   {"label": "Other", "value": "other"},
  //   {"label": "Undecided", "value": "undecided"},
  // ];
  List<Map<String, String>> orientationOptions = [
    {"label": "Male", "value": "male"},
    {"label": "Female", "value": "female"},
    {"label": "Non-binary", "value": "non-binary"},
    {"label": "Other", "value": "other"},
  ];

  String? selectedOrientation;

  @override
  void didUpdateWidget(covariant SexualOrientationSelection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialOrientation != oldWidget.initialOrientation) {
      setState(() {
        selectedOrientation = widget.initialOrientation;
      });
    }
  }

  void _showOrientationSelectionSheet(BuildContext context) {
    String? tempSelectedOrientation = selectedOrientation;

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
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        "Select Sexual Orientation",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedOrientation = tempSelectedOrientation;
                          });
                          widget.onChanged?.call(tempSelectedOrientation!);
                          Navigator.pop(context);
                        },
                        child: Text("Done", style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                  Divider(),

                  // Danh sách orientation
                  Expanded(
                    child: ListView.builder(
                      itemCount: orientationOptions.length,
                      itemBuilder: (context, index) {
                        String label = orientationOptions[index]['label']!;
                        String value = orientationOptions[index]['value']!;
                        return ListTile(
                          title: Text(label),
                          trailing: tempSelectedOrientation == value
                              ? Icon(Icons.check, color: Colors.redAccent)
                              : null,
                          onTap: () {
                            setStateBottomSheet(() {
                              tempSelectedOrientation = value;
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
    String? selectedLabel = orientationOptions.firstWhere(
      (option) => option['value'] == selectedOrientation,
      orElse: () => {'label': "Select Sexual Orientation"},
    )['label'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _showOrientationSelectionSheet(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent),
            ),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedLabel ?? "Select Sexual Orientation",
                  style: TextStyle(
                    color: selectedOrientation == null
                        ? Colors.grey
                        : Colors.black,
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
