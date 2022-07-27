# **Email validator** [![Build status](https://ci.appveyor.com/api/projects/status/fb7ssu5fg8k334vi?svg=true)](https://ci.appveyor.com/project/fredeil/email-validator-dart) [![pub package](https://img.shields.io/pub/v/email_validator.svg)](https://pub.dev/packages/email_validator) [![likes](https://badges.bar/email_validator/likes)](https://pub.dev/packages/email_validator)

A simple (but correct) Dart class for validating email addresses without using RegEx. Can also be used to validate emails within Flutter apps (see [Flutter email validation](https://github.com/fredeil/flutter-email-validator)).

**Featured in:**
1. [How To Validate Emails in Flutter](https://betterprogramming.pub/how-to-validate-emails-in-flutter-957ae75926c9) by https://github.com/lucianojung
2. [Flutter Tutorial - Email Validation In 7 Minutes](https://www.youtube.com/watch?v=mXyifVJ-NFc) by https://github.com/JohannesMilke
3. [Flutter Tutorial - Email Validation | Package of the week](https://www.youtube.com/watch?v=ZN_7Pur5h8Q&t=31s) by https://github.com/Dhanraj-FlutterDev


## **Installation**

### 1. Depend on it

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
    email_validator: '^2.1.16'
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
import 'package:email_validator/email_validator.dart';
```

## **Usage**

Read the unit tests under `test`, or see code example below:

```Dart
void main() {

    var email = "fredrik@gmail.com";

    assert(EmailValidator.validate(email));
}
```

## Tips

You can also use this repo as a template for creating Dart packages, just clone the repo and start hacking :) 

