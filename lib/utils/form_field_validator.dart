String formFieldValidator(String value) {
  if (value.isEmpty) {
    return '$value cannot be empty';
  }
  return null;
}

String validateEmail(String value) {
  String _emailErrorMessage;
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value)) {
    _emailErrorMessage = "$value is not a valid email";
  } else {
    return null;
  }
  return _emailErrorMessage;
}

String validatePassword(String value) {
  return ((value.length) < 6)
      ? "password cannot be less than 6 character long"
      : null;
}

String validateQuantity(String value) {
  if (value.isEmpty) {
    return '$value cannot be empty';
  } else if (int.tryParse(value) == null) {
    return '$value is not whole number';
  }
  return null;
}
