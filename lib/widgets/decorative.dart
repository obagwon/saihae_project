import 'package:flutter/material.dart';

import '../app/theme.dart';

class WarmGradientBackground extends StatelessWidget {
  final Widget child;

  const WarmGradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.cream, Color(0xFFFFF4E7), Color(0xFFFFFAF3)],
        ),
      ),
      child: Stack(
        children: [
          const Positioned(top: 28, right: 26, child: Sparkle(size: 18)),
          const Positioned(top: 96, left: 22, child: Sparkle(size: 12, color: AppColors.softYellow)),
          const Positioned(bottom: 112, right: 36, child: Sparkle(size: 14)),
          Positioned(
            right: -54,
            top: 185,
            child: _GlowCircle(color: AppColors.softPink.withOpacity(0.20), size: 170),
          ),
          Positioned(
            left: -62,
            bottom: 90,
            child: _GlowCircle(color: AppColors.softYellow.withOpacity(0.20), size: 160),
          ),
          child,
        ],
      ),
    );
  }
}

class Sparkle extends StatelessWidget {
  final double size;
  final Color color;

  const Sparkle({super.key, this.size = 16, this.color = AppColors.softYellow});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.auto_awesome_rounded, color: color, size: size);
  }
}

class _GlowCircle extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class SpeechLogo extends StatelessWidget {
  final double size;
  final bool compact;

  const SpeechLogo({super.key, this.size = 74, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.35,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            top: size * 0.1,
            child: Bubble(color: AppColors.softPink, size: size * .74),
          ),
          Positioned(
            right: 0,
            top: size * 0.05,
            child: Bubble(color: AppColors.softYellow, size: size * .74),
          ),
          Positioned.fill(
            child: Center(
              child: Container(
                width: compact ? size * .22 : size * .34,
                height: compact ? size * .22 : size * .34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(size),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blush.withOpacity(.16),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Icon(Icons.favorite_rounded, color: AppColors.blush, size: compact ? size * .14 : size * .22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Bubble extends StatelessWidget {
  final Color color;
  final double size;
  final Widget? child;

  const Bubble({super.key, required this.color, required this.size, this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BubblePainter(color),
      child: SizedBox(width: size, height: size, child: Center(child: child)),
    );
  }
}

class _BubblePainter extends CustomPainter {
  final Color color;

  const _BubblePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawCircle(Offset(size.width * .5, size.height * .45), size.width * .43, paint);
    final path = Path()
      ..moveTo(size.width * .22, size.height * .72)
      ..lineTo(size.width * .10, size.height * .94)
      ..quadraticBezierTo(size.width * .34, size.height * .88, size.width * .42, size.height * .78)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BubblePainter oldDelegate) => oldDelegate.color != color;
}
