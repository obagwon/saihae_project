class AppSettings {
  final bool onboardingCompleted;
  final bool disclaimerAccepted;

  const AppSettings({
    required this.onboardingCompleted,
    required this.disclaimerAccepted,
  });

  const AppSettings.initial()
      : onboardingCompleted = false,
        disclaimerAccepted = false;

  AppSettings copyWith({
    bool? onboardingCompleted,
    bool? disclaimerAccepted,
  }) {
    return AppSettings(
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      disclaimerAccepted: disclaimerAccepted ?? this.disclaimerAccepted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'onboardingCompleted': onboardingCompleted,
      'disclaimerAccepted': disclaimerAccepted,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      onboardingCompleted: _readBool(json['onboardingCompleted']),
      disclaimerAccepted: _readBool(json['disclaimerAccepted']),
    );
  }

  static bool _readBool(Object? value) {
    if (value is bool) {
      return value;
    }
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    return false;
  }
}
