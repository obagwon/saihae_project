import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/emotion_data.dart';
import '../data/personality_data.dart';
import '../data/tip_data.dart';
import '../models/emotion_record.dart';
import '../models/personality_test_result.dart';
import '../models/personality_type.dart';
import '../services/local_storage_service.dart';
import '../widgets/emotion_chip.dart';
import '../widgets/rounded_button.dart';
import '../widgets/section_title.dart';
import '../widgets/soft_card.dart';
import 'test_screen.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<String> onStartRecord;
  final VoidCallback? onOpenAnalysis;
  final VoidCallback? onOpenRelationGuide;

  const HomeScreen({
    super.key,
    required this.onStartRecord,
    this.onOpenAnalysis,
    this.onOpenRelationGuide,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalStorageService storageService = LocalStorageService();

  int? selectedEmotionIndex;
  PersonalityTestResult? savedResult;
  PersonalityType? savedType;
  EmotionRecord? todayEmotionRecord;
  bool isLoadingHomeData = true;
  bool isRecheckingEmotion = false;

  @override
  void initState() {
    super.initState();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    final result = await storageService.getPersonalityTestResult();
    final records = await storageService.getEmotionRecords();
    final type = result == null
        ? null
        : personalityTypes.firstWhere(
            (type) => type.id == result.typeId,
            orElse: () => personalityTypes.first,
          );
    final todayRecord = findLatestTodayEmotionRecord(records);

    if (!mounted) return;

    setState(() {
      savedResult = result;
      savedType = type;
      todayEmotionRecord = todayRecord;
      isLoadingHomeData = false;
      if (todayRecord != null) {
        isRecheckingEmotion = false;
      }
    });
  }

  EmotionRecord? findLatestTodayEmotionRecord(List<EmotionRecord> records) {
    final now = DateTime.now();
    final todayRecords = records.where((record) {
      final createdAt = record.createdAt;
      return createdAt.year == now.year &&
          createdAt.month == now.month &&
          createdAt.day == now.day;
    }).toList();

    if (todayRecords.isEmpty) {
      return null;
    }

    todayRecords.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return todayRecords.first;
  }

  Future<void> startTest() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TestScreen()),
    );

    if (!mounted) return;
    await loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    final selectedEmotion = selectedEmotionIndex == null
        ? null
        : emotionGuides[selectedEmotionIndex!];
    final todayTip = mentalTips[DateTime.now().day % mentalTips.length];
    final hasResult = savedType != null && savedResult != null;
    final shouldShowEmotionPicker =
        todayEmotionRecord == null || isRecheckingEmotion;

    return RefreshIndicator(
      onRefresh: loadHomeData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(
              title: '오늘의 마음 체크',
              description: todayEmotionRecord == null
                  ? '지금 마음을 가볍게 골라보고 기록으로 이어가보세요.'
                  : '오늘 남긴 마음을 확인하고, 달라졌다면 다시 골라볼 수 있어요.',
            ),
            shouldShowEmotionPicker
                ? _EmotionDashboardCard(
                    selectedEmotionIndex: selectedEmotionIndex,
                    selectedEmotion: selectedEmotion,
                    onSelected: (index) {
                      setState(() => selectedEmotionIndex = index);
                    },
                    onStartRecord: widget.onStartRecord,
                  )
                : _TodayEmotionCompleteCard(
                    record: todayEmotionRecord!,
                    onRecheck: () {
                      setState(() {
                        selectedEmotionIndex = null;
                        isRecheckingEmotion = true;
                      });
                    },
                  ),
            const SizedBox(height: AppSpacing.xl),
            _HomeHeader(hasResult: hasResult, type: savedType),
            const SizedBox(height: AppSpacing.xl),
            _MainTestCard(
              hasResult: hasResult,
              type: savedType,
              onStartTest: startTest,
              onOpenResult: widget.onOpenAnalysis,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (hasResult) ...[
              _RecentResultCard(
                type: savedType!,
                onTap: widget.onOpenAnalysis,
              ),
              const SizedBox(height: AppSpacing.lg),
            ] else if (isLoadingHomeData) ...[
              const _LoadingResultCard(),
              const SizedBox(height: AppSpacing.lg),
            ],
            Row(
              children: [
                Expanded(
                  child: _ShortcutCard(
                    icon: Icons.compare_arrows_rounded,
                    title: '관계 비교',
                    description: '나와 상대의 차이를 살펴봐요.',
                    tone: SoftCardTone.sky,
                    onTap: widget.onOpenRelationGuide,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _ShortcutCard(
                    icon: Icons.style_rounded,
                    title: '유형 보기',
                    description: '모든 관계 카드를 둘러봐요.',
                    tone: SoftCardTone.lavender,
                    onTap: widget.onOpenRelationGuide,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            _DailyTipCard(
              tipTitle: todayTip.title,
              message: todayTip.message,
              action: todayTip.action,
            ),
            const SizedBox(height: AppSpacing.lg),
            const _SafetyNotice(),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final bool hasResult;
  final PersonalityType? type;

  const _HomeHeader({required this.hasResult, required this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SAIHAE CARD',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.dustyRose,
                letterSpacing: 2.4,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          hasResult ? '나의 관계 카드를\n다시 살펴볼까요?' : '오늘의 관계 온도를\n가볍게 살펴볼까요?',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          hasResult && type != null
              ? '${type!.name} 결과를 바탕으로 관계 팁과 기록을 이어갈 수 있어요.'
              : '짧은 질문으로 나의 관계 방식과 잘 맞는 소통 스타일을 카드처럼 정리해요.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class _MainTestCard extends StatelessWidget {
  final bool hasResult;
  final PersonalityType? type;
  final VoidCallback onStartTest;
  final VoidCallback? onOpenResult;

  const _MainTestCard({
    required this.hasResult,
    required this.type,
    required this.onStartTest,
    required this.onOpenResult,
  });

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      tone: SoftCardTone.hero,
      borderRadius: AppRadii.heroCard,
      padding: const EdgeInsets.all(26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _IconBadge(icon: Icons.favorite_rounded, backgroundColor: AppColors.blush),
              const Spacer(),
              _PillLabel(text: hasResult ? '최근 결과 있음' : '메인 기능'),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            hasResult ? '관계 성향 다시 보기' : '관계 성향 테스트',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            hasResult && type != null
                ? '${type!.subtitle}\n필요하면 다시 테스트해 지금의 나를 업데이트해보세요.'
                : '질문에 답하면 나의 관계 스타일, 강점, 조심할 점을 따뜻한 카드로 보여드려요.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (hasResult) ...[
            Row(
              children: [
                Expanded(
                  child: RoundedButton(
                    text: '결과 보기',
                    icon: Icons.style_rounded,
                    onPressed: onOpenResult,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: RoundedButton(
                    text: '다시 테스트',
                    icon: Icons.refresh_rounded,
                    variant: RoundedButtonVariant.secondary,
                    onPressed: onStartTest,
                  ),
                ),
              ],
            ),
          ] else
            RoundedButton(
              text: '테스트 시작하기',
              icon: Icons.arrow_forward_rounded,
              onPressed: onStartTest,
            ),
        ],
      ),
    );
  }
}

class _RecentResultCard extends StatelessWidget {
  final PersonalityType type;
  final VoidCallback? onTap;

  const _RecentResultCard({required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      tone: SoftCardTone.blush,
      hasShadow: false,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBadge(icon: Icons.auto_awesome_rounded, backgroundColor: context.palette.card),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('최근 나의 카드', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: AppSpacing.xxs),
                Text(type.name, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppSpacing.xxs),
                Text(type.subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
        ],
      ),
    );
  }
}

class _LoadingResultCard extends StatelessWidget {
  const _LoadingResultCard();

  @override
  Widget build(BuildContext context) {
    return const SoftCard(
      tone: SoftCardTone.notice,
      hasShadow: false,
      child: LinearProgressIndicator(minHeight: 4),
    );
  }
}

class _ShortcutCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final SoftCardTone tone;
  final VoidCallback? onTap;

  const _ShortcutCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.tone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      tone: tone,
      padding: const EdgeInsets.all(AppSpacing.md),
      borderRadius: AppRadii.compactCard,
      hasShadow: false,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBadge(icon: icon, backgroundColor: context.palette.card),
          const SizedBox(height: AppSpacing.sm),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xxs),
          Text(description, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _EmotionDashboardCard extends StatelessWidget {
  final int? selectedEmotionIndex;
  final EmotionGuide? selectedEmotion;
  final ValueChanged<int> onSelected;
  final ValueChanged<String> onStartRecord;

  const _EmotionDashboardCard({
    required this.selectedEmotionIndex,
    required this.selectedEmotion,
    required this.onSelected,
    required this.onStartRecord,
  });

  @override
  Widget build(BuildContext context) {
    final selectedEmotion = this.selectedEmotion;

    return SoftCard(
      tone: SoftCardTone.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: List.generate(emotionGuides.length, (index) {
              final emotion = emotionGuides[index];
              return EmotionChip(
                emoji: emotion.emoji,
                label: emotion.name,
                isSelected: selectedEmotionIndex == index,
                onTap: () => onSelected(index),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.lg),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: selectedEmotion == null
                ? Text(
                    '감정을 선택하면 지금 마음에 맞는 안내와 기록 버튼이 보여요.',
                    key: const ValueKey('empty'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                : Column(
                    key: ValueKey(selectedEmotion.id),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${selectedEmotion.emoji} ${selectedEmotion.name}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(selectedEmotion.message, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: AppSpacing.sm),
                      RoundedButton(
                        text: '이 감정으로 기록하기',
                        icon: Icons.edit_note_rounded,
                        variant: RoundedButtonVariant.tonal,
                        onPressed: () => onStartRecord(selectedEmotion.id),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _TodayEmotionCompleteCard extends StatelessWidget {
  final EmotionRecord record;
  final VoidCallback onRecheck;

  const _TodayEmotionCompleteCard({
    required this.record,
    required this.onRecheck,
  });

  EmotionGuide? get _matchedGuide {
    for (final guide in emotionGuides) {
      if (guide.id == record.emotionId) {
        return guide;
      }
    }

    return null;
  }

  String get _todayMoodMessage => '오늘은 ${record.emotionLabel}에 가까운 상태예요.';

  String get _oneLineTip {
    final tip = _matchedGuide?.tip.trim();
    if (tip != null && tip.isNotEmpty) {
      return tip;
    }

    return '지금 떠오르는 마음을 한 문장으로 가볍게 남겨보세요.';
  }

  String get _supportingMessage {
    switch (record.emotionId) {
      case 'calm':
        return '차분한 흐름을 이어가기 좋은 작은 루틴과 잘 맞아요.';
      case 'excited':
        return '기대되는 마음을 오늘 해볼 수 있는 작은 행동으로 옮겨보세요.';
      case 'tired':
        return '큰 계획보다 잠깐 쉬어가는 선택이 잘 맞을 수 있어요.';
      case 'complicated':
        return '생각을 바로 정리하려 하기보다 천천히 펼쳐보는 시간이 어울려요.';
      case 'anxious':
        return '마음의 속도를 조금 낮추고 지금 할 수 있는 것부터 살펴보세요.';
      case 'lethargic':
        return '가장 쉬운 행동 하나만 골라도 오늘의 시작이 될 수 있어요.';
      default:
        return '오늘의 마음을 조용히 알아차린 것만으로도 충분할 수 있어요.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      tone: SoftCardTone.blush,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: context.palette.card.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  record.emoji,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '오늘 체크 완료',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: context.palette.primary,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      _todayMoodMessage,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              _PillLabel(text: '기록됨'),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            _supportingMessage,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: context.palette.card.withValues(alpha: 0.68),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: context.palette.line.withValues(alpha: 0.58),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: context.palette.primary,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    _oneLineTip,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onRecheck,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('다시 체크하기'),
              style: TextButton.styleFrom(
                foregroundColor: context.palette.textSecondary,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyTipCard extends StatelessWidget {
  final String tipTitle;
  final String message;
  final String action;

  const _DailyTipCard({required this.tipTitle, required this.message, required this.action});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      tone: SoftCardTone.sky,
      hasShadow: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBadge(icon: Icons.tips_and_updates_rounded, backgroundColor: context.palette.card),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tipTitle, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xxs),
                Text(message, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(action, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SafetyNotice extends StatelessWidget {
  const _SafetyNotice();

  @override
  Widget build(BuildContext context) {
    return const SoftCard(
      tone: SoftCardTone.notice,
      hasShadow: false,
      padding: EdgeInsets.all(AppSpacing.md),
      child: Text('사이해는 전문적인 심리 진단을 대신하는 목적이 아닌, 일상 속 자기이해를 돕는 참고용 서비스예요.'),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;

  const _IconBadge({required this.icon, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final resolvedBackground = backgroundColor;

    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: resolvedBackground.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Icon(icon, color: context.palette.primary),
    );
  }
}

class _PillLabel extends StatelessWidget {
  final String text;

  const _PillLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: context.palette.card.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(AppRadii.chip),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: context.palette.primary,
            ),
      ),
    );
  }
}
