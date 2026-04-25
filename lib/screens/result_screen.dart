import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/personality_type.dart';
import '../widgets/result_card.dart';
import '../widgets/rounded_button.dart';
import '../widgets/section_title.dart';
import '../widgets/soft_card.dart';
import 'test_screen.dart';

class ResultScreen extends StatelessWidget {
  final PersonalityType resultType;

  const ResultScreen({
    super.key,
    required this.resultType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 결과'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '지금의 나와 가까운\n사이해 유형이에요',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 12),
            Text(
              '결과는 고정된 성격이 아니라, 현재 나를 이해하기 위한 참고용 가이드로 봐주세요.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),

            ResultCard(type: resultType),

            const SizedBox(height: 24),

            SectionTitle(
              title: '가까워지는 방법',
              description: '${resultType.name}과 편안하게 가까워지는 힌트예요.',
            ),

            SoftCard(
              backgroundColor: AppColors.softYellow,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: resultType.relationTips.map((tip) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.favorite_rounded,
                          size: 20,
                          color: AppColors.textDark,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            tip,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 18),

            SectionTitle(
              title: '조심하면 좋은 부분',
              description: '관계를 더 편안하게 만들기 위해 피하면 좋은 소통 방식이에요.',
            ),

            SoftCard(
              backgroundColor: AppColors.softBeige,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: resultType.avoidTips.map((tip) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.spa_rounded,
                          size: 20,
                          color: AppColors.textDark,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            tip,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            RoundedButton(
              text: '다시 테스트하기',
              icon: Icons.refresh_rounded,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TestScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            RoundedButton(
              text: '홈으로 돌아가기',
              icon: Icons.home_rounded,
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.textDark,
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}