import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/emotion_record.dart';

class LocalStorageService {
  static const String _emotionRecordsKey = 'emotion_records';

  Future<void> saveEmotionRecord(EmotionRecord record) async {
    final prefs = await SharedPreferences.getInstance();

    final records = await getEmotionRecords();
    records.insert(0, record);

    final jsonList = records.map((item) => item.toJson()).toList();
    final encodedData = jsonEncode(jsonList);

    await prefs.setString(_emotionRecordsKey, encodedData);
  }

  Future<List<EmotionRecord>> getEmotionRecords() async {
    final prefs = await SharedPreferences.getInstance();

    final encodedData = prefs.getString(_emotionRecordsKey);

    if (encodedData == null || encodedData.isEmpty) {
      return [];
    }

    final decodedData = jsonDecode(encodedData) as List<dynamic>;

    return decodedData
        .map(
          (item) => EmotionRecord.fromJson(
        item as Map<String, dynamic>,
      ),
    )
        .toList();
  }

  Future<void> clearEmotionRecords() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_emotionRecordsKey);
  }
}