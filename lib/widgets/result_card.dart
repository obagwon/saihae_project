import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/personality_type.dart';
import 'decorative.dart';
import 'soft_card.dart';

class ResultCard extends StatelessWidget {
  final PersonalityType type;

  const ResultCard({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFF8796), Color(0xFFFFB0A7)],
              ),
            ),
            child: Stack(
              children: [
                const Positioned(right: 14, top: 4, child: Sparkle(size: 13, color: Colors.white)),
                Positioned(right: -8, bottom: -8, child: _MascotBadge(typeName: type.name)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('나의 사이해 유형', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(.9))),
                    const SizedBox(height: 8),
                    Text(type.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 210,
                      child: Text(type.subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _InfoRow(icon: Icons.lightbulb_rounded, title: '유형 설명', text: type.description),
                _Divider(),
                _ChipRow(title: '강점', icon: Icons.person_rounded, items: type.strengths.take(3).toList()),
                _Divider(),
                _InfoRow(icon: Icons.water_drop_rounded, title: '스트레스 반응', text: type.stressPatterns.first),
                _Divider(),
                _InfoRow(icon: Icons.favorite_rounded, title: '잘 맞는 사람', text: type.goodMatches.first),
                _Divider(),
                _InfoRow(icon: Icons.star_rounded, title: '오늘의 추천 행동', text: type.dailyAction),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MascotBadge extends StatelessWidget {
  final String typeName;

  const _MascotBadge({required this.typeName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: 82,
      decoration: BoxDecoration(color: AppColors.cream.withOpacity(.9), shape: BoxShape.circle),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.volunteer_activism_rounded, color: AppColors.blush, size: 28),
          const SizedBox(height: 3),
          Text(typeName.characters.take(2).toString(), style: const TextStyle(color: AppColors.textBrown, fontSize: 10, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _InfoRow({required this.icon, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.blush, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 5),
              Text(text, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChipRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<String> items;

  const _ChipRow({required this.icon, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.blush, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children: items
                    .map((item) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: AppColors.softPink.withOpacity(.55), borderRadius: BorderRadius.circular(99)),
                          child: Text(item.replaceAll('어요.', '어요'), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textBrown)),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 13),
      child: Divider(height: 1, color: AppColors.line),
    );
  }
}
