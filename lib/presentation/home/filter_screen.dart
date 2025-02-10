import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  double _minAge = 18;
  double _maxAge = 35;
  double _distance = 10;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Filter",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text("Age: ${_minAge.round()} - ${_maxAge.round()}"),
          RangeSlider(
            values: RangeValues(_minAge, _maxAge),
            min: 18,
            max: 50,
            divisions: 32,
            onChanged: (RangeValues values) {
              setState(() {
                _minAge = values.start;
                _maxAge = values.end;
              });
            },
          ),
          const SizedBox(height: 20),
          Text("Distance: ${_distance.round()} km"),
          Slider(
            value: _distance,
            min: 1,
            max: 100,
            divisions: 99,
            label: "${_distance.round()} km",
            onChanged: (value) {
              setState(() {
                _distance = value;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              "Apply",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
