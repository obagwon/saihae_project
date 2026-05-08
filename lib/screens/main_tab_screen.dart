import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../widgets/decorative.dart';
import 'analysis_screen.dart';
import 'home_screen.dart';
import 'record_screen.dart';
import 'relation_guide_screen.dart';

class MainTabScreen extends StatefulWidget {
  const MainTabScreen({super.key});

  @override
  State<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends State<MainTabScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    AnalysisScreen(),
    RelationGuideScreen(),
    RecordScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WarmGradientBackground(
        child: SafeArea(
          bottom: false,
          child: _screens[_selectedIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(.96),
          border: const Border(top: BorderSide(color: AppColors.line)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9B6D55).withOpacity(0.10),
              blurRadius: 18,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: '오늘'),
              BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: '알아보기'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite_border_rounded), label: '관계'),
              BottomNavigationBarItem(icon: Icon(Icons.article_rounded), label: '기록'),
            ],
          ),
        ),
      ),
    );
  }
}
