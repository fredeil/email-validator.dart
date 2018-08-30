library emailvalidator;

import 'dart:core';

class EmailValidator {
  static bool Validate(String email,
      [bool allowTopLevelDomains = false, bool allowInternal = false]) {
    int index = 0;

    if (email == null) throw new ArgumentError("email");

    if (email.length == 0 || email.length >= 255) return false;

    if (email[index] == '"') {
      // Skip quoted
    } else {
      //if (!SkipAtom (email, index, allowInternational))
      // return false;

      while (email[index] == ".") {
        index++;
        if (index >= email.length) return false;

        //if (!SkipAtom (email, index, allowInternational))
        // return false;

        if (index >= email.length) return false;
      }

      if (index + 1 >= email.length || index > 64 || email[index++] != '@')
        return false;

      if (email[index] != '[') {
        //if (!SkipDomain (email, index, allowTopLevelDomains, allowInternational))
        //return false;

        return index == email.length;
      }

      index++;

      if (index + 8 >= email.length) return false;

      var ipv6 = email.substring(index, 5);
      if (ipv6.toLowerCase() == "ipv6:") {
        index += "IPv6:".length;
        //if (!SkipIPv6Literal (email, ref index))
        //return false;
      } else {
        //if (!SkipIPv4Literal (email, ref index))
        //return false;
      }

      if (index >= email.length || email[index++] != ']') return false;

      return index == email.length;
    }
  }
}
