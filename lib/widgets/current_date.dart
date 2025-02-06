import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dating_app/providers/locale_provider.dart';

class CurrentDate extends StatelessWidget {
  const CurrentDate({super.key});
  @override
  Widget build(BuildContext context) {
    // Get the current date
    final localeProvider = Provider.of<LocaleProvider>(context);
    DateTime now = DateTime.now();
    String formattedDate =
        DateFormat('EEEE, MMM dd', localeProvider.locale.toString())
            .format(now);
    return Text(
      formattedDate,
      style: const TextStyle(
          fontFamily: "Epilogue",
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Color(0xFF818991)),
    );
  }
}
