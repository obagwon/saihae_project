class RecommendationItem {
  final String title;
  final String description;
  final String actionText;
  final String? personalityNote;
  final String? safetyNote;

  const RecommendationItem({
    required this.title,
    required this.description,
    required this.actionText,
    this.personalityNote,
    this.safetyNote,
  });
}
