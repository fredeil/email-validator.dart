import 'dart:core';
import 'package:email_validator/email_validator.dart';

void main() {
    const String email = "fredrik.eilertsen@gmail.com";
    final bool isValid = EmailValidator.Validate(email);

    print('Email is valid? ' + (isValid ? 'yes' : 'no'));
}
