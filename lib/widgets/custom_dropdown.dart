import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String labelText;
  //final IconData icon;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;

  const CustomDropdown({
    required this.labelText,
    //required this.icon,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            color: Colors.blueGrey,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              //prefixIcon: Icon(icon, color: Colors.blueGrey),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(16.0),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            items: items.map((String item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item, style: const TextStyle(color: Colors.blue)),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
