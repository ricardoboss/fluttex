extension StringExtensions on String {
  bool get isOnlyDigits => RegExp(r'^\d+$').hasMatch(this);

  bool get isOnlyLetters => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  bool get isWhitespace => RegExp(r'^\s+$').hasMatch(this);

  bool get isOnlyHexDigits => RegExp(r'^[a-fA-F0-9]+$').hasMatch(this);
}
