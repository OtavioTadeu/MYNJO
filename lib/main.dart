import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dados/app_dados.dart';
import 'screens/login.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppDados()..iniciar(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MYNJO Cash',
        theme: AppTheme.lightTheme,
        home: const TelaLogin(),
      ),
    );
  }
}
