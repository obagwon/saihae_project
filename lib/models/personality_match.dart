class PersonalityRelationshipMatch {
  final List<PersonalityMatch> bestMatches;
  final List<PersonalityMatch> growthMatches;

  const PersonalityRelationshipMatch({
    required this.bestMatches,
    required this.growthMatches,
  });
}

class PersonalityMatch {
  final String typeId;
  final String reason;

  const PersonalityMatch({
    required this.typeId,
    required this.reason,
  });
}
