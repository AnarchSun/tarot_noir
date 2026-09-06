enum OrionTone { mystic, gentle, practical }

class UserPreferences {
  const UserPreferences({
    this.orionMemory = false,
    this.personalizedGuidance = false,
    this.dailyReminder = false,
    this.tone = OrionTone.mystic,
  });
  final bool orionMemory;
  final bool personalizedGuidance;
  final bool dailyReminder;
  final OrionTone tone;

  UserPreferences copyWith({
    bool? orionMemory,
    bool? personalizedGuidance,
    bool? dailyReminder,
    OrionTone? tone,
  }) => UserPreferences(
    orionMemory: orionMemory ?? this.orionMemory,
    personalizedGuidance: personalizedGuidance ?? this.personalizedGuidance,
    dailyReminder: dailyReminder ?? this.dailyReminder,
    tone: tone ?? this.tone,
  );

  Map<String, dynamic> toJson() => {
    'orionMemory': orionMemory,
    'personalizedGuidance': personalizedGuidance,
    'dailyReminder': dailyReminder,
    'tone': tone.name,
  };
  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      UserPreferences(
        orionMemory: json['orionMemory'] as bool,
        personalizedGuidance: json['personalizedGuidance'] as bool,
        dailyReminder: json['dailyReminder'] as bool,
        tone: OrionTone.values.byName(json['tone'] as String),
      );
}
