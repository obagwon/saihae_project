import 'package:flutter/material.dart';

import '../app/theme.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const RoundedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? AppColors.textDark,
      foregroundColor: foregroundColor ?? AppColors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      textStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    );

    if (icon == null) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: style,
          child: Text(text),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: style,
        icon: Icon(icon, size: 20),
        label: Text(text),
      ),
    );
  }
}