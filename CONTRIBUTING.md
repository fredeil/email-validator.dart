# Contributing to email-validator.dart

Thank you for your interest in contributing! This document explains how to set up the project locally, run tests, and submit a pull request.

## Development Setup

You'll need the [Dart SDK](https://dart.dev/get-dart) installed.

```bash
# Install dependencies
dart pub get
```

## Running Tests

```bash
dart test
```

Or to run the single test file directly:

```bash
dart test test/email_validator_test.dart
```

## Linting and Formatting

```bash
# Run the static analyser (must pass with no errors or warnings)
dart analyze --fatal-infos

# Check formatting (must pass before merging)
dart format --output=none --set-exit-if-changed .

# Auto-fix formatting
dart format .
```

## Project Structure

```
lib/email_validator.dart   # Single-file library — all parsing logic lives here
test/email_validator_test.dart  # All tests; valid/invalid/international address lists
example/example.dart       # Short usage example
```

The parser is cursor-based: a shared `_index` field advances through the email string inside the `EmailValidator` class. There are no external dependencies. Please keep it that way — no new dependencies without a prior discussion in an issue.

## Submitting a Pull Request

1. Fork the repository and create a branch from `master`.
2. Make your changes. For bug fixes, add a regression test that fails before your fix and passes after.
3. Ensure `dart analyze --fatal-infos` and `dart format --output=none --set-exit-if-changed .` both pass.
4. Run `dart test` and confirm all tests pass.
5. Open a pull request with a clear description of the problem and solution.

## Reporting Bugs

Please open a GitHub issue with:
- The email address that produces the unexpected result.
- The expected outcome (valid/invalid) and the actual outcome.
- The package version you are using.
