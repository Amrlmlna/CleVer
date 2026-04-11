class TailoringOptions {
  final int maxSkills;
  final bool strictMode;
  final bool conciseMode;

  const TailoringOptions({
    this.maxSkills = 10,
    this.strictMode = false,
    this.conciseMode = true,
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
  }) {
    return TailoringOptions(
      maxSkills: maxSkills ?? this.maxSkills,
      strictMode: strictMode ?? this.strictMode,
      conciseMode: conciseMode ?? this.conciseMode,
    );
  }
}
