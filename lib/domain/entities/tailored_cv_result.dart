import 'package:equatable/equatable.dart';
import 'user_profile.dart';

class TailoredCVResult extends Equatable {
  final UserProfile profile;
  final String summary;

  const TailoredCVResult({
    required this.profile,
    required this.summary,
  });

  @override
  List<Object?> get props => [profile, summary];
}
