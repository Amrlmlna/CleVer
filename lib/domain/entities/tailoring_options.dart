class TailoringOptions {
  final int maxSkills;
  final bool strictMode;
  final bool conciseMode;
  final String? outputLanguage; // null = auto (use device locale)

  const TailoringOptions({
    this.maxSkills = 10,
    this.strictMode = false,
    this.conciseMode = true,
    this.outputLanguage,
  });

  Map<String, dynamic> toJson() => {
    'maxSkills': maxSkills,
    'strictMode': strictMode,
    'conciseMode': conciseMode,
  };

  TailoringOptions copyWith({
    int? maxSkills,
    bool? strictMode,
    bool? conciseMode,
    String? Function()? outputLanguage,
  }) {
    return TailoringOptions(
      maxSkills: maxSkills ?? this.maxSkills,
      strictMode: strictMode ?? this.strictMode,
      conciseMode: conciseMode ?? this.conciseMode,
      outputLanguage: outputLanguage != null
          ? outputLanguage()
          : this.outputLanguage,
    );
  }
}
