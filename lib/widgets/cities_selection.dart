import 'package:flutter/material.dart';

class CityDropdownField extends StatefulWidget {
  @override
  _CityDropdownFieldState createState() => _CityDropdownFieldState();
}

class _CityDropdownFieldState extends State<CityDropdownField> {
  List<String> cities = [
    "Hanoi",
    "Ho Chi Minh City",
    "Da Nang",
    "Hai Phong",
    "Nha Trang",
    "Can Tho",
    "Hue",
    "Vung Tau"
  ];
  String? selectedCity;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: selectedCity,
          hint: Text("Select a city"),
          items: cities.map((city) {
            return DropdownMenuItem(
              value: city,
              child: Text(city),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCity = value;
            });
          },
         // style: TextStyle(fontSize: 16),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide.none),
          //  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
 
        ),
      ],
    );
  }
}
