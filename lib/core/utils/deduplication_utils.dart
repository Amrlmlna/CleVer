import 'package:intl/intl.dart';

class DeduplicationUtils {
  /// Normalizes text by removing special characters, multiple spaces, and lowercasing.
  static String normalizeText(String? text) {
    if (text == null || text.isEmpty) return '';
    
    // Normalize abbreviations
    String result = text.toLowerCase();
    result = result.replaceAll(RegExp(r'\bsr\b\.?'), 'senior');
    result = result.replaceAll(RegExp(r'\bjr\b\.?'), 'junior');
    result = result.replaceAll(RegExp(r'\binc\b\.?'), '');
    result = result.replaceAll(RegExp(r'\bllc\b\.?'), '');
    result = result.replaceAll(RegExp(r'\bltd\b\.?'), '');
    result = result.replaceAll(RegExp(r'\bcorp\b\.?'), '');
    
    return result
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Normalizes date strings into YYYY-MM format.
  /// Ignores days and fallbacks to YYYY if month is missing.
  static String normalizeDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'unknown';

    final text = dateStr.toLowerCase().trim();

    if (text == 'present' || text == 'sekarang' || text == 'saat ini') {
      return 'present';
    }

    // 1. Try common ISO-like formats (YYYY-MM-DD or YYYY-MM)
    final isoRegex = RegExp(r'^(\d{4})[-/](\d{1,2})');
    final isoMatch = isoRegex.firstMatch(text);
    if (isoMatch != null) {
      final year = isoMatch.group(1)!;
      final month = isoMatch.group(2)!.padLeft(2, '0');
      return '$year-$month';
    }

    // 2. Try Year only
    final yearRegex = RegExp(r'^(\d{4})$');
    if (yearRegex.hasMatch(text)) {
      return text;
    }

    // 3. Try Month Name + Year (e.g., "October 2023" or "Oct 2023")
    try {
      // Common formats
      final List<String> formats = [
        'MMMM yyyy',
        'MMM yyyy',
        'MM/yyyy',
        'M/yyyy',
      ];

      for (var format in formats) {
        try {
          final date = DateFormat(format).parseLoose(text);
          return DateFormat('yyyy-MM').format(date);
        } catch (_) {}
      }
    } catch (_) {}

    // 4. Last resort: Just extract the first 4-digit number found (Year)
    final yearExtract = RegExp(r'(\d{4})').firstMatch(text);
    if (yearExtract != null) {
      return yearExtract.group(1)!;
    }

    return 'unknown';
  }

  /// Generates a unique fingerprint based on key identity fields.
  /// Immutable identity anchor for an entry.
  static String generateFingerprint({
    required String? companyOrSchool,
    required String? titleOrDegree,
    required String? startDate,
  }) {
    final nCompany = normalizeText(companyOrSchool);
    final nTitle = normalizeText(titleOrDegree);
    final nDate = normalizeDate(startDate);

    return '$nCompany|$nTitle|$nDate';
  }

  /// Checks if two strings are "fuzzy" matches using Levenshtein distance.
  /// Returns true if similarity is above the specified threshold (0.0 to 1.0).
  static bool isFuzzyMatch(String? a, String? b, {double threshold = 0.85}) {
    final str1 = normalizeText(a);
    final str2 = normalizeText(b);

    if (str1 == str2) return true;
    if (str1.isEmpty || str2.isEmpty) return false;

    final distance = _levenshtein(str1, str2);
    final maxLength = str1.length > str2.length ? str1.length : str2.length;
    final similarity = 1.0 - (distance / maxLength);

    return similarity >= threshold;
  }

  static int _levenshtein(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    List<int> v0 = List<int>.generate(t.length + 1, (i) => i);
    List<int> v1 = List<int>.filled(t.length + 1, 0);

    for (int i = 0; i < s.length; i++) {
      v1[0] = i + 1;
      for (int j = 0; j < t.length; j++) {
        int cost = (s[i] == t[j]) ? 0 : 1;
        v1[j + 1] = _min3(v1[j] + 1, v0[j + 1] + 1, v0[j] + cost);
      }
      for (int j = 0; j < t.length + 1; j++) {
        v0[j] = v1[j];
      }
    }
    return v0[t.length];
  }

  static int _min3(int a, int b, int c) {
    if (a < b) return (a < c) ? a : c;
    return (b < c) ? b : c;
  }
}
