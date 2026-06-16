import '../data/test_question_data.dart';
import '../models/personality_test_result.dart';
import '../models/test_question.dart';

class PersonalityTestService {
  static const List<String> defaultTypeOrder = [
    'sunny_empath',
    'quiet_observer',
    'steady_realist',
    'free_explorer',
    'balanced_sensitive',
  ];

  final List<TestQuestion> questions;
  final List<String> typeOrder;

  const PersonalityTestService({
    this.questions = testQuestions,
    this.typeOrder = defaultTypeOrder,
  });

  PersonalityTestResult calculateResult(List<int> answers) {
    final totalScores = <String, int>{
      for (final typeId in typeOrder) typeId: 0,
    };

    final answerCount = answers.length < questions.length
        ? answers.length
        : questions.length;

    for (int i = 0; i < answerCount; i++) {
      final answerWeight = answers[i];
      final question = questions[i];

      question.typeScores.forEach((typeId, score) {
        totalScores[typeId] =
            (totalScores[typeId] ?? 0) + (score * answerWeight);
      });
    }

    final bestTypeId = _selectBestTypeId(totalScores);

    return PersonalityTestResult(
      typeId: bestTypeId,
      testedAt: DateTime.now(),
      scores: totalScores,
    );
  }

  String _selectBestTypeId(Map<String, int> scores) {
    String bestTypeId = typeOrder.isNotEmpty
        ? typeOrder.first
        : PersonalityTestResult.defaultTypeId;
    int bestScore = scores[bestTypeId] ?? 0;

    for (final typeId in typeOrder) {
      final score = scores[typeId] ?? 0;

      // 동점이면 typeOrder에 선언된 순서를 유지해
      // 기존 TestScreen 계산 결과와 동일하게 선택한다.
      if (score > bestScore) {
        bestTypeId = typeId;
        bestScore = score;
      }
    }

    return bestTypeId;
  }
}
