import 'package:dating_app/presentation/authentication/login/login_screen.dart';
import 'package:dating_app/providers/auth_provider.dart';
import 'package:dating_app/providers/profile_provider.dart';
import 'package:dating_app/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dating_app/providers/locale_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
        theme: AppTheme.appTheme,
        locale: localeProvider.locale, // Set default locale to Vietnamese
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('vi'), // Vietnamese
        ],
        debugShowCheckedModeBanner: false,
        home: const LoginScreen());
  }
}
