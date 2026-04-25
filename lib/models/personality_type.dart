class PersonalityType {
  final String id;
  final String name;
  final String subtitle;
  final String description;
  final List<String> strengths;
  final List<String> stressPatterns;
  final List<String> goodMatches;
  final List<String> relationTips;
  final List<String> avoidTips;
  final String dailyAction;

  const PersonalityType({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.description,
    required this.strengths,
    required this.stressPatterns,
    required this.goodMatches,
    required this.relationTips,
    required this.avoidTips,
    required this.dailyAction,
  });
}