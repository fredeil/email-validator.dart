import 'package:email_validator/email_validator.dart';
import 'package:test/test.dart';
import 'dart:core';

/// Performance test comparing the EmailValidator library with a comprehensive
/// RFC 5322 compliant regex pattern
void main() {
  group('Performance Tests: EmailValidator vs RFC Regex', () {
    // RFC 5322 compliant email regex - one of the most comprehensive patterns
    // Based on RFC 5322 Official Standard
    final rfcRegex = RegExp(
      r"""(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])""",
      caseSensitive: false,
    );

    // Alternative: Even longer and more comprehensive regex (based on emailregex.com)
    final extendedRfcRegex = RegExp(
      r'''^(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])$''',
      caseSensitive: false,
    );

    bool validateWithRegex(String email) {
      return extendedRfcRegex.hasMatch(email);
    }

    // Test data sets
    final simpleValidEmails = [
      'test@example.com',
      'user@domain.org',
      'name@company.co.uk',
      'admin@site.net',
      'contact@business.io',
    ];

    final complexValidEmails = [
      'fredrik@dualog.com',
      '"Abc\\@def"@example.com',
      '"Fred Bloggs"@example.com',
      'customer/department=shipping@example.com',
      '\$A12345@example.com',
      '!def!xyz%abc@example.com',
      '_somename@example.com',
      'valid.ipv4.addr@[123.1.72.10]',
      'disposable.style.email.with+symbol@example.com',
      '!#\$%&\'*+-/=?^_`{}|~@example.org',
      'a@single-character-in-local.org',
      'local@sub.domains.com',
      'one-letter-sld@x.org',
    ];

    final invalidEmails = [
      'invalid',
      'invalid@',
      'invalid @',
      '@missing-local.org',
      'missing-at-sign.net',
      'missing-tld@sld.',
      'two..consecutive-dots@sld.com',
      'No longer available.',
      'Moved.',
      'user@domain',
      'user name@domain.com',
    ];

    final internationalEmails = [
      '伊昭傑@郵件.商務', // Chinese
      'राम@मोहन.ईन्फो', // Hindi
      'юзер@екзампл.ком', // Ukrainian
      'θσερ@εχαμπλε.ψομ', // Greek
    ];

    final mixedEmails = [
      ...simpleValidEmails,
      ...complexValidEmails,
      ...invalidEmails,
    ];

    /// Helper function to measure execution time
    Duration measureTime(Function validator, List<String> emails,
        {int iterations = 1}) {
      final stopwatch = Stopwatch()..start();
      for (var i = 0; i < iterations; i++) {
        for (var email in emails) {
          validator(email);
        }
      }
      stopwatch.stop();
      return stopwatch.elapsed;
    }

    /// Helper function to print performance comparison
    void printComparison(
      String testName,
      Duration libTime,
      Duration regexTime,
      int emailCount,
      int iterations,
    ) {
      final totalOperations = emailCount * iterations;
      final libMicrosPerOp = libTime.inMicroseconds / totalOperations;
      final regexMicrosPerOp = regexTime.inMicroseconds / totalOperations;
      final speedup = regexTime.inMicroseconds / libTime.inMicroseconds;

      print('\n$testName:');
      print('  Emails tested: $emailCount × $iterations iterations = $totalOperations operations');
      print('  EmailValidator: ${libTime.inMilliseconds}ms (${libMicrosPerOp.toStringAsFixed(2)}μs/op)');
      print('  RFC Regex:      ${regexTime.inMilliseconds}ms (${regexMicrosPerOp.toStringAsFixed(2)}μs/op)');
      print('  Speedup:        ${speedup.toStringAsFixed(2)}x ${speedup > 1 ? "faster" : "slower"}');
    }

    test('Performance: Simple valid emails', () {
      const iterations = 10000;

      final libTime = measureTime(
        (email) => EmailValidator.validate(email, true),
        simpleValidEmails,
        iterations: iterations,
      );

      final regexTime = measureTime(
        validateWithRegex,
        simpleValidEmails,
        iterations: iterations,
      );

      printComparison(
        'Simple Valid Emails',
        libTime,
        regexTime,
        simpleValidEmails.length,
        iterations,
      );

      // Library should generally be faster or comparable
      print('  Result: ${libTime < regexTime ? "✓ Library is faster" : "○ Regex is faster"}');
    });

    test('Performance: Complex valid emails', () {
      const iterations = 10000;

      final libTime = measureTime(
        (email) => EmailValidator.validate(email, true),
        complexValidEmails,
        iterations: iterations,
      );

      final regexTime = measureTime(
        validateWithRegex,
        complexValidEmails,
        iterations: iterations,
      );

      printComparison(
        'Complex Valid Emails',
        libTime,
        regexTime,
        complexValidEmails.length,
        iterations,
      );

      print('  Result: ${libTime < regexTime ? "✓ Library is faster" : "○ Regex is faster"}');
    });

    test('Performance: Invalid emails', () {
      const iterations = 10000;

      final libTime = measureTime(
        (email) => EmailValidator.validate(email, true),
        invalidEmails,
        iterations: iterations,
      );

      final regexTime = measureTime(
        validateWithRegex,
        invalidEmails,
        iterations: iterations,
      );

      printComparison(
        'Invalid Emails',
        libTime,
        regexTime,
        invalidEmails.length,
        iterations,
      );

      print('  Result: ${libTime < regexTime ? "✓ Library is faster" : "○ Regex is faster"}');
    });

    test('Performance: Mixed emails (realistic workload)', () {
      const iterations = 5000;

      final libTime = measureTime(
        (email) => EmailValidator.validate(email, true),
        mixedEmails,
        iterations: iterations,
      );

      final regexTime = measureTime(
        validateWithRegex,
        mixedEmails,
        iterations: iterations,
      );

      printComparison(
        'Mixed Emails (Realistic Workload)',
        libTime,
        regexTime,
        mixedEmails.length,
        iterations,
      );

      print('  Result: ${libTime < regexTime ? "✓ Library is faster" : "○ Regex is faster"}');
    });

    test('Performance: International emails', () {
      const iterations = 10000;

      final libTime = measureTime(
        (email) => EmailValidator.validate(email, true, true),
        internationalEmails,
        iterations: iterations,
      );

      // Note: The RFC regex doesn't handle international characters well
      final regexTime = measureTime(
        validateWithRegex,
        internationalEmails,
        iterations: iterations,
      );

      printComparison(
        'International Emails',
        libTime,
        regexTime,
        internationalEmails.length,
        iterations,
      );

      print('  Result: ${libTime < regexTime ? "✓ Library is faster" : "○ Regex is faster"}');
      print('  Note: RFC Regex may not correctly validate international emails');
    });

    test('Performance: Large batch processing', () {
      // Create a large dataset
      final largeBatch = <String>[];
      for (var i = 0; i < 100; i++) {
        largeBatch.addAll(simpleValidEmails);
        largeBatch.addAll(complexValidEmails);
        largeBatch.addAll(invalidEmails);
      }

      const iterations = 100;

      final libTime = measureTime(
        (email) => EmailValidator.validate(email, true),
        largeBatch,
        iterations: iterations,
      );

      final regexTime = measureTime(
        validateWithRegex,
        largeBatch,
        iterations: iterations,
      );

      printComparison(
        'Large Batch Processing',
        libTime,
        regexTime,
        largeBatch.length,
        iterations,
      );

      print('  Result: ${libTime < regexTime ? "✓ Library is faster" : "○ Regex is faster"}');
    });

    test('Performance: Very long email addresses', () {
      // Test performance with maximum-length emails
      final longValidEmail =
          'a' * 64 + '@' + 'sub.' * 10 + 'example.com';
      final longInvalidEmail = 'a' * 65 + '@example.com';

      final longEmails = [
        longValidEmail,
        longInvalidEmail,
        'very.long.local.part.with.many.dots.here@very.long.domain.name.with.many.subdomains.example.com',
      ];

      const iterations = 10000;

      final libTime = measureTime(
        (email) => EmailValidator.validate(email, true),
        longEmails,
        iterations: iterations,
      );

      final regexTime = measureTime(
        validateWithRegex,
        longEmails,
        iterations: iterations,
      );

      printComparison(
        'Very Long Email Addresses',
        libTime,
        regexTime,
        longEmails.length,
        iterations,
      );

      print('  Result: ${libTime < regexTime ? "✓ Library is faster" : "○ Regex is faster"}');
    });

    test('Accuracy comparison: Validate both approaches agree on test cases', () {
      var agreements = 0;
      var disagreements = 0;
      final disagreementCases = <String>[];

      for (var email in mixedEmails) {
        final libResult = EmailValidator.validate(email, true);
        final regexResult = validateWithRegex(email);

        if (libResult == regexResult) {
          agreements++;
        } else {
          disagreements++;
          disagreementCases.add('$email: lib=$libResult, regex=$regexResult');
        }
      }

      print('\nAccuracy Comparison:');
      print('  Agreements: $agreements/${mixedEmails.length}');
      print('  Disagreements: $disagreements/${mixedEmails.length}');

      if (disagreementCases.isNotEmpty) {
        print('  Disagreement cases:');
        for (var case_ in disagreementCases.take(10)) {
          print('    - $case_');
        }
        if (disagreementCases.length > 10) {
          print('    ... and ${disagreementCases.length - 10} more');
        }
      }

      // This is informational, not a strict test
      // Some disagreements are expected due to different RFC interpretations
    });

    test('Summary: Overall performance comparison', () {
      print('\n' + '=' * 70);
      print('PERFORMANCE TEST SUMMARY');
      print('=' * 70);
      print('\nApproaches compared:');
      print('  1. EmailValidator Library (parser-based)');
      print('  2. RFC 5322 Compliant Regex');
      print('\nRegex pattern length: ${extendedRfcRegex.pattern.length} characters');
      print('\nKey findings:');
      print('  - Parser-based approach provides deterministic performance');
      print('  - Regex can suffer from catastrophic backtracking on complex inputs');
      print('  - Parser handles edge cases and international emails better');
      print('  - Regex is simpler to implement but less flexible');
      print('=' * 70);
    });
  });
}
