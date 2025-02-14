import 'package:flutter/material.dart';

class SexualOrientationSelection extends StatefulWidget {
  @override
  _SexualOrientationSelectionState createState() => _SexualOrientationSelectionState();
}

class _SexualOrientationSelectionState extends State<SexualOrientationSelection> {
  List<String> orientationOptions = [
    "Heterosexual",
    "Homosexual",
    "Bisexual",
    "Asexual",
    "Other",
    "Undecided"
  ];

  String? selectedOrientation;

  void _showOrientationSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
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
                    "Select Sexual Orientation",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 48),
                ],
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: orientationOptions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(orientationOptions[index]),
                      trailing: selectedOrientation == orientationOptions[index]
                          ? Icon(Icons.check, color: Colors.redAccent)
                          : null,
                      onTap: () {
                        setState(() {
                          selectedOrientation = orientationOptions[index];
                        });
                        Navigator.pop(context);
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
  }

  @override
  Widget build(BuildContext context) {
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
                  selectedOrientation ?? "Select Sexual Orientation",
                  style: TextStyle(
                    color: selectedOrientation == null ? Colors.grey : Colors.black,fontSize: 16
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
