import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatCurrency(String amount) {
  final NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'en_US', // Change locale as needed, e.g., 'en_IN' for Indian Rupees
    symbol: '\$', // Change symbol as needed, e.g., '₹' for INR
  );
  double value = double.parse(amount);
  return currencyFormatter.format(value);
}

String formatDate(DateTime date, Locale locale) {
  final DateFormat formatter = DateFormat('MMM dd, yyyy', locale.toString());
  return formatter.format(date);
}


