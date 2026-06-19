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
          Align(
            alignment: Alignment.centerRight,
            child: _Tag(text: 'SAIHAE TYPE CARD'),
          ),
          const SizedBox(height: AppSpacing.md),
          _PersonalityCardImage(typeId: type.id, fallbackIcon: icon),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  type.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _MaterialIconBadge(icon: icon),
            ],
          ),
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

class _PersonalityCardImage extends StatelessWidget {
  final String typeId;
  final IconData fallbackIcon;

  const _PersonalityCardImage({
    required this.typeId,
    required this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final imageHeight =
            (constraints.maxWidth * 0.62).clamp(168.0, 230.0).toDouble();

        return Container(
          width: double.infinity,
          height: imageHeight,
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: context.palette.card.withValues(alpha: 0.62),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: context.palette.line.withValues(alpha: 0.62),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              'images/personality_cards/$typeId.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return _PersonalityImageFallback(icon: fallbackIcon);
              },
            ),
          ),
        );
      },
    );
  }
}

class _PersonalityImageFallback extends StatelessWidget {
  final IconData icon;

  const _PersonalityImageFallback({required this.icon});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.palette.cardMuted.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Icon(
          icon,
          color: context.palette.primary,
          size: 54,
        ),
      ),
    );
  }
}

class _MaterialIconBadge extends StatelessWidget {
  final IconData icon;

  const _MaterialIconBadge({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: context.palette.card.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: context.palette.line.withValues(alpha: 0.58),
        ),
      ),
      child: Icon(icon, color: context.palette.primary, size: 21),
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
