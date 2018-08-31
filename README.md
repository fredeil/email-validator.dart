# Email validator

A simple (but correct) Dart class for validating email addresses.

## Installation

Dart requires the latest version of [Dart](https://www.dartlang.org/). You can download the latest and greatest [here](https://www.dartlang.org/tools/sdk#install).

## Usage

Read the unit tests under `test`, or see code example below:

```Dart
void main() {

    var email = "fredrik@gmail.com";
    var validator = new EmailValidator();

    assert(validator.validate(email) == true);
}
```

## License

[MIT](LICENSE)
