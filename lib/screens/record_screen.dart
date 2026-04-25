import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../data/emotion_data.dart';
import '../models/emotion_record.dart';
import '../services/local_storage_service.dart';
import '../widgets/emotion_chip.dart';
import '../widgets/rounded_button.dart';
import '../widgets/section_title.dart';
import '../widgets/soft_card.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final TextEditingController memoController = TextEditingController();
  final LocalStorageService storageService = LocalStorageService();

  int selectedEmotionIndex = 0;
  List<EmotionRecord> records = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRecords();
  }

  @override
  void dispose() {
    memoController.dispose();
    super.dispose();
  }

  Future<void> loadRecords() async {
    final loadedRecords = await storageService.getEmotionRecords();

    setState(() {
      records = loadedRecords;
      isLoading = false;
    });
  }

  Future<void> saveRecord() async {
    final selectedEmotion = emotionGuides[selectedEmotionIndex];
    final memo = memoController.text.trim();

    if (memo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('오늘의 마음을 한 줄이라도 적어주세요.'),
        ),
      );
      return;
    }

    final newRecord = EmotionRecord(
      emotion: '${selectedEmotion.emoji} ${selectedEmotion.name}',
      memo: memo,
      createdAt: DateTime.now(),
    );

    await storageService.saveEmotionRecord(newRecord);

    memoController.clear();

    await loadRecords();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('오늘의 마음이 저장되었어요.'),
      ),
    );
  }

  Future<void> clearRecords() async {
    await storageService.clearEmotionRecords();

    await loadRecords();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('기록이 모두 삭제되었어요.'),
      ),
    );
  }

  String formatDate(DateTime dateTime) {
    return '${dateTime.year}.${_twoDigits(dateTime.month)}.${_twoDigits(dateTime.day)}';
  }

  String _twoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    final selectedEmotion = emotionGuides[selectedEmotionIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '오늘의 마음을\n짧게 남겨봐요',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 12),
          Text(
            '대단한 기록이 아니어도 괜찮아요. 오늘의 감정 하나와 짧은 문장만으로도 충분해요.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),

          SoftCard(
            backgroundColor: AppColors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(
                  title: '지금 마음에 가까운 감정',
                  description: '오늘의 나와 가장 비슷한 감정을 골라주세요.',
                  margin: EdgeInsets.zero,
                ),
                const SizedBox(height: 16),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    emotionGuides.length,
                        (index) {
                      final emotion = emotionGuides[index];

                      return EmotionChip(
                        emoji: emotion.emoji,
                        label: emotion.name,
                        isSelected: selectedEmotionIndex == index,
                        onTap: () {
                          setState(() {
                            selectedEmotionIndex = index;
                          });
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.softPink.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${selectedEmotion.emoji} ${selectedEmotion.message}\n${selectedEmotion.tip}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  '오늘의 한 줄 회고',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: memoController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: '오늘 있었던 일이나 마음을 짧게 적어보세요.',
                    hintStyle: Theme.of(context).textTheme.bodySmall,
                    filled: true,
                    fillColor: AppColors.cream,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                RoundedButton(
                  text: '기록 저장하기',
                  icon: Icons.save_rounded,
                  onPressed: saveRecord,
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '최근 기록',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (records.isNotEmpty)
                TextButton(
                  onPressed: clearRecords,
                  child: const Text(
                    '전체 삭제',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            )
          else if (records.isEmpty)
            SoftCard(
              backgroundColor: AppColors.softYellow.withOpacity(0.75),
              hasShadow: false,
              child: Text(
                '아직 저장된 기록이 없어요.\n오늘의 감정을 하나 남겨보세요.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            )
          else
            Column(
              children: records.map((record) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _RecordItem(
                    record: record,
                    dateText: formatDate(record.createdAt),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class _RecordItem extends StatelessWidget {
  final EmotionRecord record;
  final String dateText;

  const _RecordItem({
    required this.record,
    required this.dateText,
  });

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      backgroundColor: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateText,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Text(
            record.emotion,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            record.memo,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}