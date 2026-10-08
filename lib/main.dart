import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MYNJO Cash',
      theme: AppTheme.lightTheme,
      home: const TelaLogin(),
    );
  }
}
