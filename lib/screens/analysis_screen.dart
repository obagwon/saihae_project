import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/personality_data.dart';
import '../models/personality_test_result.dart';
import '../models/personality_type.dart';
import '../services/local_storage_service.dart';
import '../widgets/result_card.dart';
import '../widgets/rounded_button.dart';
import '../widgets/section_title.dart';
import '../widgets/soft_card.dart';
import 'test_screen.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final LocalStorageService storageService = LocalStorageService();

  PersonalityTestResult? savedResult;
  PersonalityType? savedType;
  bool isLoading = true;
  bool isReloading = false;

  @override
  void initState() {
    super.initState();
    loadSavedResult();
  }

  Future<void> loadSavedResult() async {
    if (isReloading) return;

    isReloading = true;
    final result = await storageService.getPersonalityTestResult();
    final type = _findPersonalityType(result?.typeId);

    if (!mounted) return;

    final hasChanged = !_isSameResult(savedResult, result) ||
        savedType?.id != type?.id ||
        isLoading;

    if (!hasChanged) {
      isReloading = false;
      return;
    }

    setState(() {
      savedResult = result;
      savedType = type;
      isLoading = false;
      isReloading = false;
    });
  }

  bool _isSameResult(
    PersonalityTestResult? current,
    PersonalityTestResult? next,
  ) {
    if (current == null || next == null) {
      return current == null && next == null;
    }

    return current.typeId == next.typeId &&
        current.testedAt == next.testedAt &&
        _isSameScores(current.scores, next.scores);
  }

  bool _isSameScores(Map<String, int> current, Map<String, int> next) {
    if (current.length != next.length) return false;

    for (final entry in current.entries) {
      if (next[entry.key] != entry.value) {
        return false;
      }
    }

    return true;
  }

  PersonalityType? _findPersonalityType(String? typeId) {
    if (typeId == null) return null;

    for (final type in personalityTypes) {
      if (type.id == typeId) {
        return type;
      }
    }

    return null;
  }

  Future<void> startTest() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TestScreen(),
      ),
    );

    if (!mounted) return;

    await loadSavedResult();
  }

  String formatDate(DateTime dateTime) {
    return '${dateTime.year}.${_twoDigits(dateTime.month)}.${_twoDigits(dateTime.day)}';
  }

  String _twoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      loadSavedResult();
    });

    final hasSavedResult = savedResult != null && savedType != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hasSavedResult ? '나의 성향을\n다시 확인해봐요' : '나의 성향을\n가볍게 알아봐요',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 12),
          Text(
            hasSavedResult
                ? '저장된 최근 테스트 결과를 바탕으로 지금의 나를 돌아볼 수 있어요.'
                : '정답이 있는 검사가 아니라, 지금의 나를 더 잘 이해하기 위한 참고용 질문들이에요.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),

          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            )
          else if (hasSavedResult)
            _SavedAnalysisContent(
              result: savedResult!,
              type: savedType!,
              testedAtText: formatDate(savedResult!.testedAt),
              onRestartTest: startTest,
            )
          else
            _EmptyAnalysisContent(onStartTest: startTest),
        ],
      ),
    );
  }
}

class _SavedAnalysisContent extends StatelessWidget {
  final PersonalityTestResult result;
  final PersonalityType type;
  final String testedAtText;
  final VoidCallback onRestartTest;

  const _SavedAnalysisContent({
    required this.result,
    required this.type,
    required this.testedAtText,
    required this.onRestartTest,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SoftCard(
          backgroundColor: AppColors.sky.withValues(alpha: 0.75),
          hasShadow: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.navy,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '최근 테스트 날짜: $testedAtText',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        ResultCard(type: type),
        const SizedBox(height: 18),
        _ScoreSummary(scores: result.axisPercentages),
        const SizedBox(height: 22),
        RoundedButton(
          text: '다시 테스트하기',
          icon: Icons.refresh_rounded,
          onPressed: onRestartTest,
        ),
        const SizedBox(height: 22),
        _GuideNotice(),
      ],
    );
  }
}

class _EmptyAnalysisContent extends StatelessWidget {
  final VoidCallback onStartTest;

  const _EmptyAnalysisContent({required this.onStartTest});

  @override
  Widget build(BuildContext context) {
    final previewType = personalityTypes.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SoftCard(
          backgroundColor: AppColors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.psychology_alt_rounded,
                size: 42,
                color: AppColors.navy,
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
                onPressed: onStartTest,
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        _GuideNotice(),
        const SizedBox(height: 24),
        SectionTitle(
          title: '결과는 이런 식으로 보여요',
          description: '테스트를 완료하면 나의 성향 카드와 관계 힌트를 확인할 수 있어요.',
        ),
        ResultCard(type: previewType),
      ],
    );
  }
}

class _ScoreSummary extends StatelessWidget {
  final Map<String, int> scores;

  const _ScoreSummary({required this.scores});

  String _labelFor(String key) {
    const labels = {
      'external': '외부 지향',
      'internal': '내부 지향',
      'realistic': '현실 감각',
      'possibility': '가능성 탐색',
      'logical': '논리 판단',
      'relational': '관계 공감',
    };
    return labels[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    if (scores.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortedScores = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return SoftCard(
      backgroundColor: AppColors.white,
      hasShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '성향 축 비율',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ...sortedScores.map((entry) {
            final label = _labelFor(entry.key);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    '${entry.value}%',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _GuideNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SoftCard(
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
    );
  }
}
