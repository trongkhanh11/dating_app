import 'package:flutter/material.dart';

class CityDropdownField extends StatefulWidget {
  final String? initialCity;
  final ValueChanged<String>? onChanged;

  const CityDropdownField({
    super.key,
    this.initialCity,
    this.onChanged,
  });

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
  void didUpdateWidget(covariant CityDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCity != oldWidget.initialCity) {
      setState(() {
        selectedCity = widget.initialCity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: selectedCity ??
              widget.initialCity, // Đảm bảo luôn lấy giá trị mới nhất
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
            if (value != null) {
              widget.onChanged?.call(value);
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide.none),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }
}
