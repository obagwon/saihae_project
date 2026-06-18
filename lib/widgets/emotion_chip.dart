import 'package:flutter/material.dart';

import '../app/theme.dart';

class EmotionChip extends StatelessWidget {
  final String emoji;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const EmotionChip({
    super.key,
    required this.emoji,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isSelected
        ? palette.primary
        : palette.card.withValues(alpha: isDark ? 0.78 : 0.72);
    final textColor = isSelected
        ? (isDark ? AppColors.textDark : AppColors.white)
        : palette.textSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.chip),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppRadii.chip),
          border: Border.all(
            color: isSelected ? palette.primary : palette.line,
          ),
        ),
        child: Text(
          '$emoji $label',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: textColor,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
              ),
        ),
      ),
    );
  }
}
