import 'package:flutter_test/flutter_test.dart';
import 'package:saihae_project/data/herbal_tea_data.dart';
import 'package:saihae_project/data/personality_data.dart';
import 'package:saihae_project/models/emotion_record.dart';

void main() {
  test('buildRecommendations returns exactly two teas for each emotion', () {
    const expectedTeaIdsByEmotion = {
      'calm': ['rooibos', 'jasmine'],
      'tired': ['peppermint', 'ginger'],
      'complicated': ['peppermint', 'lemon_balm'],
      'excited': ['jasmine', 'chamomile'],
      'anxious': ['lemon_balm', 'lavender'],
      'lethargic': ['hibiscus', 'peppermint'],
    };

    for (final entry in expectedTeaIdsByEmotion.entries) {
      final teas = HerbalTeaData.buildRecommendations(
        emotionRecord: _record(emotionId: entry.key, intensity: 3),
        personalityType: personalityTypes.first,
      );

      expect(teas.map((tea) => tea.id), entry.value);
      expect(teas, hasLength(2));
    }
  });

  test('recommendationMessageFor returns requested emotion copy', () {
    expect(
      HerbalTeaData.recommendationMessageFor('anxious'),
      '마음이 흔들릴 때는 레몬밤, 라벤더, 캐모마일처럼 이완감을 주는 차를 천천히 마셔보세요.',
    );
  });

  test('buildRecommendations returns two fallback teas for unknown emotion', () {
    final teas = HerbalTeaData.buildRecommendations(
      emotionRecord: _record(emotionId: 'unknown', intensity: 3),
    );

    expect(teas.map((tea) => tea.id), ['chamomile', 'rooibos']);
  });

  test('herbal tea detail data includes recommended states and cautions', () {
    for (final tea in herbalTeaRecommendations) {
      expect(tea.description, isNotEmpty);
      expect(tea.recommendedStates, isNotEmpty);
      expect(tea.caution, isNotEmpty);
    }
  });

  test('herbal tea copy does not include prohibited medical claims', () {
    const prohibitedExpressions = [
      '불면증 ' '치료',
      '불안 완화 ' '보장',
      '우울증 ' '개선',
      '스트레스 ' '치료',
      '진정 효과 ' '보장',
    ];

    for (final tea in herbalTeaRecommendations) {
      for (final expression in prohibitedExpressions) {
        expect(tea.description, isNot(contains(expression)));
        expect(tea.moment, isNot(contains(expression)));
        expect(tea.caution, isNot(contains(expression)));
      }
    }
  });
}

EmotionRecord _record({required String emotionId, required int intensity}) {
  return EmotionRecord(
    emotionId: emotionId,
    emotionLabel: '감정',
    emoji: '💭',
    intensity: intensity,
    memo: '',
    createdAt: DateTime(2026, 6, 19),
  );
}
