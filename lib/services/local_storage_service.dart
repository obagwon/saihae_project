import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';
import '../models/emotion_record.dart';
import '../models/personality_test_result.dart';

class LocalStorageService {
  static const String _emotionRecordsKey = 'emotion_records_v2';
  static const String _legacyEmotionRecordsKey = 'emotion_records';
  static const String _personalityResultKey = 'personality_result';
  static const String _appSettingsKey = 'app_settings';

  Future<void> saveAppSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData = jsonEncode(settings.toJson());

    await prefs.setString(_appSettingsKey, encodedData);
  }

  Future<AppSettings> getAppSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encodedData = prefs.getString(_appSettingsKey);

      if (encodedData == null || encodedData.isEmpty) {
        return const AppSettings.initial();
      }

      final decodedData = jsonDecode(encodedData);

      if (decodedData is! Map) {
        return const AppSettings.initial();
      }

      return AppSettings.fromJson(
        Map<String, dynamic>.from(decodedData),
      );
    } on Object {
      return const AppSettings.initial();
    }
  }

  Future<void> saveEmotionRecord(EmotionRecord record) async {
    final prefs = await SharedPreferences.getInstance();

    final records = await getEmotionRecords();
    records.insert(0, record);

    final jsonList = records.map((item) => item.toJson()).toList();
    final encodedData = jsonEncode(jsonList);

    await prefs.setString(_emotionRecordsKey, encodedData);
  }

  Future<List<EmotionRecord>> getEmotionRecords() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final encodedData = prefs.getString(_emotionRecordsKey) ??
          prefs.getString(_legacyEmotionRecordsKey);

      return _decodeEmotionRecords(encodedData);
    } on Object {
      return [];
    }
  }

  Future<void> clearEmotionRecords() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_emotionRecordsKey);
    await prefs.remove(_legacyEmotionRecordsKey);
  }

  Future<void> savePersonalityTestResult(
    PersonalityTestResult result,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData = jsonEncode(result.toJson());

    await prefs.setString(_personalityResultKey, encodedData);
  }

  Future<PersonalityTestResult?> getPersonalityTestResult() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encodedData = prefs.getString(_personalityResultKey);

      if (encodedData == null || encodedData.isEmpty) {
        return null;
      }

      final decodedData = jsonDecode(encodedData);

      if (decodedData is! Map) {
        return null;
      }

      return PersonalityTestResult.fromJson(
        Map<String, dynamic>.from(decodedData),
      );
    } on Object {
      return null;
    }
  }

  Future<void> clearPersonalityTestResult() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_personalityResultKey);
  }

  List<EmotionRecord> _decodeEmotionRecords(String? encodedData) {
    if (encodedData == null || encodedData.isEmpty) {
      return [];
    }

    try {
      final decodedData = jsonDecode(encodedData);

      if (decodedData is! List) {
        return [];
      }

      final records = <EmotionRecord>[];

      for (final item in decodedData.whereType<Map>()) {
        try {
          records.add(
            EmotionRecord.fromJson(
              Map<String, dynamic>.from(item),
            ),
          );
        } on Object {
          // 손상된 개별 기록은 앱 전체를 멈추지 않도록 건너뛴다.
        }
      }

      return records;
    } on Object {
      return [];
    }
  }
}
