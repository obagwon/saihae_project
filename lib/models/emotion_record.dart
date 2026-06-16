class EmotionRecord {
  static const int defaultIntensity = 3;
  static const String defaultEmotionId = 'unknown';
  static const String defaultEmotionLabel = '감정';
  static const String defaultEmoji = '💭';

  final String id;
  final String emotionId;
  final String emotionLabel;
  final String emoji;
  final int intensity;
  final String memo;
  final DateTime createdAt;

  EmotionRecord({
    String? id,
    String? emotionId,
    String? emotionLabel,
    String? emoji,
    int intensity = defaultIntensity,
    String? emotion,
    required this.memo,
    required DateTime createdAt,
  })  : id = _safeString(id, fallback: _createId(createdAt)),
        emotionId = _safeString(emotionId, fallback: defaultEmotionId),
        emotionLabel = _safeString(
          emotionLabel,
          fallback: _extractEmotionLabel(emotion) ?? defaultEmotionLabel,
        ),
        emoji = _safeString(
          emoji,
          fallback: _extractEmoji(emotion) ?? defaultEmoji,
        ),
        intensity = _clampIntensity(intensity),
        createdAt = createdAt;

  String get emotion => '$emoji $emotionLabel';

  EmotionRecord copyWith({
    String? id,
    String? emotionId,
    String? emotionLabel,
    String? emoji,
    int? intensity,
    String? memo,
    DateTime? createdAt,
  }) {
    return EmotionRecord(
      id: id ?? this.id,
      emotionId: emotionId ?? this.emotionId,
      emotionLabel: emotionLabel ?? this.emotionLabel,
      emoji: emoji ?? this.emoji,
      intensity: intensity ?? this.intensity,
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emotionId': emotionId,
      'emotionLabel': emotionLabel,
      'emoji': emoji,
      'intensity': intensity,
      'memo': memo,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory EmotionRecord.fromJson(Map<String, dynamic> json) {
    final createdAt = _parseDateTime(json['createdAt']);
    final legacyEmotion = _readString(json['emotion']);

    return EmotionRecord(
      id: _readString(json['id']) ?? _createId(createdAt),
      emotionId: _readString(json['emotionId']) ?? defaultEmotionId,
      emotionLabel: _readString(json['emotionLabel']) ??
          _readString(json['label']) ??
          _extractEmotionLabel(legacyEmotion) ??
          defaultEmotionLabel,
      emoji: _readString(json['emoji']) ??
          _extractEmoji(legacyEmotion) ??
          defaultEmoji,
      intensity: _readInt(json['intensity']) ?? defaultIntensity,
      memo: _readString(json['memo']) ?? '',
      createdAt: createdAt,
    );
  }

  static String _createId(DateTime createdAt) {
    return 'emotion_${createdAt.microsecondsSinceEpoch}';
  }

  static String _safeString(String? value, {required String fallback}) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return fallback;
    }
    return trimmed;
  }

  static String? _readString(Object? value) {
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return null;
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

  static int _clampIntensity(int value) {
    return value.clamp(1, 5).toInt();
  }

  static DateTime _parseDateTime(Object? value) {
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  static String? _extractEmoji(String? emotion) {
    final trimmed = emotion?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    final parts = trimmed.split(RegExp(r'\s+'));
    return parts.length > 1 ? parts.first : null;
  }

  static String? _extractEmotionLabel(String? emotion) {
    final trimmed = emotion?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length <= 1) {
      return trimmed;
    }

    return parts.skip(1).join(' ').trim();
  }
}
