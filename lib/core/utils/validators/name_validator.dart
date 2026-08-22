RegExp nameExp = RegExp(r'^[a-zA-Z]{2,}$');

String? nameValidator(String? value) {
  if (value == null || !nameExp.hasMatch(value)) {
    return 'Name must be at least 2 characters with no digits...';
  }
  return null;
}