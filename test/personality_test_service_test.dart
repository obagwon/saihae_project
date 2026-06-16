import 'package:flutter_test/flutter_test.dart';
import 'package:saihae_project/data/personality_data.dart';
import 'package:saihae_project/data/test_question_data.dart';
import 'package:saihae_project/models/personality_test_result.dart';
import 'package:saihae_project/models/test_question.dart';
import 'package:saihae_project/services/personality_test_service.dart';

void main() {
  const service = PersonalityTestService();

  List<int?> answersFor(List<PersonalityPole> targetPoles) {
    return testQuestions.map((question) {
      return targetPoles.contains(question.positivePole) ? 3 : 0;
    }).toList();
  }

  test('all answered questions calculate a result', () {
    final answers = List<int?>.filled(testQuestions.length, 3);
    final result = service.calculateResult(answers);

    expect(service.isComplete(answers), isTrue);
    expect(result.typeId, isNot(PersonalityTestResult.defaultTypeId));
    expect(result.axisPercentages, containsPair('external', 50));
    expect(result.answers.length, testQuestions.length);
  });

  test('all eight personality combinations are reachable', () {
    for (final type in personalityTypes) {
      final result = service.calculateResult(answersFor(type.poles));
      expect(result.typeId, type.id, reason: type.name);
    }
  });

  test('reverse-scored answers are reflected on the opposite pole', () {
    final questionIndex = testQuestions.indexWhere(
      (question) => question.positivePole == PersonalityPole.external,
    );
    final answers = List<int?>.filled(testQuestions.length, 1);
    answers[questionIndex] = 0;

    final result = service.calculateResult(answers);

    expect(result.axisScores['internal'], greaterThan(result.axisScores['external']!));
  });

  test('changing a previous answer recalculates the result', () {
    final answers = answersFor(const [
      PersonalityPole.external,
      PersonalityPole.realistic,
      PersonalityPole.logical,
    ]);
    final firstResult = service.calculateResult(answers);

    final changedAnswers = answersFor(const [
      PersonalityPole.internal,
      PersonalityPole.realistic,
      PersonalityPole.logical,
    ]);
    final changedResult = service.calculateResult(changedAnswers);

    expect(firstResult.typeId, 'field_captain');
    expect(changedResult.typeId, 'quiet_builder');
  });

  test('tie handling is deterministic and uses configured fallback', () {
    final answers = List<int?>.filled(testQuestions.length, 1);
    final first = service.calculateResult(answers);
    final second = service.calculateResult(answers);

    expect(first.typeId, second.typeId);
    expect(first.typeId, 'soft_lantern');
  });

  test('restart-style empty answer state is incomplete and has no stored answers', () {
    final answers = List<int?>.filled(testQuestions.length, null);

    expect(service.isComplete(answers), isFalse);
    expect(answers.every((answer) => answer == null), isTrue);
  });
}
