import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/personality_type.dart';
import 'soft_card.dart';

class ResultCard extends StatelessWidget {
  final PersonalityType type;

  const ResultCard({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      backgroundColor: AppColors.softPeach,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '나의 사이해 유형',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Text(
            type.name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            type.subtitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Text(
            type.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),

          _ResultInfoBlock(
            title: '나의 강점',
            items: type.strengths,
          ),

          const SizedBox(height: 16),

          _ResultInfoBlock(
            title: '스트레스 받을 때',
            items: type.stressPatterns,
          ),

          const SizedBox(height: 16),

          _ResultInfoBlock(
            title: '잘 맞는 사람',
            items: type.goodMatches,
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.textDark,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    type.dailyAction,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultInfoBlock extends StatelessWidget {
  final String title;
  final List<String> items;

  const _ResultInfoBlock({
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...items.map(
                (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
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