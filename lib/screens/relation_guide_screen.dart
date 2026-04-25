import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/personality_data.dart';
import '../models/personality_type.dart';
import '../widgets/section_title.dart';
import '../widgets/soft_card.dart';

class RelationGuideScreen extends StatelessWidget {
  const RelationGuideScreen({super.key});

  Color _getCardColor(int index) {
    final colors = [
      AppColors.softYellow,
      AppColors.softPink,
      AppColors.softPeach,
      AppColors.softBeige,
      AppColors.white,
    ];

    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      itemCount: personalityTypes.length + 1,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '사람마다 가까워지는\n속도는 달라요',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 12),
              Text(
                '상대의 성향을 이해하면 관계를 조금 더 편안하게 시작할 수 있어요.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
            ],
          );
        }

        final type = personalityTypes[index - 1];

        return _RelationTypeCard(
          type: type,
          backgroundColor: _getCardColor(index - 1),
        );
      },
    );
  }
}

class _RelationTypeCard extends StatelessWidget {
  final PersonalityType type;
  final Color backgroundColor;

  const _RelationTypeCard({
    required this.type,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      backgroundColor: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            type.subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),

          _MiniSection(
            icon: Icons.favorite_rounded,
            title: '이런 사람과 잘 맞아요',
            items: type.goodMatches,
          ),

          const SizedBox(height: 16),

          _MiniSection(
            icon: Icons.tips_and_updates_rounded,
            title: '친해지는 방법',
            items: type.relationTips,
          ),

          const SizedBox(height: 16),

          _MiniSection(
            icon: Icons.spa_rounded,
            title: '조심하면 좋은 부분',
            items: type.avoidTips,
          ),
        ],
      ),
    );
  }
}

class _MiniSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> items;

  const _MiniSection({
    required this.icon,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.62),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 21,
                color: AppColors.textDark,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...items.map(
                (item) => Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• '),
                  Expanded(
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}