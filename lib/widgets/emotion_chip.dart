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
    final backgroundColor =
    isSelected ? AppColors.textDark : AppColors.softPink.withOpacity(0.65);

    final textColor = isSelected ? AppColors.white : AppColors.textBrown;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? AppColors.textDark
                : AppColors.softPink.withOpacity(0.4),
          ),
        ),
        child: Text(
          '$emoji $label',
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}