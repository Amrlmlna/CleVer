import 'package:equatable/equatable.dart';
import 'user_profile.dart';
import 'tailor_analysis.dart';

class TailoredCVResult extends Equatable {
  final UserProfile profile;
  final String summary;
  final TailorAnalysis? analysis;

  const TailoredCVResult({
    required this.profile,
    required this.summary,
    this.analysis,
  });

  TailoredCVResult copyWith({
    UserProfile? profile,
    String? summary,
    TailorAnalysis? analysis,
  }) {
    return TailoredCVResult(
      profile: profile ?? this.profile,
      summary: summary ?? this.summary,
      analysis: analysis ?? this.analysis,
    );
  }

  @override
  List<Object?> get props => [profile, summary, analysis];
}
