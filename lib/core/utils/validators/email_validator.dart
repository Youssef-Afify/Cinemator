RegExp emailExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

String? emailValidator(String? value) {
  if (value == null || !emailExp.hasMatch(value)) {
    return 'Enter a valid email...';
  }
  return null;
}