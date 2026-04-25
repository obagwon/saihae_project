import 'package:flutter/material.dart';

import '../app/theme.dart';
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

  void _onTapBottomItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getTitle() {
    switch (_selectedIndex) {
      case 0:
        return '사이해';
      case 1:
        return '나 분석';
      case 2:
        return '관계 가이드';
      case 3:
        return '기록';
      default:
        return '사이해';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTapBottomItem,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded),
              label: '나 분석',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_rounded),
              label: '관계',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_note_rounded),
              label: '기록',
            ),
          ],
        ),
      ),
    );
  }
}