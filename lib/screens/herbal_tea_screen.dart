import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/personality_data.dart';
import '../models/emotion_record.dart';
import '../models/personality_test_result.dart';
import '../models/personality_type.dart';
import '../services/local_storage_service.dart';
import '../widgets/section_title.dart';
import '../widgets/soft_card.dart';

class HerbalTeaScreen extends StatefulWidget {
  const HerbalTeaScreen({super.key});

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
    final recommendations = buildTeaRecommendations(
      emotionRecord: todayEmotionRecord,
      personalityType: savedType,
    );
    final hasPersonalContext = savedType != null || todayEmotionRecord != null;

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
            if (!hasPersonalContext) ...[
              const _HerbalTeaEmptyGuideCard(),
              const SizedBox(height: 18),
            ],
            _HerbalTeaContextCard(
              type: savedType,
              record: todayEmotionRecord,
            ),
            const SizedBox(height: 22),
            SectionTitle(
              title: '추천 허브티',
              description: hasPersonalContext
                  ? '오늘의 흐름에 어울리는 후보를 골라봤어요.'
                  : '기본 추천부터 편안하게 둘러보세요.',
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
      ),
    );
  }
}

List<HerbalTeaRecommendation> buildTeaRecommendations({
  required EmotionRecord? emotionRecord,
  required PersonalityType? personalityType,
}) {
  final teaIds = <String>[];

  void addTea(String id) {
    if (!teaIds.contains(id)) {
      teaIds.add(id);
    }
  }

  final intensity = emotionRecord?.intensity;
  switch (emotionRecord?.emotionId) {
    case 'tired':
      addTea('ginger');
      addTea('rooibos');
      break;
    case 'complicated':
      addTea('peppermint');
      addTea('lemon_balm');
      break;
    case 'excited':
      addTea('jasmine');
      addTea('hibiscus');
      break;
    case 'anxious':
      addTea('lavender');
      addTea('chamomile');
      break;
    case 'lethargic':
      addTea('hibiscus');
      addTea('peppermint');
      break;
    case 'calm':
      addTea('rooibos');
      addTea('chamomile');
      break;
  }

  if (intensity != null && intensity >= 4) {
    addTea('lemon_balm');
  } else if (intensity != null && intensity <= 2) {
    addTea('hibiscus');
  }

  switch (personalityType?.id) {
    case 'field_captain':
    case 'idea_pathfinder':
      addTea('peppermint');
      break;
    case 'warm_coordinator':
    case 'dream_weaver':
      addTea('jasmine');
      break;
    case 'quiet_builder':
    case 'gentle_keeper':
      addTea('rooibos');
      break;
    case 'inner_strategist':
    case 'soft_lantern':
      addTea('lemon_balm');
      break;
  }

  addTea('chamomile');
  addTea('rooibos');
  addTea('peppermint');

  return teaIds.take(3).map((id) => _teaById(id)).toList();
}

HerbalTeaRecommendation _teaById(String id) {
  return herbalTeaRecommendations.firstWhere(
    (tea) => tea.id == id,
    orElse: () => herbalTeaRecommendations.first,
  );
}

class HerbalTeaRecommendation {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final String moment;

  const HerbalTeaRecommendation({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.moment,
  });
}

const List<HerbalTeaRecommendation> herbalTeaRecommendations = [
  HerbalTeaRecommendation(
    id: 'chamomile',
    name: '캐모마일',
    emoji: '🌼',
    description: '하루를 천천히 내려놓는 휴식 분위기에 잘 어울려요.',
    moment: '잠들기 전 조용한 음악과 함께',
  ),
  HerbalTeaRecommendation(
    id: 'peppermint',
    name: '페퍼민트',
    emoji: '🌿',
    description: '가볍게 기분 전환하며 머릿속을 환기하고 싶을 때 어울려요.',
    moment: '생각을 정리하기 전 한 잔',
  ),
  HerbalTeaRecommendation(
    id: 'rooibos',
    name: '루이보스',
    emoji: '🫖',
    description: '따뜻하게 쉬어가는 데 어울리는 부드러운 분위기의 차예요.',
    moment: '늦은 오후나 저녁의 짧은 쉼',
  ),
  HerbalTeaRecommendation(
    id: 'lavender',
    name: '라벤더',
    emoji: '💜',
    description: '조용하고 포근한 분위기를 만들고 싶을 때 잘 어울려요.',
    moment: '불빛을 낮추고 쉬어갈 때',
  ),
  HerbalTeaRecommendation(
    id: 'hibiscus',
    name: '히비스커스',
    emoji: '🌺',
    description: '상큼한 색과 향으로 가볍게 기분 전환하기 좋아요.',
    moment: '조금 산뜻한 리듬이 필요할 때',
  ),
  HerbalTeaRecommendation(
    id: 'lemon_balm',
    name: '레몬밤',
    emoji: '🍋',
    description: '은은한 향으로 하루의 속도를 천천히 낮추는 데 어울려요.',
    moment: '생각이 많았던 날의 마무리',
  ),
  HerbalTeaRecommendation(
    id: 'jasmine',
    name: '자스민',
    emoji: '🤍',
    description: '부드러운 향과 함께 따뜻한 장면을 떠올리기 좋아요.',
    moment: '좋았던 순간을 기록하기 전',
  ),
  HerbalTeaRecommendation(
    id: 'ginger',
    name: '생강차',
    emoji: '🫚',
    description: '따뜻한 컵을 손에 쥐고 천천히 쉬어가기에 어울려요.',
    moment: '몸과 마음을 차분히 데우고 싶을 때',
  ),
];

class _HerbalTeaLoadingCard extends StatelessWidget {
  const _HerbalTeaLoadingCard();

  @override
  Widget build(BuildContext context) {
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
}

class _HerbalTeaEmptyGuideCard extends StatelessWidget {
  const _HerbalTeaEmptyGuideCard();

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      backgroundColor: AppColors.softYellow.withValues(alpha: 0.72),
      hasShadow: false,
      child: Text(
        '성향 테스트나 오늘의 마음 체크를 남기면 더 잘 어울리는 허브티를 골라볼 수 있어요. 지금은 기본 추천을 보여드릴게요.',
        style: Theme.of(context).textTheme.bodyMedium,
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
    final typeText = type == null ? '성향 카드 없음' : type!.name;
    final emotionText = record == null
        ? '오늘 마음 기록 없음'
        : '${record!.emoji} ${record!.emotionLabel} · 강도 ${record!.intensity}/5';

    return SoftCard(
      backgroundColor: AppColors.white,
      hasShadow: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.local_cafe_rounded, color: AppColors.navy),
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
      backgroundColor: AppColors.white,
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
                Text(tea.description, style: Theme.of(context).textTheme.bodyMedium),
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
