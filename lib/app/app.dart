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
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const _StartupSplashGate(),
    );
  }
}

class _StartupSplashGate extends StatefulWidget {
  const _StartupSplashGate();

  @override
  State<_StartupSplashGate> createState() => _StartupSplashGateState();
}

class _StartupSplashGateState extends State<_StartupSplashGate> {
  static const _splashDuration = Duration(milliseconds: 1400);

  var _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(_splashDuration, () {
      if (!mounted) {
        return;
      }

      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return const _FirstScreenSplash();
    }

    return const MainTabScreen();
  }
}

class _FirstScreenSplash extends StatelessWidget {
  const _FirstScreenSplash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFFFF8F2),
      body: SizedBox.expand(
        child: Image(
          image: AssetImage('images/first_screen.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
