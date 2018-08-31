# Email validator

A simple (but correct) Dart class for validating email addresses. This is a port from the C# library https://github.com/jstedfast/EmailValidation.

## Installation

Dart requires the latest version of [Dart](https://www.dartlang.org/). You can download the latest and greatest [here](https://www.dartlang.org/tools/sdk#install).

### 1. Depend on it

Add this to your package's `pubspec.yaml` file:
```yaml
dependencies:
    emailvalidator: "0.1.0"
```

#### 2. Install it

You can install packages from the command line:

```bash
$ pub get
..
```

Alternatively, your editor might support pub. Check the docs for your editor to learn more.

#### 3. Import it

Now in your Dart code, you can use:

```Dart
import 'package:emailvalidator/validator.dart';
```

## Usage

Read the unit tests under `test`, or see code example below:

```Dart
void main() {

    var email = "fredrik@gmail.com";
    var validator = new EmailValidator();

    assert(validator.validate(email) == true);
}
```

## Tests

To test the package, run:

```bash
$ ./tool/run_tests.sh
...
```
