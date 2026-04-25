import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/personality_data.dart';
import '../widgets/result_card.dart';
import '../widgets/rounded_button.dart';
import '../widgets/section_title.dart';
import '../widgets/soft_card.dart';
import 'test_screen.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final previewType = personalityTypes.first;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '나의 성향을\n가볍게 알아봐요',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 12),
          Text(
            '정답이 있는 검사가 아니라, 지금의 나를 더 잘 이해하기 위한 참고용 질문들이에요.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),

          SoftCard(
            backgroundColor: AppColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.psychology_alt_rounded,
                  size: 42,
                  color: AppColors.textDark,
                ),
                const SizedBox(height: 16),
                Text(
                  '사이해 성향 테스트',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '짧은 질문에 답하면 나의 관계 스타일, 스트레스 반응, 잘 맞는 사람의 특징을 알려드릴게요.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
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
            backgroundColor: AppColors.softBeige,
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
                    '사이해의 결과는 전문적인 심리 진단이 아니라, 스스로를 돌아보기 위한 참고용 가이드예요.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          SectionTitle(
            title: '결과는 이런 식으로 보여요',
            description: '테스트를 완료하면 나의 성향 카드와 관계 힌트를 확인할 수 있어요.',
          ),

          ResultCard(type: previewType),
        ],
      ),
    );
  }
}