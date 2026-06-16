import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../screens/main_tab_screen.dart';
import '../screens/onboarding_screen.dart';
import '../services/local_storage_service.dart';
import 'theme.dart';

class SaihaeApp extends StatelessWidget {
  const SaihaeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '사이해',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const _AppStartupGate(),
    );
  }
}

class _AppStartupGate extends StatefulWidget {
  const _AppStartupGate();

  @override
  State<_AppStartupGate> createState() => _AppStartupGateState();
}

class _AppStartupGateState extends State<_AppStartupGate> {
  final LocalStorageService storageService = LocalStorageService();
  late Future<AppSettings> settingsFuture;
  bool onboardingCompletedInSession = false;

  @override
  void initState() {
    super.initState();
    settingsFuture = storageService.getAppSettings();
  }

  void handleOnboardingCompleted() {
    setState(() {
      onboardingCompletedInSession = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (onboardingCompletedInSession) {
      return const MainTabScreen();
    }

    return FutureBuilder<AppSettings>(
      future: settingsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _StartupLoadingScreen();
        }

        final settings = snapshot.data ?? const AppSettings.initial();
        final completed =
            settings.onboardingCompleted && settings.disclaimerAccepted;

        if (completed) {
          return const MainTabScreen();
        }

        return OnboardingScreen(
          onCompleted: handleOnboardingCompleted,
        );
      },
    );
  }
}

class _StartupLoadingScreen extends StatelessWidget {
  const _StartupLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
