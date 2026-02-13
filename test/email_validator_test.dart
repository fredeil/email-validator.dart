import 'package:email_validator/email_validator.dart';
import 'package:test/test.dart';

void main() {
  final List<String> validAddresses = [
    'fredrik@dualog.com',
    '\"Abc\\@def\"@example.com',
    '\"Fred Bloggs\"@example.com',
    '\"Joe\\\\Blow\"@example.com',
    '\"Abc@def\"@example.com',
    'customer/department=shipping@example.com',
    '\$A12345@example.com',
    '!def!xyz%abc@example.com',
    '_somename@example.com',
    'valid.ipv4.addr@[123.1.72.10]',
    'valid.ipv6.addr@[IPv6:0::1]',
    'valid.ipv6.addr@[IPv6:2607:f0d0:1002:51::4]',
    'valid.ipv6.addr@[IPv6:fe80::230:48ff:fe33:bc33]',
    'valid.ipv6.addr@[IPv6:fe80:0000:0000:0000:0202:b3ff:fe1e:8329]',
    'valid.ipv6v4.addr@[IPv6:aaaa:aaaa:aaaa:aaaa:aaaa:aaaa:127.0.0.1]',

    // examples from wikipedia
    'niceandsimple@example.com',
    'very.common@example.com',
    'a.little.lengthy.but.fine@dept.example.com',
    'disposable.style.email.with+symbol@example.com',
    'user@[IPv6:2001:db8:1ff::a0b:dbd0]',
    '\"much.more unusual\"@example.com',
    '\"very.unusual.@.unusual.com\"@example.com',
    '\"very.(),:;<>[]\\\".VERY.\\\"very@\\\\ \\\"very\\\".unusual\"@strange.example.com',
    "!#\$%&'*+-/=?^_`{}|~@example.org",
    "\"()<>[]:,;@\\\\\\\"!#\$%&'*+-/=?^_`{}| ~.a\"@example.org",
    '" "@example.org',

    // examples from https://github.com/Sembiance/email-validator
    '\"\\e\\s\\c\\a\\p\\e\\d\"@sld.com',
    '\"back\\slash\"@sld.com',
    '\"escaped\\\"quote\"@sld.com',
    '\"quoted\"@sld.com',
    '\"quoted-at-sign@sld.org\"@sld.com',
    "&'*+-./=?^_{}~@other-valid-characters-in-local.net",
    '01234567890@numbers-in-local.net',
    'a@single-character-in-local.org',
    'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@letters-in-local.org',
    'backticksarelegit@test.com',
    'bracketed-IP-instead-of-domain@[127.0.0.1]',
    'country-code-tld@sld.rw',
    'country-code-tld@sld.uk',
    'letters-in-sld@123.com',
    'local@dash-in-sld.com',
    'local@sld.newTLD',
    'local@sub.domains.com',
    'mixed-1234-in-{+^}-local@sld.net',
    'one-character-third-level@a.example.com',
    'one-letter-sld@x.org',
    'punycode-numbers-in-tld@sld.xn--3e0b707e',
    'single-character-in-sld@x.org',
    'the-character-limit@for-each-part.of-the-domain.is-sixty-three-characters.this-is-exactly-sixty-three-characters-so-it-is-valid-blah-blah.com',
    'the-total-length@of-an-entire-address.cannot-be-longer-than-two-hundred-and-fifty-four-characters.and-this-address-is-254-characters-exactly.so-it-should-be-valid.and-im-going-to-add-some-more-words-here.to-increase-the-length-blah-blah-blah-blah-bla.org',
    'uncommon-tld@sld.mobi',
    'uncommon-tld@sld.museum',
    'uncommon-tld@sld.travel'
  ];

  final List<String> invalidAddresses = [
    'invalid',
    'invalid@',
    'invalid @',
    'invalid@[555.666.777.888]',
    'invalid@[IPv6:123456]',
    'invalid@[127.0.0.1.]',
    'invalid@[127.0.0.1].',
    'invalid@[127.0.0.1]x',

    // examples from wikipedia
    'Abc.example.com',
    'A@b@c@example.com',
    'a\"b(c)d,e:f;g<h>i[j\\k]l@example.com',
    'just\"not\"right@example.com',
    'this is\"not\\allowed@example.com',
    'this\\ still\\\"not\\\\allowed@example.com',

    // examples from https://github.com/Sembiance/email-validator
    '! #\$%`|@invalid-characters-in-local.org',
    '(),:;`|@more-invalid-characters-in-local.org',
    '* .local-starts-with-dot@sld.com',
    '<>@[]`|@even-more-invalid-characters-in-local.org',
    '@missing-local.org',
    'IP-and-port@127.0.0.1:25',
    'another-invalid-ip@127.0.0.256',
    'invalid',
    'invalid-characters-in-sld@! \"#\$%(),/;<>_[]`|.org',
    'invalid-ip@127.0.0.1.26',
    'local-ends-with-dot.@sld.com',
    'missing-at-sign.net',
    'missing-sld@.com',
    'missing-tld@sld.',
    'sld-ends-with-dash@sld-.com',
    'sld-starts-with-dashsh@-sld.com',
    'the-character-limit@for-each-part.of-the-domain.is-sixty-three-characters.this-is-exactly-sixty-four-characters-so-it-is-invalid-blah-blah.com',
    'the-local-part-is-invalid-if-it-is-longer-than-sixty-four-characters@sld.net',
    'the-total-length@of-an-entire-address.cannot-be-longer-than-two-hundred-and-fifty-four-characters.and-this-address-is-255-characters-exactly.so-it-should-be-invalid.and-im-going-to-add-some-more-words-here.to-increase-the-lenght-blah-blah-blah-blah-bl.org',
    'two..consecutive-dots@sld.com',
    'unbracketed-IP@127.0.0.1',
    'onelettertld@gmail.c',

    // examples of real (invalid) input from real users.
    'No longer available.',
    'Moved.',
  ];

  final List<String> validInternational = [
    '伊昭傑@郵件.商務', // Chinese
    'राम@मोहन.ईन्फो', // Hindi
    'юзер@екзампл.ком', // Ukranian
    'θσερ@εχαμπλε.ψομ', // Greek
  ];

  test('Validate invalidAddresses are invalid emails', () {
    for (var actual in invalidAddresses) {
      expect(EmailValidator.validate(actual, true), equals(false),
          reason: 'E-mail: ' + actual.toString());
    }
  });

  test('Validate validAddresses are valid emails', () {
    for (var actual in validAddresses) {
      expect(EmailValidator.validate(actual, true), equals(true),
          reason: 'E-mail: ' + actual);
    }
  });

  test('Validate validInternational are valid emails', () {
    for (var actual in validInternational) {
      expect(EmailValidator.validate(actual, true, true), equals(true),
          reason: 'E-mail: ' + actual);
    }
  });

  test('Validate empty and whitespace-only input is invalid', () {
    expect(EmailValidator.validate(''), equals(false));
    expect(EmailValidator.validate(' '), equals(false));
    expect(EmailValidator.validate('\t'), equals(false));
  });

  test('Validate default parameter values', () {
    // Default: allowTopLevelDomains = false, allowInternational = true
    expect(EmailValidator.validate('user@example.com'), equals(true),
        reason: 'Standard email with defaults should be valid');
    expect(EmailValidator.validate('user@example'), equals(false),
        reason: 'Top-level domain should be rejected by default');
    expect(EmailValidator.validate('伊昭傑@郵件.商務'), equals(true),
        reason: 'International email should be valid by default');
  });

  test('Validate allowTopLevelDomains parameter', () {
    expect(EmailValidator.validate('admin@mailserver', false), equals(false),
        reason:
            'TLD-only address should be invalid when allowTopLevelDomains is false');
    expect(EmailValidator.validate('admin@mailserver', true), equals(true),
        reason:
            'TLD-only address should be valid when allowTopLevelDomains is true');
    expect(EmailValidator.validate('user@example', true), equals(true),
        reason:
            'Single-label domain should be valid when allowTopLevelDomains is true');
  });

  test('Validate allowInternational parameter rejects non-ASCII when false',
      () {
    expect(EmailValidator.validate('伊昭傑@郵件.商務', false, false), equals(false),
        reason:
            'International email should be invalid when allowInternational is false');
    expect(
        EmailValidator.validate('user@example.com', false, false), equals(true),
        reason: 'ASCII email should be valid regardless of allowInternational');
  });

  test('Validate local-part length boundary', () {
    final local64 = 'a' * 64;
    final local65 = 'a' * 65;
    expect(EmailValidator.validate('$local64@x.org'), equals(true),
        reason: '64-character local-part should be valid');
    expect(EmailValidator.validate('$local65@x.org'), equals(false),
        reason: '65-character local-part should be invalid');
  });

  test('Validate total email length boundary', () {
    // The validator rejects emails with length >= 255, so 254 is max valid
    const valid254 =
        'the-total-length@of-an-entire-address.cannot-be-longer-than-two-hundred-and-fifty-four-characters.and-this-address-is-254-characters-exactly.so-it-should-be-valid.and-im-going-to-add-some-more-words-here.to-increase-the-length-blah-blah-blah-blah-bla.org';
    const invalid255 =
        'the-total-length@of-an-entire-address.cannot-be-longer-than-two-hundred-and-fifty-four-characters.and-this-address-is-255-characters-exactly.so-it-should-be-invalid.and-im-going-to-add-some-more-words-here.to-increase-the-lenght-blah-blah-blah-blah-bl.org';
    expect(valid254.length, equals(254));
    expect(EmailValidator.validate(valid254), equals(true),
        reason: '254-character email should be valid');
    expect(invalid255.length, equals(255));
    expect(EmailValidator.validate(invalid255), equals(false),
        reason: '255-character email should be invalid');
  });

  test('Validate domain label length boundary', () {
    expect(
        EmailValidator.validate(
            'the-character-limit@for-each-part.of-the-domain.is-sixty-three-characters.this-is-exactly-sixty-three-characters-so-it-is-valid-blah-blah.com'),
        equals(true),
        reason: '63-character domain label should be valid');
    expect(
        EmailValidator.validate(
            'the-character-limit@for-each-part.of-the-domain.is-sixty-three-characters.this-is-exactly-sixty-four-characters-so-it-is-invalid-blah-blah.com'),
        equals(false),
        reason: '64-character domain label should be invalid');
  });

  test('Validate domain starting or ending with hyphen is invalid', () {
    expect(EmailValidator.validate('user@-example.com'), equals(false),
        reason: 'Domain starting with hyphen should be invalid');
    expect(EmailValidator.validate('user@example-.com'), equals(false),
        reason: 'Domain label ending with hyphen should be invalid');
  });

  test('Validate double hyphens within domain are valid', () {
    expect(EmailValidator.validate('user@a--b.com'), equals(true),
        reason: 'Double hyphens within a domain label should be valid');
  });

  test('Validate numeric-only TLD is invalid', () {
    expect(EmailValidator.validate('user@example.123'), equals(false),
        reason: 'Numeric-only TLD should be invalid');
    expect(EmailValidator.validate('user@123', true), equals(false),
        reason: 'Numeric-only single-label domain should be invalid');
  });

  test('Validate domain with leading dot or trailing dot is invalid', () {
    expect(EmailValidator.validate('user@.com'), equals(false),
        reason: 'Domain with leading dot should be invalid');
    expect(EmailValidator.validate('user@com.'), equals(false),
        reason: 'Domain with trailing dot should be invalid');
  });

  test('Validate multiple subdomains are valid', () {
    expect(EmailValidator.validate('user@sub.domain.example.com'), equals(true),
        reason: 'Multiple subdomains should be valid');
    expect(EmailValidator.validate('user@a.b.c.d.e.com'), equals(true),
        reason: 'Many subdomain levels should be valid');
    expect(EmailValidator.validate('user@example.co.uk'), equals(true),
        reason: 'Country code TLD with SLD should be valid');
  });

  test('Validate local-part with dots', () {
    expect(EmailValidator.validate('.user@example.com'), equals(false),
        reason: 'Local-part starting with dot should be invalid');
    expect(EmailValidator.validate('user.@example.com'), equals(false),
        reason: 'Local-part ending with dot should be invalid');
    expect(EmailValidator.validate('user..name@example.com'), equals(false),
        reason: 'Consecutive dots in local-part should be invalid');
    expect(EmailValidator.validate('user.name@example.com'), equals(true),
        reason: 'Single dot in local-part should be valid');
  });

  test('Validate missing local-part or domain is invalid', () {
    expect(EmailValidator.validate('@example.com'), equals(false),
        reason: 'Missing local-part should be invalid');
    expect(EmailValidator.validate('user@'), equals(false),
        reason: 'Missing domain should be invalid');
    expect(EmailValidator.validate('@'), equals(false),
        reason: 'Only @ sign should be invalid');
  });

  test('Validate multiple @ signs is invalid', () {
    expect(EmailValidator.validate('user@@example.com'), equals(false),
        reason: 'Double @ should be invalid');
  });

  test('Validate spaces in email are invalid', () {
    expect(EmailValidator.validate('user name@example.com'), equals(false),
        reason: 'Space in local-part should be invalid');
    expect(EmailValidator.validate('user@exam ple.com'), equals(false),
        reason: 'Space in domain should be invalid');
  });

  test('Validate special characters in local-part', () {
    expect(EmailValidator.validate('user+tag@example.com'), equals(true),
        reason: 'Plus sign in local-part should be valid');
    expect(EmailValidator.validate('user+tag+tag2@example.com'), equals(true),
        reason: 'Multiple plus signs in local-part should be valid');
  });

  test('Validate quoted strings edge cases', () {
    expect(EmailValidator.validate('"test"@example.com', true), equals(true),
        reason: 'Quoted local-part should be valid');
    expect(EmailValidator.validate('""@example.com', true), equals(true),
        reason: 'Empty quoted local-part should be valid');
    expect(EmailValidator.validate('"@"@example.com', true), equals(true),
        reason: 'Quoted @ sign in local-part should be valid');
    expect(EmailValidator.validate('"unclosed@example.com'), equals(false),
        reason: 'Unclosed quote should be invalid');
  });

  test('Validate IPv4 literal edge cases', () {
    expect(EmailValidator.validate('user@[255.255.255.255]'), equals(true),
        reason: 'Max octets IPv4 should be valid');
    expect(EmailValidator.validate('user@[256.0.0.0]'), equals(false),
        reason: 'IPv4 octet > 255 should be invalid');
    expect(EmailValidator.validate('user@[1.2.3]'), equals(false),
        reason: 'IPv4 with only 3 octets should be invalid');
    expect(EmailValidator.validate('user@[1.2.3.4.5]'), equals(false),
        reason: 'IPv4 with 5 octets should be invalid');
    expect(EmailValidator.validate('user@[1.2.3.]'), equals(false),
        reason: 'IPv4 with trailing dot should be invalid');
  });

  test('Validate IPv6 literal edge cases', () {
    expect(EmailValidator.validate('user@[IPv6:::1]'), equals(true),
        reason: 'IPv6 loopback should be valid');
    expect(EmailValidator.validate('user@[IPv6:1::1]'), equals(true),
        reason: 'IPv6 compact form should be valid');
    expect(EmailValidator.validate('user@[IPv6:1:2:3:4:5:6:7:8]'), equals(true),
        reason: 'IPv6 full form should be valid');
    expect(
        EmailValidator.validate('user@[IPv6:1:2:3:4:5:6:7:8:9]'), equals(false),
        reason: 'IPv6 with too many groups should be invalid');
  });

  test('Validate IPv6v4 literal edge cases', () {
    expect(
        EmailValidator.validate(
            'user@[IPv6:aaaa:aaaa:aaaa:aaaa:aaaa:aaaa:127.0.0.1]'),
        equals(true),
        reason: 'Valid IPv6v4 address should be valid');
    expect(
        EmailValidator.validate(
            'user@[IPv6:aaaa:aaaa:aaaa:aaaa:aaaa:aaaa:256.0.0.0]'),
        equals(false),
        reason: 'IPv6v4 with invalid IPv4 part should be invalid');
  });

  test('Validate unbracketed IP domain is invalid', () {
    expect(EmailValidator.validate('user@123.123.123.123'), equals(false),
        reason:
            'Unbracketed IP should be treated as numeric domain and be invalid');
  });

  test('Validate underscore in domain is invalid', () {
    expect(EmailValidator.validate('user@exam_ple.com'), equals(false),
        reason: 'Underscore in domain should be invalid');
  });

  test('Validate single-character TLD is invalid', () {
    expect(EmailValidator.validate('a@b.c'), equals(false),
        reason: 'Single-character TLD should be invalid');
  });

  test('Validate minimal valid email addresses', () {
    expect(EmailValidator.validate('a@b.cc'), equals(true),
        reason: 'Minimal valid email should pass');
    expect(EmailValidator.validate('a@bb.cc'), equals(true),
        reason: 'Minimal email with 2-char SLD should pass');
  });

  test('Validate domain with numeric subdomain and alpha TLD', () {
    expect(EmailValidator.validate('user@123.com'), equals(true),
        reason: 'Numeric subdomain with alphabetic TLD should be valid');
    expect(EmailValidator.validate('user@123abc.com'), equals(true),
        reason: 'Alphanumeric subdomain should be valid');
  });
}
