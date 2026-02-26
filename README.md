# **Email Validator.dart** 

A simple Dart class for validating email addresses without using RegEx. Can also be used to validate emails within Flutter apps (see [Flutter email validation](https://github.com/fredeil/flutter-email-validator)).


**NB:** This library only validates the syntax of the email, not by looking up domain or whether an email actually exists.

**Featured in:**
1. [How To Validate Emails in Flutter](https://betterprogramming.pub/how-to-validate-emails-in-flutter-957ae75926c9) by https://github.com/lucianojung
2. [Flutter Tutorial - Email Validation In 7 Minutes](https://www.youtube.com/watch?v=mXyifVJ-NFc) by https://github.com/JohannesMilke
3. [Flutter Tutorial - Email Validation | Package of the week](https://www.youtube.com/watch?v=ZN_7Pur5h8Q&t=31s) by https://github.com/Dhanraj-FlutterDev

**Found in several big libraries and apps:**

1. [Google Firebase](https://github.com/firebase/FirebaseUI-Flutter)
1. [Flutter GenUI](https://github.com/flutter/genui)
1. [Supabase - Flutter auth UI](https://github.com/supabase-community/flutter-auth-ui)
1. [TubeCards - The world’s best flashcard platform](https://github.com/friebetill/TubeCards)
1. [Serverpod - Serverpod is a next-generation app and web server, explicitly built for Flutter](https://github.com/serverpod/serverpod)
1. [Several other packages on pub.dev](https://pub.dev/packages?q=dependency%3Aemail_validator&sort=downloads)

And many more! 


## **Installation**

### 1. Depend on it

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
    email_validator: '^3.0.0'
```


#### 2. Install it

You can install packages from the command line:

```bash
$ dart pub get
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

