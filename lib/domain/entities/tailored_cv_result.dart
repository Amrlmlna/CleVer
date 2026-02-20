import 'package:equatable/equatable.dart';
import 'user_profile.dart';

class TailoredCVResult extends Equatable {
  final UserProfile profile;
  final String summary;

  const TailoredCVResult({
    required this.profile,
    required this.summary,
  });

  TailoredCVResult copyWith({
    UserProfile? profile,
    String? summary,
  }) {
    return TailoredCVResult(
      profile: profile ?? this.profile,
      summary: summary ?? this.summary,
    );
  }

  @override
  List<Object?> get props => [profile, summary];
}
