import 'package:flutter_test/flutter_test.dart';
import 'package:saihae_project/data/herbal_tea_data.dart';
import 'package:saihae_project/data/personality_data.dart';
import 'package:saihae_project/models/emotion_record.dart';

void main() {
  test('buildRecommendations prioritizes today complicated emotion teas', () {
    final teas = HerbalTeaData.buildRecommendations(
      emotionRecord: _record(emotionId: 'complicated', intensity: 3),
      personalityType: personalityTypes.first,
    );

    final teaIds = teas.map((tea) => tea.id).toList();

    expect(teaIds.take(2), ['peppermint', 'lemon_balm']);
  });

  test('buildRecommendations keeps tired emotion ahead of personality reference', () {
    final teas = HerbalTeaData.buildRecommendations(
      emotionRecord: _record(emotionId: 'tired', intensity: 3),
      personalityType: personalityTypes.firstWhere(
        (type) => type.id == 'idea_pathfinder',
      ),
    );

    expect(teas.map((tea) => tea.id), ['rooibos', 'chamomile', 'ginger']);
  });

  test('buildRecommendations returns fallback teas for unknown emotion', () {
    final teas = HerbalTeaData.buildRecommendations(
      emotionRecord: _record(emotionId: 'unknown', intensity: 3),
    );

    expect(teas.map((tea) => tea.id), ['chamomile', 'rooibos', 'peppermint']);
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
