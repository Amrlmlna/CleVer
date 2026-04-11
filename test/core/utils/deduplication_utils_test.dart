import 'package:flutter_test/flutter_test.dart';
import 'package:clever/core/utils/deduplication_utils.dart';

void main() {
  group('DeduplicationUtils Tests', () {
    test('normalizeText should handle case and whitespace', () {
      expect(DeduplicationUtils.normalizeText('  Google LLC  '), 'google');
      expect(DeduplicationUtils.normalizeText('GOOGLE'), 'google');
    });

    test('normalizeDate should force YYYY-MM format', () {
      expect(DeduplicationUtils.normalizeDate('2023-10-27'), '2023-10');
      expect(DeduplicationUtils.normalizeDate('Oct 2023'), '2023-10');
      expect(DeduplicationUtils.normalizeDate('2023'), '2023');
      expect(DeduplicationUtils.normalizeDate('Present'), 'present');
    });

    test('generateFingerprint should be consistent', () {
      final f1 = DeduplicationUtils.generateFingerprint(
        titleOrDegree: 'Dev',
        companyOrSchool: 'Google',
        startDate: '2023-01',
      );
      final f2 = DeduplicationUtils.generateFingerprint(
        titleOrDegree: 'dev',
        companyOrSchool: 'Google ',
        startDate: ' Jan 2023',
      );
      expect(f1, f2);
    });

    test('isFuzzyMatch should detect similar strings', () {
      expect(DeduplicationUtils.isFuzzyMatch('Senior Software Engineer', 'Sr. Software Engineer'), isTrue);
      expect(DeduplicationUtils.isFuzzyMatch('Google Inc.', 'Google LLC'), isTrue);
      expect(DeduplicationUtils.isFuzzyMatch('Apple', 'Orange'), isFalse);
    });
  });
}
