import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/personality_data.dart';
import '../widgets/decorative.dart';
import '../widgets/result_card.dart';
import '../widgets/rounded_button.dart';
import '../widgets/soft_card.dart';
import 'test_screen.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final previewType = personalityTypes.first;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
      children: [
        Text('나의 사이해 유형 알아보기', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 8),
        Text('가벼운 질문으로 관계 스타일과 회복 포인트를 살펴봐요.', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 18),
        SoftCard(
          child: Row(
            children: [
              const SpeechLogo(size: 74),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('사이해 성향 테스트', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text('12문항 이내의 짧은 흐름으로 나에게 잘 맞는 관계 힌트를 알려드려요.', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 14),
                    RoundedButton(text: '테스트 시작하기', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TestScreen()))),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SoftCard(
          backgroundColor: AppColors.softYellow.withOpacity(.7),
          hasShadow: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lightbulb_rounded, color: AppColors.blush, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text('결과는 전문 진단이 아닌 자기이해 참고 콘텐츠예요. 오늘의 나를 부드럽게 해석하는 데 사용해 주세요.', style: Theme.of(context).textTheme.bodyMedium)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text('결과 미리보기', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        ResultCard(type: previewType),
      ],
    );
  }
}
