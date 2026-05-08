import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/personality_data.dart';
import '../models/personality_type.dart';
import '../widgets/decorative.dart';
import '../widgets/soft_card.dart';

class RelationGuideScreen extends StatelessWidget {
  const RelationGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('관계 가이드', style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 7),
                  Text('따뜻한 공감형의 관계 팁', style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
            const SpeechLogo(size: 54, compact: true),
          ],
        ),
        const SizedBox(height: 18),
        _GuideTile(icon: '💗', title: '잘 맞는 사람', subtitle: '고마움을 표현할 줄 아는 사람'),
        _GuideTile(icon: '🌱', title: '친해지는 방법', subtitle: '작은 관심과 따뜻한 리액션으로 가까워져요'),
        _GuideTile(icon: '☁️', title: '조심할 점', subtitle: '내 마음을 뒤로 미루지 않기'),
        const SizedBox(height: 18),
        Row(
          children: [
            Text('유형별 관계 힌트', style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            Text('전체 보기 >', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 10),
        ...personalityTypes.map((type) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _RelationTypeCard(type: type),
            )),
      ],
    );
  }
}

class _GuideTile extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;

  const _GuideTile({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: SoftCard(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 3),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}

class _RelationTypeCard extends StatelessWidget {
  final PersonalityType type;

  const _RelationTypeCard({required this.type});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.all(15),
      backgroundColor: AppColors.white.withOpacity(.95),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(type.name, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 5),
          Text(type.subtitle, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 10),
          Text(type.relationTips.first, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
