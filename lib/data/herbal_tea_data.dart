import '../models/emotion_record.dart';
import '../models/personality_type.dart';

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

class HerbalTeaData {
  const HerbalTeaData._();

  static List<HerbalTeaRecommendation> buildRecommendations({
    required EmotionRecord emotionRecord,
    PersonalityType? personalityType,
  }) {
    final teaIds = <String>[];

    void addTea(String id) {
      if (!teaIds.contains(id)) {
        teaIds.add(id);
      }
    }

    for (final id in _teaIdsForEmotion(emotionRecord.emotionId)) {
      addTea(id);
    }

    for (final id in _teaIdsForIntensity(emotionRecord.intensity)) {
      addTea(id);
    }

    for (final id in _teaIdsForPersonality(personalityType?.id)) {
      addTea(id);
    }

    for (final id in _fallbackTeaIds) {
      addTea(id);
    }

    return teaIds.take(3).map(_teaById).toList();
  }

  static List<String> _teaIdsForEmotion(String emotionId) {
    return _emotionTeaIds[emotionId] ?? _fallbackTeaIds;
  }

  static List<String> _teaIdsForIntensity(int intensity) {
    final safeIntensity = intensity.clamp(1, 5).toInt();

    if (safeIntensity >= 4) {
      return const ['lemon_balm'];
    }

    if (safeIntensity <= 2) {
      return const ['hibiscus'];
    }

    return const [];
  }

  static List<String> _teaIdsForPersonality(String? personalityTypeId) {
    switch (personalityTypeId) {
      case 'field_captain':
      case 'idea_pathfinder':
        return const ['peppermint'];
      case 'warm_coordinator':
      case 'dream_weaver':
        return const ['jasmine'];
      case 'quiet_builder':
      case 'gentle_keeper':
        return const ['rooibos'];
      case 'inner_strategist':
      case 'soft_lantern':
        return const ['lemon_balm'];
      default:
        return const [];
    }
  }

  static HerbalTeaRecommendation _teaById(String id) {
    return herbalTeaRecommendations.firstWhere(
      (tea) => tea.id == id,
      orElse: () => herbalTeaRecommendations.first,
    );
  }

  static const Map<String, List<String>> _emotionTeaIds = {
    'complicated': ['peppermint', 'lemon_balm'],
    'tired': ['rooibos', 'chamomile', 'ginger'],
    'calm': ['jasmine', 'hibiscus', 'rooibos'],
    'anxious': ['lavender', 'chamomile'],
    'lethargic': ['hibiscus', 'peppermint'],
    'excited': ['jasmine', 'hibiscus'],
  };

  static const List<String> _fallbackTeaIds = [
    'chamomile',
    'rooibos',
    'peppermint',
  ];
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
    description: '은은한 향으로 잠깐 멈추는 느낌과 잘 맞아요.',
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
