String? confirmValidator(String? value, String? password) {
  if (value == null || value.length < 8) {
    return 'Password must be at least 8 chars...';
  } else if (value.contains(' ')) {
    return "Spaces ' ' are not allowed...";
  } else if (password == null || value != password) {
    return 'Passwords must be the same...';
  }
  return null;
}