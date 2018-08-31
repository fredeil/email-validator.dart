library emailvalidator;

import 'dart:core';

class EmailValidator {
  int index = 0;
  static final _atomCharacters = "!#\$\%&'*+-/=?^_`{|}~";

  bool isLetterOrDigit(c) {
    return (c >= 'A' && c <= 'Z') ||
        (c >= 'a' && c <= 'z') ||
        (c >= '0' && c <= '9');
  }

  bool isAtom(c, bool allowInternational) {
    return c.codeUnitAt(0) < 128
        ? this.isLetterOrDigit(c) || _atomCharacters.indexOf(c) != -1
        : allowInternational;
  }

  bool isDomain(c, bool allowInternational) {
    return c.codeUnitAt(0) < 128
        ? this.isLetterOrDigit(c) || c == '-'
        : allowInternational;
  }

  bool skipAtom(text, bool allowInternational) {
    var self = this;
    var startIndex = self.index;

    while (self.index < text.length &&
        self.isAtom(text[self.index], allowInternational)) {
      self.index++;
    }

    return self.index > startIndex;
  }

  bool skipSubDomain(text, bool allowInternational) {
    var self = this;
    var startIndex = self.index;

    if (!self.isDomain(text[self.index], allowInternational) ||
        text[self.index] == '-') {
      return false;
    }

    self.index++;

    while (self.index < text.length &&
        self.isDomain(text[self.index], allowInternational)) {
      self.index++;
    }

    return (self.index - startIndex) < 64 && text[self.index - 1] != '-';
  }

  bool skipDomain(
      String text, bool allowTopLevelDomains, bool allowInternational) {
    var self = this;

    if (!self.skipSubDomain(text, allowInternational)) {
      return false;
    }

    if (self.index < text.length && text[self.index] == '.') {
      do {
        self.index++;

        if (self.index == text.length) {
          return false;
        }

        if (!self.skipSubDomain(text, allowInternational)) {
          return false;
        }
      } while (self.index < text.length && text[self.index] == '.');
    } else if (!allowTopLevelDomains) {
      return false;
    }

    return true;
  }

  bool skipQuoted(String text, bool allowInternational) {
    var self = this;
    var escaped = false;

    self.index++;

    while (self.index < text.length) {
      if (text.codeUnitAt(this.index) >= 128 && !allowInternational) {
        return false;
      }

      if (text[self.index] == '\\') {
        escaped = !escaped;
      } else if (!escaped) {
        if (text[self.index] == '"') {
          break;
        }
      } else {
        escaped = false;
      }

      self.index++;
    }

    if (self.index >= text.length || text[self.index] != '"') {
      return false;
    }

    self.index++;

    return true;
  }

  bool skipWord(String text, bool allowInternational) {
    var self = this;

    if (text[self.index] == '"') {
      return self.skipQuoted(text, allowInternational);
    }

    return self.skipAtom(text, allowInternational);
  }

  bool skipIPv4Literal(text) {
    var self = this;
    var groups = 0;

    while (self.index < text.length && groups < 4) {
      var startIndex = self.index;
      var value = 0;

      while (self.index < text.length &&
          text[self.index] >= '0' &&
          text[self.index] <= '9') {
        value = (value * 10) + (text[self.index] - '0');
        self.index++;
      }

      if (self.index == startIndex ||
          self.index - startIndex > 3 ||
          value > 255) {
        return false;
      }

      groups++;

      if (groups < 4 && self.index < text.length && text[self.index] == '.') {
        self.index++;
      }
    }

    return groups == 4;
  }

  bool isHexDigit(c) {
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
  bool skipIPv6Literal(String text) {
    var self = this;
    var compact = false;
    var colons = 0;

    while (self.index < text.length) {
      var startIndex = self.index;

      while (self.index < text.length && self.isHexDigit(text[self.index])) {
        self.index++;
      }

      if (self.index >= text.length) {
        break;
      }

      if (self.index > startIndex && colons > 2 && text[self.index] == '.') {
        // IPv6v4
        self.index = startIndex;

        if (!self.skipIPv4Literal(text)) {
          return false;
        }

        return compact ? colons < 6 : colons == 6;
      }

      var count = self.index - startIndex;

      if (count > 4) {
        return false;
      }

      if (text[self.index] != ':') {
        break;
      }

      startIndex = self.index;
      while (self.index < text.length && text[self.index] == ':') {
        self.index++;
      }

      count = self.index - startIndex;
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

  bool validate(String email,
      [allowTopLevelDomains = false, allowInternational = false]) {
    var self = this;

    if (email == null) {
      return false;
    }

    if (email.length < 0 || email.length >= 255) {
      return false;
    }

    if (!self.skipWord(email, allowInternational) ||
        self.index >= email.length) {
      return false;
    }

    while (email[self.index] == '.') {
      self.index++;

      if (self.index >= email.length) {
        return false;
      }

      if (!self.skipWord(email, allowInternational)) {
        return false;
      }

      if (self.index >= email.length) {
        return false;
      }
    }

    if (self.index + 1 >= email.length ||
        self.index > 64 ||
        email[self.index++] != '@') {
      return false;
    }

    if (email[self.index] != '[') {
      // domain
      if (!self.skipDomain(email, allowTopLevelDomains, allowInternational)) {
        return false;
      }

      return self.index == email.length;
    }

    // address literal
    self.index++;

    // we need at least 8 more characters
    if (self.index + 8 >= email.length) {
      return false;
    }

    var ipv6 = email.substring(self.index, 5);
    if (ipv6.toLowerCase() == 'ipv6:') {
      self.index += 'IPv6:'.length;
      if (!self.skipIPv6Literal(email)) {
        return false;
      }
    } else if (!self.skipIPv4Literal(email)) {
      return false;
    }

    if (self.index >= email.length || email[self.index++] != ']') {
      return false;
    }

    return self.index == email.length;
  }
}
