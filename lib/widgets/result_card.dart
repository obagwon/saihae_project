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
      tone: SoftCardTone.hero,
      borderRadius: AppRadii.heroCard,
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: context.palette.card.withValues(alpha: 0.78),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, color: context.palette.primary, size: 28),
              ),
              const Spacer(),
              _Tag(text: 'SAIHAE TYPE CARD'),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(type.name, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(type.subtitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          Text(type.description, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: type.traits
                .take(3)
                .map((trait) => _Tag(text: trait))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class ResultDetailSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> items;
  final SoftCardTone tone;

  const ResultDetailSection({
    super.key,
    required this.icon,
    required this.title,
    required this.items,
    this.tone = SoftCardTone.surface,
  });

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      tone: tone,
      hasShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: context.palette.primary, size: 22),
              const SizedBox(width: AppSpacing.xs),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: context.palette.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
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

class _Tag extends StatelessWidget {
  final String text;

  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: context.palette.card.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(AppRadii.chip),
        border: Border.all(color: context.palette.line.withValues(alpha: 0.7)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: context.palette.primary,
            ),
      ),
    );
  }
}
