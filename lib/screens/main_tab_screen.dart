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
  String? _initialRecordEmotionId;

  void _onTapBottomItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _startRecordFromHome(String emotionId) {
    setState(() {
      _selectedIndex = 3;
      _initialRecordEmotionId = emotionId;
    });
  }

  void _clearInitialRecordEmotion() {
    if (_initialRecordEmotionId == null) return;

    setState(() {
      _initialRecordEmotionId = null;
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
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(onStartRecord: _startRecordFromHome),
          const AnalysisScreen(),
          const RelationGuideScreen(),
          RecordScreen(
            initialEmotionId: _initialRecordEmotionId,
            onInitialEmotionConsumed: _clearInitialRecordEmotion,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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