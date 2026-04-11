class FormatUtils {
  /// Safely converts any dynamic value into a String.
  /// Handles Strings, Lists (joined with bullets), and nulls.
  static String ensureString(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    if (value is String) return value;
    if (value is List) {
      if (value.isEmpty) return fallback;
      // Filter out nulls and convert to strings
      final items = value.where((e) => e != null).map((e) => e.toString()).toList();
      if (items.isEmpty) return fallback;
      
      // If items already start with a bullet, don't add another one
      return items.map((item) {
        final trimmed = item.trim();
        if (trimmed.startsWith('-') || trimmed.startsWith('•') || trimmed.startsWith('*')) {
          return trimmed;
        }
        return '- $trimmed';
      }).join('\n');
    }
    return value.toString();
  }
}
