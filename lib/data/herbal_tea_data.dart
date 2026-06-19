import '../models/emotion_record.dart';
import '../models/personality_type.dart';

class HerbalTeaRecommendation {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final String moment;
  final String recommendedStates;
  final String caution;

  const HerbalTeaRecommendation({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.moment,
    required this.recommendedStates,
    required this.caution,
  });
}

class HerbalTeaEmotionRecommendation {
  final String message;
  final List<String> teaIds;

  const HerbalTeaEmotionRecommendation({
    required this.message,
    required this.teaIds,
  });
}

class HerbalTeaData {
  const HerbalTeaData._();

  static List<HerbalTeaRecommendation> buildRecommendations({
    required EmotionRecord emotionRecord,
    PersonalityType? personalityType,
  }) {
    final teaIds = _emotionRecommendationFor(
      emotionRecord.emotionId,
    ).teaIds;

    return teaIds.take(2).map(teaById).toList();
  }

  static String recommendationMessageFor(String emotionId) {
    return _emotionRecommendationFor(emotionId).message;
  }

  static HerbalTeaEmotionRecommendation _emotionRecommendationFor(
    String emotionId,
  ) {
    return _emotionRecommendations[emotionId] ?? _fallbackEmotionRecommendation;
  }

  static HerbalTeaRecommendation teaById(String id) {
    return herbalTeaRecommendations.firstWhere(
      (tea) => tea.id == id,
      orElse: () => herbalTeaRecommendations.first,
    );
  }

  static const Map<String, HerbalTeaEmotionRecommendation>
      _emotionRecommendations = {
    'calm': HerbalTeaEmotionRecommendation(
      message: '지금의 평온함을 오래 머물게 하고 싶다면, 부드러운 루이보스나 은은한 자스민이 잘 어울려요.',
      teaIds: ['rooibos', 'jasmine'],
    ),
    'tired': HerbalTeaEmotionRecommendation(
      message: '기운이 가라앉은 날에는 페퍼민트의 상쾌함이나 생강차의 따뜻함으로 감각을 천천히 깨워보세요.',
      teaIds: ['peppermint', 'ginger'],
    ),
    'complicated': HerbalTeaEmotionRecommendation(
      message: '생각이 많을 때는 향이 또렷한 페퍼민트나 차분한 레몬밤으로 머릿속을 가볍게 정리해보세요.',
      teaIds: ['peppermint', 'lemon_balm'],
    ),
    'excited': HerbalTeaEmotionRecommendation(
      message: '설레는 마음이 너무 붕 뜨지 않도록, 자스민이나 캐모마일처럼 부드러운 향의 차가 좋아요.',
      teaIds: ['jasmine', 'chamomile'],
    ),
    'anxious': HerbalTeaEmotionRecommendation(
      message: '마음이 흔들릴 때는 레몬밤, 라벤더, 캐모마일처럼 이완감을 주는 차를 천천히 마셔보세요.',
      teaIds: ['lemon_balm', 'lavender'],
    ),
    'lethargic': HerbalTeaEmotionRecommendation(
      message: '움직일 힘이 부족한 날에는 히비스커스의 산뜻함, 페퍼민트의 청량함, 생강차의 온기가 도움이 될 수 있어요.',
      teaIds: ['hibiscus', 'peppermint'],
    ),
  };

  static const HerbalTeaEmotionRecommendation _fallbackEmotionRecommendation =
      HerbalTeaEmotionRecommendation(
    message: '오늘의 마음에 어울리는 차를 가볍게 골라봤어요.',
    teaIds: ['chamomile', 'rooibos'],
  );
}

const List<HerbalTeaRecommendation> herbalTeaRecommendations = [
  HerbalTeaRecommendation(
    id: 'chamomile',
    name: '캐모마일',
    emoji: '🌼',
    description: '부드러운 진정감과 편안한 수면 루틴에 어울리는 허브티예요.',
    moment: '잠들기 전 조용한 음악과 함께',
    recommendedStates: '불안해요, 설레요, 편안해요',
    caution: '국화과 알레르기가 있다면 주의가 필요해요.',
  ),
  HerbalTeaRecommendation(
    id: 'peppermint',
    name: '페퍼민트',
    emoji: '🌿',
    description: '시원하고 상쾌한 향으로 머리가 복잡하거나 몸이 지쳤을 때 잘 어울려요.',
    moment: '생각을 정리하기 전 한 잔',
    recommendedStates: '지쳤어요, 복잡해요, 무기력해요',
    caution: '속쓰림이나 역류성 식도염이 있다면 부담될 수 있어요.',
  ),
  HerbalTeaRecommendation(
    id: 'rooibos',
    name: '루이보스',
    emoji: '🫖',
    description: '카페인이 없어 밤에도 부담이 적고, 부드럽고 편안한 분위기에 잘 어울려요.',
    moment: '늦은 오후나 저녁의 짧은 쉼',
    recommendedStates: '편안해요, 설레요',
    caution: '대체로 무난하지만 과하게 마시기보다는 적당히 즐기는 것이 좋아요.',
  ),
  HerbalTeaRecommendation(
    id: 'lavender',
    name: '라벤더',
    emoji: '💜',
    description: '은은한 향이 긴장된 마음을 이완시키는 데 어울리는 허브티예요.',
    moment: '불빛을 낮추고 쉬어갈 때',
    recommendedStates: '불안해요, 복잡해요',
    caution: '향이 강하게 느껴질 수 있어 취향에 따라 양을 조절하는 것이 좋아요.',
  ),
  HerbalTeaRecommendation(
    id: 'hibiscus',
    name: '히비스커스',
    emoji: '🌺',
    description: '새콤하고 산뜻한 맛으로 기분 전환이 필요하거나 무기력할 때 잘 어울려요.',
    moment: '조금 산뜻한 리듬이 필요할 때',
    recommendedStates: '무기력해요, 지쳤어요',
    caution: '신맛이 강해 빈속에는 부담될 수 있어요.',
  ),
  HerbalTeaRecommendation(
    id: 'lemon_balm',
    name: '레몬밤',
    emoji: '🍋',
    description: '차분한 향으로 생각이 많거나 마음이 불안할 때 편안하게 마시기 좋아요.',
    moment: '생각이 많았던 날의 마무리',
    recommendedStates: '불안해요, 복잡해요, 설레요',
    caution: '졸림을 유발할 수 있으니 운전 전이나 집중이 필요한 상황에서는 주의해요.',
  ),
  HerbalTeaRecommendation(
    id: 'jasmine',
    name: '자스민',
    emoji: '🤍',
    description: '은은한 꽃향이 기분을 부드럽게 정돈해주고 설레는 마음에도 잘 어울려요.',
    moment: '좋았던 순간을 기록하기 전',
    recommendedStates: '편안해요, 설레요, 지쳤어요',
    caution: '녹차나 백차 베이스라면 카페인이 있을 수 있으니 밤에는 확인이 필요해요.',
  ),
  HerbalTeaRecommendation(
    id: 'ginger',
    name: '생강차',
    emoji: '🫚',
    description: '따뜻한 온기와 알싸한 향으로 몸이 처지거나 기운이 없을 때 잘 어울려요.',
    moment: '몸과 마음을 차분히 데우고 싶을 때',
    recommendedStates: '지쳤어요, 무기력해요',
    caution: '속쓰림이 있거나 위가 예민한 사람에게는 자극적일 수 있어요.',
  ),
];
