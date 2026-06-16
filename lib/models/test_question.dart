enum PersonalityAxis { energy, perception, judgment }

enum PersonalityPole {
  external,
  internal,
  realistic,
  possibility,
  logical,
  relational,
}

class TestQuestion {
  final String id;
  final String text;
  final PersonalityAxis axis;
  final PersonalityPole positivePole;
  final int tieBreakWeight;

  const TestQuestion({
    required this.id,
    required this.text,
    required this.axis,
    required this.positivePole,
    this.tieBreakWeight = 1,
  });
}

class AnswerOption {
  final String label;
  final int score;

  const AnswerOption({required this.label, required this.score});
}
