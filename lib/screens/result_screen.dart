import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/personality_test_result.dart';
import '../models/personality_type.dart';
import '../services/local_storage_service.dart';
import '../widgets/result_card.dart';
import '../widgets/rounded_button.dart';
import '../widgets/section_title.dart';
import '../widgets/soft_card.dart';
import 'test_screen.dart';

class ResultScreen extends StatefulWidget {
  final PersonalityType resultType;
  final PersonalityTestResult testResult;

  const ResultScreen({
    super.key,
    required this.resultType,
    required this.testResult,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final LocalStorageService storageService = LocalStorageService();
  bool hasSavedResult = false;
  bool saveFailed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      saveResult();
    });
  }

  Future<void> saveResult() async {
    try {
      await storageService.savePersonalityTestResult(widget.testResult);
    } on Object {
      if (!mounted) return;

      setState(() {
        saveFailed = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('결과를 저장하지 못했지만 화면에서 바로 확인할 수 있어요.'),
        ),
      );
      return;
    }

    if (!mounted) return;

    setState(() {
      hasSavedResult = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('성향 테스트 결과가 저장되었어요.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resultType = widget.resultType;

    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 결과'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '나의 관계 성향 카드가\n완성됐어요',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 12),
              Text(
                '${resultType.name}의 핵심 요약을 먼저 보고, 아래에서 관계 팁을 자세히 살펴보세요.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 12),
              _SavedResultNotice(
                hasSavedResult: hasSavedResult,
                saveFailed: saveFailed,
              ),
              const SizedBox(height: 24),

              ResultCard(type: resultType),

              const SizedBox(height: 18),

              _AxisRatioCard(percentages: widget.testResult.axisPercentages),

              const SizedBox(height: 24),

              SectionTitle(
                title: '상세 관계 카드',
                description: '나의 특징과 관계 속 강점, 조심할 점을 나눠서 살펴봐요.',
              ),

              ResultDetailSection(
                icon: Icons.person_rounded,
                title: '나의 특징',
                items: resultType.traits,
                tone: SoftCardTone.surface,
              ),
              const SizedBox(height: 14),
              ResultDetailSection(
                icon: Icons.favorite_rounded,
                title: '관계에서의 강점',
                items: resultType.strengths,
                tone: SoftCardTone.sky,
              ),
              const SizedBox(height: 14),
              ResultDetailSection(
                icon: Icons.spa_rounded,
                title: '조심할 점',
                items: resultType.cautions,
                tone: SoftCardTone.lavender,
              ),
              const SizedBox(height: 14),
              ResultDetailSection(
                icon: Icons.groups_rounded,
                title: '잘 맞는 관계 방식',
                items: resultType.goodMatches,
                tone: SoftCardTone.peach,
              ),
              const SizedBox(height: 18),

              const SoftCard(
                tone: SoftCardTone.notice,
                hasShadow: false,
                child: Text('이 결과는 전문적인 심리 진단이 아닌, 일상 속 자기이해를 위한 참고용 결과입니다.'),
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
                variant: RoundedButtonVariant.secondary,
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AxisRatioCard extends StatelessWidget {
  final Map<String, int> percentages;

  const _AxisRatioCard({required this.percentages});

  @override
  Widget build(BuildContext context) {
    if (percentages.isEmpty) return const SizedBox.shrink();

    return SoftCard(
      tone: SoftCardTone.surface,
      hasShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.tune_rounded,
                color: AppColors.navy,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text('성향 축 비율', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 14),
          _AxisRatioRow(leftLabel: '외부 지향', rightLabel: '내부 지향', left: percentages['external'] ?? 50, right: percentages['internal'] ?? 50),
          _AxisRatioRow(leftLabel: '현실 감각', rightLabel: '가능성 탐색', left: percentages['realistic'] ?? 50, right: percentages['possibility'] ?? 50),
          _AxisRatioRow(leftLabel: '논리 판단', rightLabel: '관계 공감', left: percentages['logical'] ?? 50, right: percentages['relational'] ?? 50),
        ],
      ),
    );
  }
}

class _AxisRatioRow extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final int left;
  final int right;

  const _AxisRatioRow({required this.leftLabel, required this.rightLabel, required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$leftLabel $left% / $rightLabel $right%', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(value: left / 100, minHeight: 8, backgroundColor: AppColors.softBeige, color: AppColors.navy),
          ),
        ],
      ),
    );
  }
}

class _SavedResultNotice extends StatelessWidget {
  final bool hasSavedResult;
  final bool saveFailed;

  const _SavedResultNotice({
    required this.hasSavedResult,
    required this.saveFailed,
  });

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      tone: SoftCardTone.surface,
      hasShadow: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            hasSavedResult
                ? Icons.check_circle_rounded
                : saveFailed
                    ? Icons.info_outline_rounded
                    : Icons.sync_rounded,
            color: AppColors.textLight,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              hasSavedResult
                  ? '이 결과가 기기에 저장되었어요. 앱을 다시 열어도 최근 결과를 불러올 수 있어요.'
                  : saveFailed
                      ? '결과 저장은 실패했지만 지금 화면에서 결과를 확인할 수 있어요.'
                      : '결과를 기기에 저장하는 중이에요.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
