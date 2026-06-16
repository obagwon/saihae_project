import 'package:flutter_test/flutter_test.dart';
import 'package:saihae_project/data/recommendation_data.dart';

void main() {
  test('buildRecommendation uses recovery mode for high intensity', () {
    final recommendation = RecommendationData.buildRecommendation(
      emotionId: 'anxious',
      intensity: 5,
      personalityTypeId: 'quiet_builder',
    );

    expect(recommendation.title, contains('회복 모드'));
    expect(recommendation.personalityNote, isNotNull);
    expect(recommendation.safetyNote, isNotNull);
  });

  test('buildRecommendation falls back for unknown emotion', () {
    final recommendation = RecommendationData.buildRecommendation(
      emotionId: 'unknown_emotion',
      intensity: 3,
    );

    expect(recommendation.title, RecommendationData.defaultRecommendation.title);
    expect(recommendation.actionText, isNotEmpty);
  });
}
