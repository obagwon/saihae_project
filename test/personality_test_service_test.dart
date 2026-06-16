import 'package:flutter_test/flutter_test.dart';
import 'package:saihae_project/data/test_question_data.dart';
import 'package:saihae_project/models/personality_test_result.dart';
import 'package:saihae_project/services/personality_test_service.dart';

void main() {
  test('calculateResult returns a type id and populated scores', () {
    const service = PersonalityTestService();
    final answers = List<int>.filled(testQuestions.length, 3);

    final result = service.calculateResult(answers);

    expect(result.typeId, isNot(PersonalityTestResult.defaultTypeId));
    expect(result.scores, isNotEmpty);
  });

  test('calculateResult keeps scores populated for neutral answers', () {
    const service = PersonalityTestService();
    final answers = List<int>.filled(testQuestions.length, 0);

    final result = service.calculateResult(answers);

    expect(result.scores, isNotEmpty);
    expect(result.scores.values.every((score) => score == 0), isTrue);
  });
}
