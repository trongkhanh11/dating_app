// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AppTheme {
//   static final Color _iconColor = Colors.blueAccent.shade200;
//   static const Color _lightPrimaryColor = Color(0xFF0A64C7);
//   static const Color _lightPrimaryVariantColor = Color(0xFF546E7A);
//   static const Color _lightSecondaryColor = Colors.green;
//   static const Color _lightOnPrimaryColor = Colors.black;
//   static const Color _lightOnBackground = Color(0xFFCDCDCD);

//   static const Color _darkPrimaryColor = Colors.white24;
//   static const Color _darkPrimaryVariantColor = Colors.black;
//   static const Color _darkSecondaryColor = Colors.white;
//   static const Color _darkOnPrimaryColor = Colors.white;
//   static const Color _darkOnBackground = Colors.white;

//   static final ThemeData lightTheme = ThemeData(
//       appBarTheme: const AppBarTheme(
//         titleTextStyle: TextStyle(
//             color: _darkSecondaryColor,
//             fontFamily: "Roboto",
//             fontWeight: FontWeight.bold,
//             fontSize: 26),
//         color: _lightPrimaryVariantColor,
//         iconTheme: IconThemeData(color: _lightOnPrimaryColor),
//       ),
//       colorScheme: const ColorScheme.light(
//         primary: _lightPrimaryColor,
//         primaryContainer: _lightPrimaryVariantColor,
//         secondary: _lightSecondaryColor,
//         onPrimary: _lightOnPrimaryColor,
//         onSurface: _lightOnBackground,
//       ),
//       iconTheme: IconThemeData(
//         color: _iconColor,
//       ),
//       textTheme: _lightTextTheme,
//       dividerTheme: DividerThemeData(color: Colors.black12));

//   static final ThemeData darkTheme = ThemeData(
//       scaffoldBackgroundColor: _darkPrimaryVariantColor,
//       appBarTheme: const AppBarTheme(
//         color: _darkPrimaryVariantColor,
//         iconTheme: IconThemeData(color: _darkOnPrimaryColor),
//       ),
//       colorScheme: const ColorScheme.dark(
//         primary: _darkPrimaryColor,
//         primaryContainer: _darkPrimaryVariantColor,
//         secondary: _darkSecondaryColor,
//         onPrimary: _darkOnPrimaryColor,
//         onSurface: _darkOnBackground,
//       ),
//       iconTheme: IconThemeData(
//         color: _iconColor,
//       ),
//       textTheme: _darkTextTheme,
//       dividerTheme: DividerThemeData(color: Colors.black));

//   static final TextTheme _lightTextTheme = TextTheme(
//       titleMedium: _lightScreenHeading1TextStyle,
//       labelLarge: _largeTitleHeaderStyle);

//   static final TextTheme _darkTextTheme = TextTheme(
//       titleMedium: _darkScreenHeading1TextStyle,
//       labelLarge: _largeTitleHeaderStyle);

//   static final TextStyle _largeTitleHeaderStyle = TextStyle(
//       fontSize: 20.0,
//       fontWeight: FontWeight.bold,
//       color: _lightPrimaryColor,
//       fontFamily: "Roboto");

//   static final TextStyle _lightScreenHeading1TextStyle = TextStyle(
//       fontSize: 26.0,
//       fontWeight: FontWeight.bold,
//       color: _lightOnPrimaryColor,
//       fontFamily: "Roboto");

//   static final TextStyle _darkScreenHeading1TextStyle =
//       _lightScreenHeading1TextStyle.copyWith(color: _darkOnPrimaryColor);
// }
