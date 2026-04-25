class EmotionRecord {
  final String emotion;
  final String memo;
  final DateTime createdAt;

  const EmotionRecord({
    required this.emotion,
    required this.memo,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'emotion': emotion,
      'memo': memo,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory EmotionRecord.fromJson(Map<String, dynamic> json) {
    return EmotionRecord(
      emotion: json['emotion'] as String,
      memo: json['memo'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}