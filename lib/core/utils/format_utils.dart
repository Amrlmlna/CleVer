class FormatUtils {
  /// Safely converts any dynamic value into a String.
  /// Handles Strings, Lists (joined with bullets), and nulls.
  static String ensureString(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;

    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return fallback;

      if (trimmed.contains('\n')) return trimmed;

      final hasBullets =
          trimmed.contains('•') ||
          trimmed.contains(' * ') ||
          trimmed.contains(' - ');
      if (hasBullets) {
        final parts = trimmed.split(RegExp(r'[•*]|\s-\s|\s\*\s'));
        final filtered = parts
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
        if (filtered.length > 1) {
          return filtered.map((s) => '- $s').join('\n');
        }
      }
      return trimmed;
    }

    if (value is List) {
      if (value.isEmpty) return fallback;
      final items = value
          .where((e) => e != null)
          .map((e) => e.toString())
          .toList();
      if (items.isEmpty) return fallback;

      return items
          .map((item) {
            final trimmed = item.trim();
            if (trimmed.startsWith('-') ||
                trimmed.startsWith('•') ||
                trimmed.startsWith('*')) {
              return trimmed;
            }
            return '- $trimmed';
          })
          .join('\n');
    }
    return value.toString();
  }
}
