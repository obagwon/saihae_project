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

    expect(question, '오늘 내가 너무 오래 붙잡고 있었던 감정은 무엇인가요?');
  });
}
