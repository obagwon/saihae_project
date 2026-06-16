class PersonalityTestResult {
  static const String defaultTypeId = 'unknown';

  final String typeId;
  final DateTime testedAt;
  final Map<String, int> scores;
  final Map<String, int> axisScores;
  final Map<String, int> axisPercentages;
  final List<int> answers;

  const PersonalityTestResult({
    required this.typeId,
    required this.testedAt,
    required this.scores,
    this.axisScores = const {},
    this.axisPercentages = const {},
    this.answers = const [],
  });

  Map<String, dynamic> toJson() => {
        'typeId': typeId,
        'testedAt': testedAt.toIso8601String(),
        'scores': scores,
        'axisScores': axisScores,
        'axisPercentages': axisPercentages,
        'answers': answers,
      };

  factory PersonalityTestResult.fromJson(Map<String, dynamic> json) {
    return PersonalityTestResult(
      typeId: _migrateTypeId(_readString(json['typeId']) ?? defaultTypeId),
      testedAt: _parseDateTime(json['testedAt']),
      scores: _readScores(json['scores']),
      axisScores: _readScores(json['axisScores']),
      axisPercentages: _readScores(json['axisPercentages']),
      answers: _readIntList(json['answers']),
    );
  }

  static String _migrateTypeId(String typeId) {
    const legacyMap = {
      'sunny_empath': 'warm_coordinator',
      'quiet_observer': 'gentle_keeper',
      'steady_realist': 'quiet_builder',
      'free_explorer': 'dream_weaver',
      'balanced_sensitive': 'gentle_keeper',
    };
    return legacyMap[typeId] ?? typeId;
  }

  static String? _readString(Object? value) {
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return null;
  }

  static DateTime _parseDateTime(Object? value) {
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  static Map<String, int> _readScores(Object? value) {
    if (value is! Map) return {};
    final scores = <String, int>{};
    value.forEach((key, score) {
      if (key is! String) return;
      final parsedScore = _readInt(score);
      if (parsedScore != null) scores[key] = parsedScore;
    });
    return scores;
  }

  static List<int> _readIntList(Object? value) {
    if (value is! List) return [];
    return value.map(_readInt).whereType<int>().toList();
  }

  static int? _readInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.round();
    if (value is String) return int.tryParse(value.trim());
    return null;
  }
}
