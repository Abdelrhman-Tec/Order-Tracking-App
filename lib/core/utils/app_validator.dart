class AppValidators {
  AppValidators._(); // prevent instance

  static String? requiredField(
    String? value, {
    String fieldName = 'This field',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }

    return null;
  }

  static String? password(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    return null;
  }

  static String? confirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }

    if (value != originalPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegex = RegExp(r'^01[0-2,5]{1}[0-9]{8}$');

    if (!phoneRegex.hasMatch(value)) {
      return 'Enter a valid phone number';
    }

    return null;
  }

  static String? minLength(String? value, int length) {
    if (value == null || value.length < length) {
      return 'Must be at least $length characters';
    }
    return null;
  }
}
