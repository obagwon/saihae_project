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
              Icon(
                Icons.check_circle_rounded,
                color: context.palette.primary,
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
          backgroundColor: context.palette.card,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.psychology_alt_rounded,
                size: 42,
                color: context.palette.primary,
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

  static const List<_AxisPairSpec> _axisPairs = [
    _AxisPairSpec(
      leftKey: 'external',
      leftLabel: '외부 지향',
      leftIcon: Icons.groups_rounded,
      rightKey: 'internal',
      rightLabel: '내부 지향',
      rightIcon: Icons.self_improvement_rounded,
    ),
    _AxisPairSpec(
      leftKey: 'realistic',
      leftLabel: '현실 감각',
      leftIcon: Icons.task_alt_rounded,
      rightKey: 'possibility',
      rightLabel: '가능성 탐색',
      rightIcon: Icons.auto_awesome_rounded,
    ),
    _AxisPairSpec(
      leftKey: 'logical',
      leftLabel: '논리 판단',
      leftIcon: Icons.psychology_rounded,
      rightKey: 'relational',
      rightLabel: '관계 공감',
      rightIcon: Icons.favorite_rounded,
    ),
  ];

  List<_AxisPairData> _buildPairData() {
    return _axisPairs
        .map(_pairDataFor)
        .whereType<_AxisPairData>()
        .toList();
  }

  _AxisPairData? _pairDataFor(_AxisPairSpec spec) {
    final leftValue = _normalizedValue(scores[spec.leftKey]);
    final rightValue = _normalizedValue(scores[spec.rightKey]);

    if (leftValue == null && rightValue == null) {
      return null;
    }

    if (leftValue == null) {
      return _AxisPairData(
        spec: spec,
        leftPercent: 100 - rightValue!,
        rightPercent: rightValue,
      );
    }

    if (rightValue == null) {
      return _AxisPairData(
        spec: spec,
        leftPercent: leftValue,
        rightPercent: 100 - leftValue,
      );
    }

    final total = leftValue + rightValue;
    if (total <= 0) {
      return null;
    }

    final normalizedLeft = ((leftValue / total) * 100).round();
    return _AxisPairData(
      spec: spec,
      leftPercent: normalizedLeft,
      rightPercent: 100 - normalizedLeft,
    );
  }

  int? _normalizedValue(int? value) {
    if (value == null) return null;
    return value.clamp(0, 100).toInt();
  }

  @override
  Widget build(BuildContext context) {
    final pairData = _buildPairData();

    return SoftCard(
      backgroundColor: context.palette.card,
      hasShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: context.palette.sky.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: context.palette.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '성향 축 흐름',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '익숙한 방향을 참고용 비율로 살펴봐요.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (pairData.isEmpty)
            Text(
              '아직 표시할 성향 축 비율이 없어요. '
              '테스트를 마치면 흐름을 부드럽게 보여드릴게요.',
              style: Theme.of(context).textTheme.bodyMedium,
            )
          else
            ...pairData.map(
              (data) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _AxisPairBar(data: data),
              ),
            ),
        ],
      ),
    );
  }
}

class _AxisPairData {
  final _AxisPairSpec spec;
  final int leftPercent;
  final int rightPercent;

  const _AxisPairData({
    required this.spec,
    required this.leftPercent,
    required this.rightPercent,
  });
}

class _AxisPairSpec {
  final String leftKey;
  final String leftLabel;
  final IconData leftIcon;
  final String rightKey;
  final String rightLabel;
  final IconData rightIcon;

  const _AxisPairSpec({
    required this.leftKey,
    required this.leftLabel,
    required this.leftIcon,
    required this.rightKey,
    required this.rightLabel,
    required this.rightIcon,
  });
}

class _AxisPairBar extends StatelessWidget {
  final _AxisPairData data;

  const _AxisPairBar({required this.data});

  @override
  Widget build(BuildContext context) {
    final leftColor = context.palette.primary;
    final rightColor = context.palette.accent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _AxisSideLabel(
                icon: data.spec.leftIcon,
                label: data.spec.leftLabel,
                percent: data.leftPercent,
                color: leftColor,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _AxisSideLabel(
                icon: data.spec.rightIcon,
                label: data.spec.rightLabel,
                percent: data.rightPercent,
                color: rightColor,
                alignEnd: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadii.chip),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: context.palette.line.withValues(alpha: 0.58),
                      borderRadius: BorderRadius.circular(AppRadii.chip),
                    ),
                  ),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOutCubic,
                        width: constraints.maxWidth * data.leftPercent / 100,
                        height: 12,
                        decoration: BoxDecoration(
                          color: leftColor.withValues(alpha: 0.86),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOutCubic,
                        width: constraints.maxWidth * data.rightPercent / 100,
                        height: 12,
                        decoration: BoxDecoration(
                          color: rightColor.withValues(alpha: 0.86),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AxisSideLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final int percent;
  final Color color;
  final bool alignEnd;

  const _AxisSideLabel({
    required this.icon,
    required this.label,
    required this.percent,
    required this.color,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    final labelText = Flexible(
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        textAlign: alignEnd ? TextAlign.right : TextAlign.left,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: context.palette.textPrimary,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
    final percentText = Text(
      '$percent%',
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w800,
          ),
    );
    final children = [
      Icon(icon, color: color, size: 17),
      const SizedBox(width: 6),
      labelText,
      const SizedBox(width: 5),
      percentText,
    ];
    final endAlignedChildren = [
      percentText,
      const SizedBox(width: 5),
      labelText,
      const SizedBox(width: 6),
      Icon(icon, color: color, size: 17),
    ];

    return Row(
      mainAxisAlignment:
          alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: alignEnd ? endAlignedChildren : children,
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
