import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/recommendation_item.dart';
import 'soft_card.dart';

class RecommendationCard extends StatelessWidget {
  final RecommendationItem recommendation;

  const RecommendationCard({
    super.key,
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      tone: SoftCardTone.peach,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: context.palette.card.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: context.palette.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recommendation.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      recommendation.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.palette.card.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              recommendation.actionText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          if (recommendation.personalityNote != null) ...[
            const SizedBox(height: 12),
            Text(
              recommendation.personalityNote!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          if (recommendation.safetyNote != null) ...[
            const SizedBox(height: 12),
            Text(
              recommendation.safetyNote!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.palette.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
