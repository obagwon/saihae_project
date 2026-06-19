import 'package:flutter_test/flutter_test.dart';
import 'package:saihae_project/data/bedtime_question_data.dart';

void main() {
  test('buildQuestion prioritizes high intensity saved emotion context', () {
    final question = BedtimeQuestionData.buildQuestion(
      emotionId: 'tired',
      intensity: 5,
      personalityTypeId: 'field_captain',
    );

    expect(question, '오늘 내가 생각보다 잘 버틴 순간은 언제였나요?');
  });

  test('buildQuestion uses personality context for balanced intensity', () {
    final question = BedtimeQuestionData.buildQuestion(
      emotionId: 'calm',
      intensity: 3,
      personalityTypeId: 'gentle_keeper',
    );

    expect(question, '오늘 조용히 애쓴 나를 알아준다면 어떤 부분을 말해주고 싶나요?');
  });

  test('buildQuestion falls back to date based default question', () {
    final question = BedtimeQuestionData.buildQuestion(
      now: DateTime(2026, 6, 18),
    );

    expect(question, '오늘 다시 떠올리고 싶은 따뜻한 장면은 무엇인가요?');
  });

  test('buildQuestion clamps intensity before choosing intensity question', () {
    final question = BedtimeQuestionData.buildQuestion(
      emotionId: 'calm',
      intensity: 9,
      personalityTypeId: 'gentle_keeper',
    );

    expect(question, '오늘의 편안함을 오래 느끼게 해준 작은 이유는 무엇인가요?');
  });

  test('buildQuestion returns default question for unknown context values', () {
    final question = BedtimeQuestionData.buildQuestion(
      emotionId: 'unknown_emotion',
      personalityTypeId: 'unknown_type',
      now: DateTime(2026, 6, 19),
    );

    expect(question, '내일의 나에게 한 문장만 남긴다면 뭐라고 말하고 싶나요?');
  });
}
