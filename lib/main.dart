import 'dart:io';

import 'package:aquatic_xpress_shipping/helper/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aquatic_xpress_shipping/models/GeneralProvider.dart';
import 'package:aquatic_xpress_shipping/screens/auth/splash/splash_screen.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GeneralProvider()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: Consumer<ThemeNotifier>(
          builder: (context, ThemeNotifier notifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Aquatic Xpress Shipping',
          theme: notifier.darkMode ? darkMode : lightMode,
          home: SplashScreenView(),
        );
      }),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
