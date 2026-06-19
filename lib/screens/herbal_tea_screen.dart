import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/herbal_tea_data.dart';
import '../data/personality_data.dart';
import '../models/emotion_record.dart';
import '../models/personality_test_result.dart';
import '../models/personality_type.dart';
import '../services/local_storage_service.dart';
import '../widgets/rounded_button.dart';
import '../widgets/section_title.dart';
import '../widgets/soft_card.dart';

class HerbalTeaScreen extends StatefulWidget {
  final VoidCallback? onOpenRecord;

  const HerbalTeaScreen({super.key, this.onOpenRecord});

  @override
  State<HerbalTeaScreen> createState() => _HerbalTeaScreenState();
}

class _HerbalTeaScreenState extends State<HerbalTeaScreen> {
  final LocalStorageService storageService = LocalStorageService();

  PersonalityType? savedType;
  EmotionRecord? todayEmotionRecord;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadHerbalTeaData();
  }

  Future<void> loadHerbalTeaData() async {
    final result = await storageService.getPersonalityTestResult();
    final records = await storageService.getEmotionRecords();
    final type = _findPersonalityType(result);
    final todayRecord = _findLatestTodayEmotionRecord(records);

    if (!mounted) return;

    setState(() {
      savedType = type;
      todayEmotionRecord = todayRecord;
      isLoading = false;
    });
  }

  PersonalityType? _findPersonalityType(PersonalityTestResult? result) {
    if (result == null) return null;

    for (final type in personalityTypes) {
      if (type.id == result.typeId) {
        return type;
      }
    }

    return null;
  }

  EmotionRecord? _findLatestTodayEmotionRecord(List<EmotionRecord> records) {
    final now = DateTime.now();
    final todayRecords = records.where((record) {
      final createdAt = record.createdAt;
      return createdAt.year == now.year &&
          createdAt.month == now.month &&
          createdAt.day == now.day;
    }).toList();

    if (todayRecords.isEmpty) return null;

    todayRecords.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return todayRecords.first;
  }

  @override
  Widget build(BuildContext context) {
    final todayRecord = todayEmotionRecord;
    final recommendations = todayRecord == null
        ? const <HerbalTeaRecommendation>[]
        : HerbalTeaData.buildRecommendations(
            emotionRecord: todayRecord,
            personalityType: savedType,
          );
    final hasTodayRecord = todayRecord != null;

    return RefreshIndicator(
      onRefresh: loadHerbalTeaData,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppSpacing.screenPadding,
        children: [
          Text(
            '오늘의 쉬어가는\n허브티를 골라봐요',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 12),
          Text(
            '마음 기록과 성향 카드를 참고해 오늘 분위기에 어울리는 차를 가볍게 추천해요.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          if (isLoading)
            const _HerbalTeaLoadingCard()
          else ...[
            if (!hasTodayRecord) ...[
              _HerbalTeaEmptyGuideCard(onOpenRecord: widget.onOpenRecord),
              const SizedBox(height: 16),
              const _HerbalTeaNotice(),
            ] else ...[
              _HerbalTeaContextCard(
                type: savedType,
                record: todayRecord,
              ),
              const SizedBox(height: 22),
              const SectionTitle(
                title: '추천 허브티',
                description: '오늘의 마음 기록을 먼저 보고, 성향은 가볍게 참고했어요.',
              ),
              ...recommendations.map(
                (tea) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _HerbalTeaRecommendationCard(tea: tea),
                ),
              ),
              const SizedBox(height: 12),
              const _HerbalTeaCandidateList(),
              const SizedBox(height: 16),
              const _HerbalTeaNotice(),
            ],
          ],
        ],
      ),
    );
  }
}

class _HerbalTeaLoadingCard extends StatelessWidget {
  const _HerbalTeaLoadingCard();

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      backgroundColor: context.palette.card,
      hasShadow: false,
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class _HerbalTeaEmptyGuideCard extends StatelessWidget {
  final VoidCallback? onOpenRecord;

  const _HerbalTeaEmptyGuideCard({required this.onOpenRecord});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      backgroundColor: AppColors.softYellow.withValues(alpha: 0.72),
      hasShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '오늘의 마음 체크가 먼저 필요해요',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '허브티 추천은 오늘 남긴 마음 기록을 1순위로 참고해요. 기록 탭에서 지금 마음을 가볍게 남긴 뒤 다시 확인해보세요.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (onOpenRecord != null) ...[
            const SizedBox(height: AppSpacing.md),
            RoundedButton(
              text: '기록 탭에서 마음 체크하기',
              icon: Icons.edit_note_rounded,
              variant: RoundedButtonVariant.tonal,
              onPressed: onOpenRecord,
            ),
          ],
        ],
      ),
    );
  }
}

class _HerbalTeaContextCard extends StatelessWidget {
  final PersonalityType? type;
  final EmotionRecord? record;

  const _HerbalTeaContextCard({
    required this.type,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    final typeText =
        type == null ? '성향 참고: 성향 카드 없음' : '성향 참고: ${type!.name}';
    final emotionText =
        '오늘의 마음: ${record!.emoji} ${record!.emotionLabel} · 강도 ${record!.intensity}/5';

    return SoftCard(
      backgroundColor: context.palette.card,
      hasShadow: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.local_cafe_rounded, color: context.palette.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              '$typeText\n$emotionText',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _HerbalTeaRecommendationCard extends StatelessWidget {
  final HerbalTeaRecommendation tea;

  const _HerbalTeaRecommendationCard({required this.tea});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      backgroundColor: context.palette.card,
      hasShadow: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tea.emoji, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tea.name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  tea.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  tea.moment,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
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

class _HerbalTeaCandidateList extends StatelessWidget {
  const _HerbalTeaCandidateList();

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      backgroundColor: AppColors.mint.withValues(alpha: 0.62),
      hasShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('허브티 후보', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: herbalTeaRecommendations.map((tea) {
              return _TeaChip(label: '${tea.emoji} ${tea.name}');
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _TeaChip extends StatelessWidget {
  final String label;

  const _TeaChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: context.palette.card.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(AppRadii.chip),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}

class _HerbalTeaNotice extends StatelessWidget {
  const _HerbalTeaNotice();

  @override
  Widget build(BuildContext context) {
    return const SoftCard(
      backgroundColor: AppColors.softBeige,
      hasShadow: false,
      padding: EdgeInsets.all(AppSpacing.md),
      child: Text(
        '알레르기, 카페인 민감도, 복용 중인 약이 있다면 성분을 먼저 확인해 주세요.',
      ),
    );
  }
}
