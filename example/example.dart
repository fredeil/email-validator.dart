import 'package:email_validator/email_validator.dart';

void main() {
  // Basic validation — default: allowTopLevelDomains=false, allowInternational=true
  final examples = [
    ('user@example.com', 'standard address'),
    ('invalid-email', 'missing @'),
    ('user@', 'missing domain'),
    ('" "@example.org', 'quoted space — valid per RFC'),
  ];

  print('--- Basic validation ---');
  for (final (email, note) in examples) {
    final valid = EmailValidator.validate(email);
    print('  ${valid ? '✓' : '✗'} $email  ($note)');
  }

  // Allow top-level domains (useful for intranet/localhost addresses)
  print('\n--- allowTopLevelDomains = true ---');
  for (final email in ['admin@localhost', 'user@intranet']) {
    final valid = EmailValidator.validate(email, true);
    print('  ${valid ? '✓' : '✗'} $email');
  }

  // International addresses (enabled by default)
  print('\n--- International addresses (default: allowed) ---');
  final international = [
    '伊昭傑@郵件.商務', // Chinese
    'θσερ@εχαμπλε.ψομ', // Greek
  ];
  for (final email in international) {
    final validOn = EmailValidator.validate(email); // allowInternational=true
    final validOff =
        EmailValidator.validate(email, false, false); // allowInternational=false
    print('  allowed=$validOn  rejected=${!validOff}  $email');
  }
}
