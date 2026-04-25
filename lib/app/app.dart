import 'package:flutter/material.dart';

import '../screens/main_tab_screen.dart';
import 'theme.dart';

class SaihaeApp extends StatelessWidget {
  const SaihaeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '사이해',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainTabScreen(),
    );
  }
}