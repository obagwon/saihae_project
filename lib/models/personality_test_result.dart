class PersonalityTestResult {
  static const String defaultTypeId = 'unknown';

  final String typeId;
  final DateTime testedAt;
  final Map<String, int> scores;

  const PersonalityTestResult({
    required this.typeId,
    required this.testedAt,
    required this.scores,
  });

  Map<String, dynamic> toJson() {
    return {
      'typeId': typeId,
      'testedAt': testedAt.toIso8601String(),
      'scores': scores,
    };
  }

  factory PersonalityTestResult.fromJson(Map<String, dynamic> json) {
    return PersonalityTestResult(
      typeId: _readString(json['typeId']) ?? defaultTypeId,
      testedAt: _parseDateTime(json['testedAt']),
      scores: _readScores(json['scores']),
    );
  }

  static String? _readString(Object? value) {
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return null;
  }

  static DateTime _parseDateTime(Object? value) {
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  static Map<String, int> _readScores(Object? value) {
    if (value is! Map) {
      return {};
    }

    final scores = <String, int>{};
    value.forEach((key, score) {
      if (key is! String) return;

      final parsedScore = _readInt(score);
      if (parsedScore == null) return;

      scores[key] = parsedScore;
    });

    return scores;
  }

  static int? _readInt(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.round();
    }
    if (value is String) {
      return int.tryParse(value.trim());
    }
    return null;
  }
}
