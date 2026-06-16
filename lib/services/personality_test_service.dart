import '../data/personality_data.dart';
import '../data/test_question_data.dart';
import '../models/personality_test_result.dart';
import '../models/test_question.dart';

class PersonalityTestService {
  final List<TestQuestion> questions;

  const PersonalityTestService({this.questions = testQuestions});

  bool isComplete(List<int?> answers) =>
      answers.length == questions.length && answers.every((answer) => answer != null);

  PersonalityTestResult calculateResult(List<int?> answers) {
    final axisScores = <PersonalityPole, int>{
      for (final pole in PersonalityPole.values) pole: 0,
    };
    final strongResponses = <PersonalityPole, int>{
      for (final pole in PersonalityPole.values) pole: 0,
    };
    final weightedStrongResponses = <PersonalityPole, int>{
      for (final pole in PersonalityPole.values) pole: 0,
    };

    for (var i = 0; i < questions.length && i < answers.length; i++) {
      final answer = answers[i];
      if (answer == null) continue;
      final question = questions[i];
      final positivePole = question.positivePole;
      final oppositePole = _oppositePole(positivePole);
      final positiveScore = answer.clamp(0, 3).toInt();
      final oppositeScore = 3 - positiveScore;

      axisScores[positivePole] = axisScores[positivePole]! + positiveScore;
      axisScores[oppositePole] = axisScores[oppositePole]! + oppositeScore;

      if (positiveScore >= 2) {
        strongResponses[positivePole] = strongResponses[positivePole]! + 1;
        weightedStrongResponses[positivePole] =
            weightedStrongResponses[positivePole]! + question.tieBreakWeight;
      } else {
        strongResponses[oppositePole] = strongResponses[oppositePole]! + 1;
        weightedStrongResponses[oppositePole] =
            weightedStrongResponses[oppositePole]! + question.tieBreakWeight;
      }
    }

    final selectedPoles = [
      _selectPole(PersonalityPole.external, PersonalityPole.internal, axisScores,
          strongResponses, weightedStrongResponses),
      _selectPole(PersonalityPole.realistic, PersonalityPole.possibility, axisScores,
          strongResponses, weightedStrongResponses),
      _selectPole(PersonalityPole.logical, PersonalityPole.relational, axisScores,
          strongResponses, weightedStrongResponses),
    ];

    final type = personalityTypes.firstWhere(
      (type) => selectedPoles.every(type.poles.contains),
      orElse: () => personalityTypes.first,
    );

    return PersonalityTestResult(
      typeId: type.id,
      testedAt: DateTime.now(),
      scores: {for (final entry in axisScores.entries) entry.key.name: entry.value},
      axisScores: {for (final entry in axisScores.entries) entry.key.name: entry.value},
      axisPercentages: _buildPercentages(axisScores),
      answers: answers.whereType<int>().toList(),
    );
  }

  PersonalityPole _selectPole(
    PersonalityPole first,
    PersonalityPole second,
    Map<PersonalityPole, int> scores,
    Map<PersonalityPole, int> strongResponses,
    Map<PersonalityPole, int> weightedStrongResponses,
  ) {
    final firstScore = scores[first] ?? 0;
    final secondScore = scores[second] ?? 0;
    if (firstScore != secondScore) return firstScore > secondScore ? first : second;

    final firstStrong = strongResponses[first] ?? 0;
    final secondStrong = strongResponses[second] ?? 0;
    if (firstStrong != secondStrong) return firstStrong > secondStrong ? first : second;

    final firstWeighted = weightedStrongResponses[first] ?? 0;
    final secondWeighted = weightedStrongResponses[second] ?? 0;
    if (firstWeighted != secondWeighted) return firstWeighted > secondWeighted ? first : second;

    return _balancedFallback(first, second);
  }

  PersonalityPole _balancedFallback(PersonalityPole first, PersonalityPole second) {
    const fallback = {
      PersonalityAxis.energy: PersonalityPole.internal,
      PersonalityAxis.perception: PersonalityPole.possibility,
      PersonalityAxis.judgment: PersonalityPole.relational,
    };
    final axis = _axisFor(first);
    final preferred = fallback[axis];
    return preferred == second ? second : first;
  }

  Map<String, int> _buildPercentages(Map<PersonalityPole, int> scores) {
    final percentages = <String, int>{};
    for (final pair in const [
      [PersonalityPole.external, PersonalityPole.internal],
      [PersonalityPole.realistic, PersonalityPole.possibility],
      [PersonalityPole.logical, PersonalityPole.relational],
    ]) {
      final first = pair[0];
      final second = pair[1];
      final firstScore = scores[first] ?? 0;
      final secondScore = scores[second] ?? 0;
      final total = firstScore + secondScore;
      final firstPercent = total == 0 ? 50 : ((firstScore / total) * 100).round();
      percentages[first.name] = firstPercent;
      percentages[second.name] = 100 - firstPercent;
    }
    return percentages;
  }

  PersonalityPole _oppositePole(PersonalityPole pole) {
    switch (pole) {
      case PersonalityPole.external:
        return PersonalityPole.internal;
      case PersonalityPole.internal:
        return PersonalityPole.external;
      case PersonalityPole.realistic:
        return PersonalityPole.possibility;
      case PersonalityPole.possibility:
        return PersonalityPole.realistic;
      case PersonalityPole.logical:
        return PersonalityPole.relational;
      case PersonalityPole.relational:
        return PersonalityPole.logical;
    }
  }

  PersonalityAxis _axisFor(PersonalityPole pole) {
    switch (pole) {
      case PersonalityPole.external:
      case PersonalityPole.internal:
        return PersonalityAxis.energy;
      case PersonalityPole.realistic:
      case PersonalityPole.possibility:
        return PersonalityAxis.perception;
      case PersonalityPole.logical:
      case PersonalityPole.relational:
        return PersonalityAxis.judgment;
    }
  }
}
