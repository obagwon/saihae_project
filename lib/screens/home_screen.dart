import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/emotion_data.dart';
import '../data/tip_data.dart';
import '../widgets/decorative.dart';
import '../widgets/emotion_chip.dart';
import '../widgets/rounded_button.dart';
import '../widgets/soft_card.dart';
import 'test_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedEmotionIndex = 1;

  @override
  Widget build(BuildContext context) {
    final selectedEmotion = emotionGuides[selectedEmotionIndex];
    final todayTip = mentalTips[DateTime.now().day % mentalTips.length];

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '오늘의 나는 어떤 마음일까?',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -.4,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '잠깐 멈춰서 지금의 나를 살펴봐요.',
                    style: TextStyle(color: AppColors.textBrown, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            IconButton.filled(
              style: IconButton.styleFrom(backgroundColor: AppColors.white, foregroundColor: AppColors.textDark),
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 18),
        SoftCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('오늘의 감정 체크', style: Theme.of(context).textTheme.titleMedium),
                  const Spacer(),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textDark),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 9,
                children: List.generate(emotionGuides.length, (index) {
                  final emotion = emotionGuides[index];
                  return EmotionChip(
                    emoji: emotion.emoji,
                    label: emotion.name,
                    isSelected: selectedEmotionIndex == index,
                    onTap: () => setState(() => selectedEmotionIndex = index),
                  );
                }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SoftCard(
          padding: const EdgeInsets.all(17),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bubble(
                color: AppColors.lavender,
                size: 58,
                child: Text(selectedEmotion.emoji, style: const TextStyle(fontSize: 26)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: selectedEmotion.name, style: const TextStyle(color: AppColors.blushDark)),
                          const TextSpan(text: '를 선택했어요.'),
                        ],
                      ),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(selectedEmotion.message, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    Text(selectedEmotion.tip, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SoftCard(
          backgroundColor: AppColors.softYellow.withOpacity(.78),
          padding: const EdgeInsets.all(17),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('오늘의 회복 팁 🌿', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(todayTip.message, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 7),
                    Text(todayTip.action, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w900)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(color: AppColors.white.withOpacity(.58), borderRadius: BorderRadius.circular(22)),
                child: const Icon(Icons.local_cafe_rounded, color: AppColors.blushDark, size: 38),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SoftCard(
          padding: const EdgeInsets.all(17),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('나의 사이해 유형', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 7),
                    Text('나를 더 이해하고, 관계를 더 편하게.', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: 154,
                      child: RoundedButton(
                        text: '테스트 시작하기',
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TestScreen())),
                      ),
                    ),
                  ],
                ),
              ),
              const SpeechLogo(size: 68),
            ],
          ),
        ),
      ],
    );
  }
}
