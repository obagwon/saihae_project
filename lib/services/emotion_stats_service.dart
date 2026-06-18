import '../models/emotion_record.dart';

class EmotionStats {
  final int totalRecordCount;
  final int thisWeekRecordCount;
  final double recentSevenDayAverageIntensity;
  final EmotionFrequency? mostFrequentEmotion;
  final List<DailyIntensityStat> recentSevenDayIntensityStats;

  const EmotionStats({
    required this.totalRecordCount,
    required this.thisWeekRecordCount,
    required this.recentSevenDayAverageIntensity,
    required this.mostFrequentEmotion,
    required this.recentSevenDayIntensityStats,
  });

  bool get hasRecords => totalRecordCount > 0;
  bool get hasEnoughRecordsForPattern => totalRecordCount >= 3;
}

class EmotionFrequency {
  final String emotionId;
  final String emotionLabel;
  final String emoji;
  final int count;

  const EmotionFrequency({
    required this.emotionId,
    required this.emotionLabel,
    required this.emoji,
    required this.count,
  });
}

class DailyIntensityStat {
  final DateTime date;
  final double averageIntensity;
  final int recordCount;

  const DailyIntensityStat({
    required this.date,
    required this.averageIntensity,
    required this.recordCount,
  });
}

double emotionTemperatureFromIntensity(num intensity) {
  return 36.5 + (intensity - 3) * 3;
}

class EmotionStatsService {
  const EmotionStatsService();

  EmotionStats calculate(List<EmotionRecord> records, {DateTime? now}) {
    final currentDate = _dateOnly(now ?? DateTime.now());
    final recentSevenDates = List<DateTime>.generate(
      7,
      (index) => currentDate.subtract(Duration(days: 6 - index)),
    );
    final weekStart = currentDate.subtract(
      Duration(days: currentDate.weekday - 1),
    );
    final frequencyByEmotionId = <String, EmotionFrequency>{};
    final intensitySumByDate = <DateTime, int>{};
    final countByDate = <DateTime, int>{};
    var thisWeekRecordCount = 0;
    var recentSevenDayIntensitySum = 0;
    var recentSevenDayRecordCount = 0;

    for (final record in records) {
      final recordDate = _dateOnly(record.createdAt);

      if (!recordDate.isBefore(weekStart) && !recordDate.isAfter(currentDate)) {
        thisWeekRecordCount++;
      }

      frequencyByEmotionId.update(
        record.emotionId,
        (frequency) => EmotionFrequency(
          emotionId: frequency.emotionId,
          emotionLabel: frequency.emotionLabel,
          emoji: frequency.emoji,
          count: frequency.count + 1,
        ),
        ifAbsent: () => EmotionFrequency(
          emotionId: record.emotionId,
          emotionLabel: record.emotionLabel,
          emoji: record.emoji,
          count: 1,
        ),
      );

      if (recentSevenDates.contains(recordDate)) {
        intensitySumByDate[recordDate] =
            (intensitySumByDate[recordDate] ?? 0) + record.intensity;
        countByDate[recordDate] = (countByDate[recordDate] ?? 0) + 1;
        recentSevenDayIntensitySum += record.intensity;
        recentSevenDayRecordCount++;
      }
    }

    final dailyStats = recentSevenDates.map((date) {
      final count = countByDate[date] ?? 0;
      final sum = intensitySumByDate[date] ?? 0;

      return DailyIntensityStat(
        date: date,
        averageIntensity: count == 0 ? 0 : sum / count,
        recordCount: count,
      );
    }).toList();

    return EmotionStats(
      totalRecordCount: records.length,
      thisWeekRecordCount: thisWeekRecordCount,
      recentSevenDayAverageIntensity: recentSevenDayRecordCount == 0
          ? 0
          : recentSevenDayIntensitySum / recentSevenDayRecordCount,
      mostFrequentEmotion: _findMostFrequentEmotion(frequencyByEmotionId),
      recentSevenDayIntensityStats: dailyStats,
    );
  }

  EmotionFrequency? _findMostFrequentEmotion(
    Map<String, EmotionFrequency> frequencyByEmotionId,
  ) {
    EmotionFrequency? mostFrequentEmotion;

    for (final frequency in frequencyByEmotionId.values) {
      if (mostFrequentEmotion == null ||
          frequency.count > mostFrequentEmotion.count) {
        mostFrequentEmotion = frequency;
      }
    }

    return mostFrequentEmotion;
  }

  DateTime _dateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }
}
