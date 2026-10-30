import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CleverPersona { student, jobSeeker, careerSwitcher }

enum CleverBudget { under20k, around30k, around50k, over100k }

enum CleverReason { companyResearch, repromptAi, manualTemplate, repeatedForms }

class CleverWelcomeState {
  const CleverWelcomeState({
    this.step = 0,
    this.persona,
    this.budget,
    this.hasSingleCv,
    this.applicationsPerDay = 10,
    this.reasons = const {},
    this.consentedPrivacy = false,
    this.consentedTerms = false,
  });

  static const int stepCount = 7;

  final int step;
  final CleverPersona? persona;
  final CleverBudget? budget;
  final bool? hasSingleCv;
  final int applicationsPerDay;
  final Set<CleverReason> reasons;
  final bool consentedPrivacy;
  final bool consentedTerms;

  bool get canContinue {
    return switch (step) {
      0 => persona != null,
      1 => budget != null,
      2 => hasSingleCv != null,
      3 => true,
      4 => reasons.isNotEmpty,
      5 => true,
      6 => consentedPrivacy && consentedTerms,
      _ => false,
    };
  }

  bool get isComplete => step >= stepCount - 1;

  CleverWelcomeState copyWith({
    int? step,
    CleverPersona? persona,
    CleverBudget? budget,
    bool? hasSingleCv,
    int? applicationsPerDay,
    Set<CleverReason>? reasons,
    bool? consentedPrivacy,
    bool? consentedTerms,
  }) {
    return CleverWelcomeState(
      step: step ?? this.step,
      persona: persona ?? this.persona,
      budget: budget ?? this.budget,
      hasSingleCv: hasSingleCv ?? this.hasSingleCv,
      applicationsPerDay: applicationsPerDay ?? this.applicationsPerDay,
      reasons: reasons ?? this.reasons,
      consentedPrivacy: consentedPrivacy ?? this.consentedPrivacy,
      consentedTerms: consentedTerms ?? this.consentedTerms,
    );
  }

  Map<String, dynamic> toJson() => {
    'step': step,
    'persona': persona?.name,
    'budget': budget?.name,
    'hasSingleCv': hasSingleCv,
    'applicationsPerDay': applicationsPerDay,
    'reasons': reasons.map((r) => r.name).toList(),
    'consentedPrivacy': consentedPrivacy,
    'consentedTerms': consentedTerms,
  };

  factory CleverWelcomeState.fromJson(Map<String, dynamic> json) {
    return CleverWelcomeState(
      step: _asInt(json['step'], 0),
      persona: _enumOrNull(CleverPersona.values, json['persona']),
      budget: _enumOrNull(CleverBudget.values, json['budget']),
      hasSingleCv: json['hasSingleCv'] is bool
          ? json['hasSingleCv']! as bool
          : null,
      applicationsPerDay: _asInt(json['applicationsPerDay'], 10).clamp(10, 100),
      reasons: {
        for (final name
            in json['reasons'] is List ? json['reasons']! as List : const [])
          if (_enumOrNull(CleverReason.values, name) case final r?) r,
      },
      consentedPrivacy: json['consentedPrivacy'] is bool,
      consentedTerms: json['consentedTerms'] is bool,
    );
  }

  static int _asInt(Object? value, int fallback) =>
      value is num ? value.toInt() : fallback;

  static T? _enumOrNull<T extends Enum>(List<T> values, Object? name) {
    for (final value in values) {
      if (value.name == name) return value;
    }
    return null;
  }
}

final cleverWelcomeProvider =
    StateNotifierProvider<CleverWelcomeNotifier, CleverWelcomeState>((ref) {
      return CleverWelcomeNotifier();
    });

class CleverWelcomeNotifier extends StateNotifier<CleverWelcomeState> {
  CleverWelcomeNotifier() : super(const CleverWelcomeState()) {
    _restore();
  }

  static const _storageKey = 'clever_welcome_state_v1';
  bool _hydrated = false;

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (!mounted) return;
    if (raw != null) {
      try {
        state = CleverWelcomeState.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
      } catch (_) {
        // Corrupt or outdated payload: start fresh.
      }
    }
    _hydrated = true;
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(state.toJson()));
  }

  void selectPersona(CleverPersona persona) =>
      _update(state.copyWith(persona: persona));

  void selectBudget(CleverBudget budget) =>
      _update(state.copyWith(budget: budget));

  void selectSingleCv(bool hasSingleCv) =>
      _update(state.copyWith(hasSingleCv: hasSingleCv));

  void setApplicationsPerDay(int count) =>
      _update(state.copyWith(applicationsPerDay: count.clamp(10, 100)));

  void toggleReason(CleverReason reason) {
    final reasons = {...state.reasons};
    if (!reasons.remove(reason)) reasons.add(reason);
    _update(state.copyWith(reasons: reasons));
  }

  void setConsentedPrivacy(bool value) =>
      _update(state.copyWith(consentedPrivacy: value));

  void setConsentedTerms(bool value) =>
      _update(state.copyWith(consentedTerms: value));

  void next() {
    if (!state.canContinue) return;
    _update(
      state.copyWith(
        step: (state.step + 1).clamp(0, CleverWelcomeState.stepCount - 1),
      ),
    );
  }

  void back() {
    if (state.step == 0) return;
    _update(state.copyWith(step: state.step - 1));
  }

  Future<void> reset() async {
    state = const CleverWelcomeState();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  void _update(CleverWelcomeState next) {
    state = next;
    if (_hydrated) _persist();
  }
}
