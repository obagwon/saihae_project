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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.softPink.withOpacity(.9) : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? AppColors.blush : AppColors.line, width: isSelected ? 1.4 : 1),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9B6D55).withOpacity(.07),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 15)),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 5),
              const Icon(Icons.check_circle_rounded, color: AppColors.blush, size: 15),
            ],
          ],
        ),
      ),
    );
  }
}
