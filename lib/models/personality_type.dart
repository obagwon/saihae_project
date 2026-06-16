import 'test_question.dart';

class PersonalityType {
  final String id;
  final String name;
  final String subtitle;
  final IconDataCode icon;
  final String description;
  final List<String> traits;
  final List<String> strengths;
  final List<String> cautions;
  final String comfortZone;
  final String relationshipStyle;
  final List<String> recommendedActivities;
  final String dailyAction;
  final List<PersonalityPole> poles;

  const PersonalityType({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.description,
    required this.traits,
    required this.strengths,
    required this.cautions,
    required this.comfortZone,
    required this.relationshipStyle,
    required this.recommendedActivities,
    required this.dailyAction,
    required this.poles,
  });

  List<String> get stressPatterns => cautions;
  List<String> get goodMatches => [comfortZone, relationshipStyle];
  List<String> get relationTips => [relationshipStyle, ...strengths.take(2)];
  List<String> get avoidTips => cautions;
}

enum IconDataCode {
  compass,
  heart,
  spark,
  rainbow,
  anchor,
  nest,
  moon,
  lantern,
}
