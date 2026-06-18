import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/personality_type.dart';
import 'soft_card.dart';

class ResultCard extends StatelessWidget {
  final PersonalityType type;

  const ResultCard({super.key, required this.type});

  IconData get icon {
    switch (type.icon) {
      case IconDataCode.compass:
        return Icons.explore_rounded;
      case IconDataCode.heart:
        return Icons.favorite_rounded;
      case IconDataCode.spark:
        return Icons.auto_awesome_rounded;
      case IconDataCode.rainbow:
        return Icons.wb_sunny_rounded;
      case IconDataCode.anchor:
        return Icons.anchor_rounded;
      case IconDataCode.nest:
        return Icons.spa_rounded;
      case IconDataCode.moon:
        return Icons.nightlight_round;
      case IconDataCode.lantern:
        return Icons.emoji_objects_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      backgroundColor: AppColors.blush,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.78),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: AppColors.navy),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '나의 사이해 유형',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.navy,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(type.name, style: Theme.of(context).textTheme.headlineMedium),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(type.subtitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Text(type.description, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          _ResultInfoBlock(title: '대표 특징', items: type.traits),
          const SizedBox(height: 16),
          _ResultInfoBlock(title: '잘하는 점', items: type.strengths),
          const SizedBox(height: 16),
          _ResultInfoBlock(title: '주의하면 좋은 점', items: type.cautions),
          const SizedBox(height: 16),
          _SingleInfoBlock(title: '편안함을 느끼는 상황', text: type.comfortZone),
          const SizedBox(height: 16),
          _SingleInfoBlock(title: '관계에서의 모습', text: type.relationshipStyle),
          const SizedBox(height: 16),
          _ResultInfoBlock(title: '추천 활동', items: type.recommendedActivities),
          const SizedBox(height: 20),
          _DailyAction(text: type.dailyAction),
        ],
      ),
    );
  }
}

class _SingleInfoBlock extends StatelessWidget {
  final String title;
  final String text;
  const _SingleInfoBlock({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return _InfoContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _DailyAction extends StatelessWidget {
  final String text;
  const _DailyAction({required this.text});

  @override
  Widget build(BuildContext context) {
    return _InfoContainer(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_awesome_rounded, color: AppColors.textDark, size: 22),
          const SizedBox(width: 10),
          Expanded(child: Text('오늘의 작은 제안: $text', style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _ResultInfoBlock extends StatelessWidget {
  final String title;
  final List<String> items;
  const _ResultInfoBlock({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return _InfoContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: const BoxDecoration(
                        color: AppColors.navy,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _InfoContainer extends StatelessWidget {
  final Widget child;
  const _InfoContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.68),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.7)),
      ),
      child: child,
    );
  }
}
