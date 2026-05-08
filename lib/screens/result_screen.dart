import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/personality_type.dart';
import '../widgets/decorative.dart';
import '../widgets/result_card.dart';
import '../widgets/rounded_button.dart';
import '../widgets/soft_card.dart';
import 'test_screen.dart';

class ResultScreen extends StatelessWidget {
  final PersonalityType resultType;

  const ResultScreen({super.key, required this.resultType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WarmGradientBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
            children: [
              Row(
                children: [
                  IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.popUntil(context, (route) => route.isFirst)),
                  Expanded(
                    child: Text('나의 사이해 유형은\n${resultType.name}이에요', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
                  ),
                  IconButton(icon: const Icon(Icons.ios_share_rounded), onPressed: () {}),
                ],
              ),
              const SizedBox(height: 16),
              ResultCard(type: resultType),
              const SizedBox(height: 16),
              _TipList(title: '가까워지는 방법', icon: Icons.favorite_rounded, tips: resultType.relationTips),
              const SizedBox(height: 14),
              _TipList(title: '조심하면 좋은 점', icon: Icons.cloud_rounded, tips: resultType.avoidTips, backgroundColor: AppColors.softPeach.withOpacity(.76)),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(child: RoundedButton(text: '관계 가이드 보기', outlined: true, onPressed: () => Navigator.popUntil(context, (route) => route.isFirst))),
                  const SizedBox(width: 12),
                  Expanded(
                    child: RoundedButton(
                      text: '결과 저장하기',
                      onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              RoundedButton(
                text: '다시 테스트하기',
                icon: Icons.refresh_rounded,
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.textDark,
                outlined: true,
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TestScreen())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TipList extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> tips;
  final Color? backgroundColor;

  const _TipList({required this.title, required this.icon, required this.tips, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      backgroundColor: backgroundColor ?? AppColors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...tips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, size: 18, color: AppColors.blush),
                    const SizedBox(width: 9),
                    Expanded(child: Text(tip, style: Theme.of(context).textTheme.bodyMedium)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
