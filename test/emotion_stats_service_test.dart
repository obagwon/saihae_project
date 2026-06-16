import 'package:flutter_test/flutter_test.dart';
import 'package:saihae_project/models/emotion_record.dart';
import 'package:saihae_project/services/emotion_stats_service.dart';

void main() {
  test('calculate returns empty stats for no records', () {
    const service = EmotionStatsService();

    final stats = service.calculate([], now: DateTime(2026, 6, 16));

    expect(stats.totalRecordCount, 0);
    expect(stats.thisWeekRecordCount, 0);
    expect(stats.recentSevenDayAverageIntensity, 0);
    expect(stats.mostFrequentEmotion, isNull);
    expect(stats.recentSevenDayIntensityStats, hasLength(7));
  });

  test('calculate counts frequent emotion and recent intensity', () {
    const service = EmotionStatsService();
    final now = DateTime(2026, 6, 16);
    final records = [
      EmotionRecord(
        emotionId: 'calm',
        emotionLabel: '편안해요',
        emoji: '🌿',
        intensity: 4,
        memo: '',
        createdAt: now,
      ),
      EmotionRecord(
        emotionId: 'calm',
        emotionLabel: '편안해요',
        emoji: '🌿',
        intensity: 2,
        memo: '',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      EmotionRecord(
        emotionId: 'tired',
        emotionLabel: '지쳤어요',
        emoji: '☁️',
        intensity: 5,
        memo: '',
        createdAt: now.subtract(const Duration(days: 8)),
      ),
    ];

    final stats = service.calculate(records, now: now);

    expect(stats.totalRecordCount, 3);
    expect(stats.thisWeekRecordCount, 2);
    expect(stats.mostFrequentEmotion?.emotionId, 'calm');
    expect(stats.recentSevenDayAverageIntensity, 3);
  });
}
