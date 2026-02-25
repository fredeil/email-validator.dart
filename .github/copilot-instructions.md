# Copilot Instructions

## Commands

```bash
dart pub get          # install dependencies
dart test             # run all tests
dart test test/email_validator_test.dart  # run the single test file
dart analyze --fatal-infos  # lint/analyze
dart format --output=none --set-exit-if-changed .  # check formatting
dart format .         # auto-format
```

## Architecture

This is a minimal single-file Dart package (`lib/email_validator.dart`) that validates email addresses without using RegEx, implementing RFC-compliant parsing manually.

The `EmailValidator` class uses a **cursor-based parser** with a shared static `_index` field that advances through the email string. Parsing proceeds in two phases:
1. **Local part** – either a quoted string (`_skipQuoted`) or dot-separated atoms (`_skipAtom`)
2. **Domain part** – either a domain name (`_skipDomain`/`_skipSubDomain`) or an address literal (`_skipIPv4Literal`/`_skipIPv6Literal`)

`SubdomainType` enum tracks whether the current subdomain is alphabetic, numeric, or alphanumeric — used to reject all-numeric TLDs (e.g. `user@127.0.0.1` without brackets).

Public API is a single static method:
```dart
EmailValidator.validate(String email, [bool allowTopLevelDomains = false, bool allowInternational = true])
```

## Key Conventions

- All private helpers are `static` and mutate the shared `static int _index` — the class is stateless between calls (reset at the start of `validate`), but **not thread-safe**.
- `allowInternational` controls whether non-ASCII characters (codeUnit ≥ 128) are accepted in local part and domain labels.
- Test cases in `test/email_validator_test.dart` are the canonical source of truth for expected behavior — valid/invalid/international address lists are maintained there directly.
- Releases are managed via the `Release` GitHub Actions workflow (manual `workflow_dispatch`), which bumps `pubspec.yaml`, updates `CHANGELOG.md`, commits, and tags. Publishing to pub.dev triggers automatically on version tags matching `v*.*.*`.
- When updating the version, update both `pubspec.yaml` and `CHANGELOG.md`.
