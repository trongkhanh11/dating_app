import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  final double minAge;
  final double maxAge;
  final double distance;

  const FilterScreen({
    super.key,
    required this.minAge,
    required this.maxAge,
    required this.distance,
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late double _minAge;
  late double _maxAge;
  late double _distance;

  @override
  void initState() {
    super.initState();
    _minAge = widget.minAge;
    _maxAge = widget.maxAge;
    _distance = widget.distance;
  }

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
          const Text(
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
              Navigator.pop(context, {
                'minAge': _minAge,
                'maxAge': _maxAge,
                'distance': _distance,
              });
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: const Text(
              "Apply",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
