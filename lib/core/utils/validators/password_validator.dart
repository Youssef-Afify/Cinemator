String? passwordValidator(String? value) {
  if (value == null || value.length < 8) {
    return 'Password must be at least 8 chars...';
  }
  if (value.contains(' ')) {
    return "Spaces ' ' are not allowed...";
  }
  return null;
}