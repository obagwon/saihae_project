import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/emotion_data.dart';
import '../data/tip_data.dart';
import '../widgets/emotion_chip.dart';
import '../widgets/rounded_button.dart';
import '../widgets/section_title.dart';
import '../widgets/soft_card.dart';
import 'test_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedEmotionIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selectedEmotion = emotionGuides[selectedEmotionIndex];
    final todayTip = mentalTips[DateTime.now().day % mentalTips.length];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '오늘의 나를\n조금 더 부드럽게 이해해볼까요?',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 12),
          Text(
            '사이해는 나의 감정, 성향, 관계 스타일을 가볍게 돌아보는 자기이해 가이드 앱이에요.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),

          SoftCard(
            backgroundColor: AppColors.softPink,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _IconBadge(
                  icon: Icons.mood_rounded,
                  backgroundColor: Colors.white.withOpacity(0.75),
                ),
                const SizedBox(height: 16),
                Text(
                  '오늘의 감정 체크',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '지금 내 마음에 가장 가까운 감정을 골라보세요.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    emotionGuides.length,
                        (index) {
                      final emotion = emotionGuides[index];

                      return EmotionChip(
                        emoji: emotion.emoji,
                        label: emotion.name,
                        isSelected: selectedEmotionIndex == index,
                        onTap: () {
                          setState(() {
                            selectedEmotionIndex = index;
                          });
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.72),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${selectedEmotion.emoji} ${selectedEmotion.name}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        selectedEmotion.message,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        selectedEmotion.tip,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          SectionTitle(
            title: '오늘의 작은 회복',
            description: '지금의 나에게 필요한 아주 작은 실천을 골라봤어요.',
          ),

          SoftCard(
            backgroundColor: AppColors.softYellow,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _IconBadge(
                  icon: Icons.auto_awesome_rounded,
                  backgroundColor: Colors.white.withOpacity(0.75),
                ),
                const SizedBox(height: 16),
                Text(
                  todayTip.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  todayTip.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.textDark,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          todayTip.action,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          SectionTitle(
            title: '나를 더 알고 싶다면',
            description: '짧은 질문으로 나의 관계 스타일을 가볍게 알아볼 수 있어요.',
          ),

          SoftCard(
            backgroundColor: AppColors.softPeach,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _IconBadge(
                  icon: Icons.favorite_rounded,
                  backgroundColor: Colors.white.withOpacity(0.75),
                ),
                const SizedBox(height: 16),
                Text(
                  '사이해 성향 테스트',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '나의 성향, 스트레스 반응, 잘 맞는 사람의 특징을 참고용으로 확인해보세요.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),
                RoundedButton(
                  text: '테스트 시작하기',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TestScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          SoftCard(
            backgroundColor: AppColors.white,
            hasShadow: false,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.textLight,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '사이해는 전문적인 심리 진단이나 치료 목적이 아닌, 일상 속 자기이해를 돕는 참고용 서비스예요.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;

  const _IconBadge({
    required this.icon,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        icon,
        color: AppColors.textDark,
      ),
    );
  }
}