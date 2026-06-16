import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/emotion_data.dart';
import '../data/recommendation_data.dart';
import '../models/emotion_record.dart';
import '../models/personality_test_result.dart';
import '../services/emotion_stats_service.dart';
import '../services/local_storage_service.dart';
import '../widgets/emotion_chip.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/rounded_button.dart';
import '../widgets/section_title.dart';
import '../widgets/soft_card.dart';

class RecordScreen extends StatefulWidget {
  final String? initialEmotionId;
  final VoidCallback? onInitialEmotionConsumed;

  const RecordScreen({
    super.key,
    this.initialEmotionId,
    this.onInitialEmotionConsumed,
  });

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  static const int _defaultIntensity = 3;

  final TextEditingController memoController = TextEditingController();
  final LocalStorageService storageService = LocalStorageService();
  final EmotionStatsService statsService = const EmotionStatsService();

  int selectedEmotionIndex = 0;
  int selectedIntensity = _defaultIntensity;
  List<EmotionRecord> records = [];
  EmotionRecord? lastSavedRecord;
  PersonalityTestResult? personalityResult;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _applyInitialEmotionId(widget.initialEmotionId);
    loadRecords();
  }

  @override
  void didUpdateWidget(covariant RecordScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialEmotionId != oldWidget.initialEmotionId) {
      _applyInitialEmotionId(widget.initialEmotionId);
    }
  }

  @override
  void dispose() {
    memoController.dispose();
    super.dispose();
  }

  void _applyInitialEmotionId(String? emotionId) {
    if (emotionId == null) return;

    final index = emotionGuides.indexWhere((emotion) => emotion.id == emotionId);
    if (index == -1) return;

    selectedEmotionIndex = index;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      widget.onInitialEmotionConsumed?.call();
    });
  }

  Future<void> loadRecords() async {
    final loadedRecords = await storageService.getEmotionRecords();
    final loadedPersonalityResult =
        await storageService.getPersonalityTestResult();

    if (!mounted) return;

    setState(() {
      records = loadedRecords;
      personalityResult = loadedPersonalityResult;
      isLoading = false;
    });
  }

  Future<void> saveRecord() async {
    final selectedEmotion = emotionGuides[selectedEmotionIndex];
    final memo = memoController.text.trim();

    final newRecord = EmotionRecord(
      emotionId: selectedEmotion.id,
      emotionLabel: selectedEmotion.name,
      emoji: selectedEmotion.emoji,
      intensity: selectedIntensity,
      memo: memo,
      createdAt: DateTime.now(),
    );

    try {
      await storageService.saveEmotionRecord(newRecord);
    } on Object {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('기록을 저장하지 못했어요. 잠시 후 다시 시도해 주세요.'),
        ),
      );
      return;
    }

    if (!mounted) return;

    memoController.clear();
    setState(() {
      selectedEmotionIndex = 0;
      selectedIntensity = _defaultIntensity;
      lastSavedRecord = newRecord;
    });

    await loadRecords();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('오늘의 마음이 저장되었어요.'),
      ),
    );
  }

  Future<void> clearRecords() async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('기록을 모두 삭제할까요?'),
          content: const Text('삭제한 감정 기록은 다시 되돌릴 수 없어요.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );

    if (shouldClear != true || !mounted) return;

    try {
      await storageService.clearEmotionRecords();
    } on Object {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('기록을 삭제하지 못했어요. 잠시 후 다시 시도해 주세요.'),
        ),
      );
      return;
    }

    if (!mounted) return;

    await loadRecords();

    if (!mounted) return;

    setState(() {
      lastSavedRecord = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('기록이 모두 삭제되었어요.'),
      ),
    );
  }

  String formatDate(DateTime dateTime) {
    return '${dateTime.year}.${_twoDigits(dateTime.month)}.${_twoDigits(dateTime.day)}';
  }

  String _twoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    final selectedEmotion = emotionGuides[selectedEmotionIndex];
    final stats = statsService.calculate(records);
    final recommendationRecord = lastSavedRecord;
    final recommendation = RecommendationData.buildRecommendation(
      emotionId: recommendationRecord?.emotionId ?? selectedEmotion.id,
      intensity: recommendationRecord?.intensity ?? selectedIntensity,
      personalityTypeId: personalityResult?.typeId,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '오늘의 마음을\n짧게 남겨봐요',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 12),
          Text(
            '대단한 기록이 아니어도 괜찮아요. 오늘의 감정 하나와 강도, 짧은 문장만으로도 충분해요.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),

          SoftCard(
            backgroundColor: AppColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(
                  title: '지금 마음에 가까운 감정',
                  description: '오늘의 나와 가장 비슷한 감정을 골라주세요.',
                  margin: EdgeInsets.zero,
                ),
                const SizedBox(height: 16),

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
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.softPink.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${selectedEmotion.emoji} ${selectedEmotion.message}\n${selectedEmotion.tip}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),

                const SizedBox(height: 24),

                SectionTitle(
                  title: '감정 강도',
                  description: '1은 아주 약하게, 5는 아주 강하게 느껴지는 정도예요.',
                  margin: EdgeInsets.zero,
                ),
                const SizedBox(height: 14),

                _IntensitySelector(
                  selectedIntensity: selectedIntensity,
                  onSelected: (value) {
                    setState(() {
                      selectedIntensity = value;
                    });
                  },
                ),

                const SizedBox(height: 24),

                Text(
                  '오늘의 한 줄 회고',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: memoController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: '비워두어도 괜찮아요. 감정만 저장할 수도 있어요.',
                    hintStyle: Theme.of(context).textTheme.bodySmall,
                    filled: true,
                    fillColor: AppColors.cream,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                RoundedButton(
                  text: '기록 저장하기',
                  icon: Icons.save_rounded,
                  onPressed: saveRecord,
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),

          SectionTitle(
            title: '오늘의 추천',
            description: recommendationRecord == null
                ? '선택한 감정과 강도에 맞춘 작은 행동이에요.'
                : '방금 저장한 마음에 맞춰 작은 행동을 골라봤어요.',
          ),

          RecommendationCard(recommendation: recommendation),

          const SizedBox(height: 26),

          SectionTitle(
            title: '마음 기록 통계',
            description: '최근 기록에서 작게 반복되는 감정 패턴을 살펴봐요.',
          ),

          _EmotionStatsSection(
            stats: stats,
            isLoading: isLoading,
          ),

          const SizedBox(height: 26),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '최근 기록',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (records.isNotEmpty)
                TextButton(
                  onPressed: clearRecords,
                  child: const Text(
                    '전체 삭제',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            )
          else if (records.isEmpty)
            SoftCard(
              backgroundColor: AppColors.softYellow.withValues(alpha: 0.75),
              hasShadow: false,
              child: Text(
                '아직 저장된 기록이 없어요.\n오늘의 감정과 강도를 하나 남겨보세요.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          else
            Column(
              children: records.map((record) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _RecordItem(
                    record: record,
                    dateText: formatDate(record.createdAt),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _EmotionStatsSection extends StatelessWidget {
  final EmotionStats stats;
  final bool isLoading;

  const _EmotionStatsSection({
    required this.stats,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SoftCard(
        backgroundColor: AppColors.white,
        hasShadow: false,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (!stats.hasRecords) {
      return SoftCard(
        backgroundColor: AppColors.softYellow.withValues(alpha: 0.75),
        hasShadow: false,
        child: Text(
          '아직 통계가 없어요. 3일만 기록하면 작은 패턴을 볼 수 있어요.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return SoftCard(
      backgroundColor: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!stats.hasEnoughRecordsForPattern) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.softBeige.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                '아직 기록이 적어서 통계는 참고용으로만 봐주세요. 조금 더 쌓이면 패턴이 자연스럽게 보여요.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Row(
            children: [
              Expanded(
                child: _StatValueCard(
                  title: '전체 기록',
                  value: '${stats.totalRecordCount}회',
                  color: AppColors.softPink.withValues(alpha: 0.55),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatValueCard(
                  title: '이번 주',
                  value: '${stats.thisWeekRecordCount}회',
                  color: AppColors.softYellow.withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _StatValueCard(
                  title: '자주 나타난 감정',
                  value: _formatFrequentEmotion(stats.mostFrequentEmotion),
                  color: AppColors.softPeach.withValues(alpha: 0.55),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatValueCard(
                  title: '7일 평균 강도',
                  value: stats.recentSevenDayAverageIntensity == 0
                      ? '-'
                      : stats.recentSevenDayAverageIntensity.toStringAsFixed(1),
                  color: AppColors.softBeige.withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '최근 7일 강도 흐름',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _SevenDayIntensityBars(
            dailyStats: stats.recentSevenDayIntensityStats,
          ),
        ],
      ),
    );
  }

  String _formatFrequentEmotion(EmotionFrequency? emotion) {
    if (emotion == null) {
      return '-';
    }

    return '${emotion.emoji} ${emotion.emotionLabel}';
  }
}

class _StatValueCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatValueCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class _SevenDayIntensityBars extends StatelessWidget {
  final List<DailyIntensityStat> dailyStats;

  const _SevenDayIntensityBars({required this.dailyStats});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: dailyStats.map((stat) {
        final normalizedHeight = stat.averageIntensity <= 0
            ? 8.0
            : 8.0 + (stat.averageIntensity / 5 * 74);

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  stat.recordCount == 0
                      ? '-'
                      : stat.averageIntensity.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 6),
                Container(
                  height: normalizedHeight,
                  decoration: BoxDecoration(
                    color: stat.recordCount == 0
                        ? AppColors.softBeige.withValues(alpha: 0.55)
                        : AppColors.textDark.withValues(alpha: 0.82),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${stat.date.month}/${stat.date.day}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _IntensitySelector extends StatelessWidget {
  final int selectedIntensity;
  final ValueChanged<int> onSelected;

  const _IntensitySelector({
    required this.selectedIntensity,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final value = index + 1;
        final isSelected = selectedIntensity == value;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: value == 5 ? 0 : 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => onSelected(value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.textDark : AppColors.cream,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? AppColors.textDark : AppColors.softBeige,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      '$value',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: isSelected ? AppColors.white : AppColors.textDark,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _intensityLabel(value),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isSelected ? AppColors.white : AppColors.textLight,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  String _intensityLabel(int value) {
    switch (value) {
      case 1:
        return '약함';
      case 2:
        return '조금';
      case 3:
        return '보통';
      case 4:
        return '큼';
      case 5:
        return '강함';
      default:
        return '보통';
    }
  }
}

class _RecordItem extends StatelessWidget {
  static const String _emptyMemoText = '메모 없이 감정만 남겼어요.';

  final EmotionRecord record;
  final String dateText;

  const _RecordItem({
    required this.record,
    required this.dateText,
  });

  @override
  Widget build(BuildContext context) {
    final memoText = record.memo.trim().isEmpty ? _emptyMemoText : record.memo;

    return SoftCard(
      backgroundColor: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateText,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              _IntensityBadge(intensity: record.intensity),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${record.emoji} ${record.emotionLabel}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            memoText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: record.memo.trim().isEmpty
                      ? AppColors.textLight
                      : AppColors.textBrown,
                ),
          ),
        ],
      ),
    );
  }
}

class _IntensityBadge extends StatelessWidget {
  final int intensity;

  const _IntensityBadge({required this.intensity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.softPeach.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '강도 $intensity/5',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
