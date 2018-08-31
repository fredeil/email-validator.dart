library emailvalidator;

import 'dart:core';

class EmailValidator {
  static int index = 0;
  static final _atomCharacters = "!#\$\%&'*+-/=?^_`{|}~";

  static bool _isLetterOrDigit(String str) {
    var c = str.codeUnitAt(0);
    return (c >= 65 && c <= 90) ||
        (c >= 97 && c <= 122) ||
        (c >= 48 && c <= 57);
  }

  static bool _isAtom(String c, bool allowInternational) {
    return c.codeUnitAt(0) < 128
        ? _isLetterOrDigit(c) || _atomCharacters.indexOf(c) != -1
        : allowInternational;
  }

  static bool _isDomain(String c, bool allowInternational) {
    return c.codeUnitAt(0) < 128
        ? _isLetterOrDigit(c) || c == '-'
        : allowInternational;
  }

  static bool _skipAtom(text, bool allowInternational) {
    var startIndex = index;

    while (index < text.length && _isAtom(text[index], allowInternational)) {
      index++;
    }

    return index > startIndex;
  }

  static bool _skipSubDomain(text, bool allowInternational) {
    var startIndex = index;

    if (!_isDomain(text[index], allowInternational) || text[index] == '-') {
      return false;
    }

    index++;

    while (index < text.length && _isDomain(text[index], allowInternational)) {
      index++;
    }

    return (index - startIndex) < 64 && text[index - 1] != '-';
  }

  static bool _skipDomain(
      String text, bool allowTopLevelDomains, bool allowInternational) {
    if (!_skipSubDomain(text, allowInternational)) {
      return false;
    }

    if (index < text.length && text[index] == '.') {
      do {
        index++;

        if (index == text.length) {
          return false;
        }

        if (_skipSubDomain(text, allowInternational)) {
          return false;
        }
      } while (index < text.length && text[index] == '.');
    } else if (!allowTopLevelDomains) {
      return false;
    }

    return true;
  }

  static bool _skipQuoted(String text, bool allowInternational) {
    var escaped = false;

    index++;

    while (index < text.length) {
      if (text.codeUnitAt(index) >= 128 && !allowInternational) {
        return false;
      }

      if (text[index] == '\\') {
        escaped = !escaped;
      } else if (!escaped) {
        if (text[index] == '"') {
          break;
        }
      } else {
        escaped = false;
      }

      index++;
    }

    if (index >= text.length || text[index] != '"') {
      return false;
    }

    index++;

    return true;
  }

  static bool _skipWord(String text, bool allowInternational) {
    if (text[index] == '"') {
      return _skipQuoted(text, allowInternational);
    }

    return _skipAtom(text, allowInternational);
  }

  static bool _skipIPv4Literal(text) {
    var groups = 0;

    while (index < text.length && groups < 4) {
      var startIndex = index;
      var value = 0;

      while (index < text.length && text[index] >= '0' && text[index] <= '9') {
        value = (value * 10) + (text[index] - '0');
        index++;
      }

      if (index == startIndex || index - startIndex > 3 || value > 255) {
        return false;
      }

      groups++;

      if (groups < 4 && index < text.length && text[index] == '.') {
        index++;
      }
    }

    return groups == 4;
  }

  static bool _isHexDigit(c) {
    return (c >= 'A' && c <= 'F') ||
        (c >= 'a' && c <= 'f') ||
        (c >= '0' && c <= '9');
  }

  // This needs to handle the following forms:
  //
  // IPv6-addr = IPv6-full / IPv6-comp / IPv6v4-full / IPv6v4-comp
  // IPv6-hex  = 1*4HEXDIG
  // IPv6-full = IPv6-hex 7(":" IPv6-hex)
  // IPv6-comp = [IPv6-hex *5(":" IPv6-hex)] "::" [IPv6-hex *5(":" IPv6-hex)]
  //             ; The "::" represents at least 2 16-bit groups of zeros
  //             ; No more than 6 groups in addition to the "::" may be
  //             ; present
  // IPv6v4-full = IPv6-hex 5(":" IPv6-hex) ":" IPv4-address-literal
  // IPv6v4-comp = [IPv6-hex *3(":" IPv6-hex)] "::"
  //               [IPv6-hex *3(":" IPv6-hex) ":"] IPv4-address-literal
  //             ; The "::" represents at least 2 16-bit groups of zeros
  //             ; No more than 4 groups in addition to the "::" and
  //             ; IPv4-address-literal may be present
  static bool _skipIPv6Literal(String text) {
    var compact = false;
    var colons = 0;

    while (index < text.length) {
      var startIndex = index;

      while (index < text.length && _isHexDigit(text[index])) {
        index++;
      }

      if (index >= text.length) {
        break;
      }

      if (index > startIndex && colons > 2 && text[index] == '.') {
        // IPv6v4
        index = startIndex;

        if (!_skipIPv4Literal(text)) {
          return false;
        }

        return compact ? colons < 6 : colons == 6;
      }

      var count = index - startIndex;

      if (count > 4) {
        return false;
      }

      if (text[index] != ':') {
        break;
      }

      startIndex = index;
      while (index < text.length && text[index] == ':') {
        index++;
      }

      count = index - startIndex;
      if (count > 2) {
        return false;
      }

      if (count == 2) {
        if (compact) {
          return false;
        }

        compact = true;
        colons += 2;
      } else {
        colons++;
      }
    }

    if (colons < 2) {
      return false;
    }

    return compact ? colons < 7 : colons == 7;
  }

  static bool validate(String email,
      [allowTopLevelDomains = false, allowInternational = false]) {
    index = 0;

    if (email == null) {
      return false;
    }

    if (email.length < 0 || email.length >= 255) {
      return false;
    }

    if (!_skipWord(email, allowInternational) || index >= email.length) {
      return false;
    }

    while (email[index] == '.') {
      index++;

      if (index >= email.length) {
        return false;
      }

      if (!_skipWord(email, allowInternational)) {
        return false;
      }

      if (index >= email.length) {
        return false;
      }
    }

    if (index + 1 >= email.length || index > 64 || email[index] != '@') {
      index++;
      return false;
    }

    if (email[index] != '[') {
      // domain
      if (!_skipDomain(email, allowTopLevelDomains, allowInternational)) {
        return false;
      }

      return index == email.length;
    }

    // address literal
    index++;

    // we need at least 8 more characters
    if (index + 8 >= email.length) {
      return false;
    }

    var ipv6 = email.substring(index, 5);
    if (ipv6.toLowerCase() == 'ipv6:') {
      index += 'IPv6:'.length;
      if (!_skipIPv6Literal(email)) {
        return false;
      }
    } else if (!_skipIPv4Literal(email)) {
      return false;
    }

    if (index >= email.length || email[index++] != ']') {
      return false;
    }

    return index == email.length;
  }
}
