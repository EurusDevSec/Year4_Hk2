class AppValidators {
  static String? validateName(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter name';
    }
    if (value!.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter email';
    }
    if (!value!.contains('@')) {
      return 'Please enter valid email';
    }
    if (!value.contains('.')) {
      return 'Email must contain a domain';
    }
    return null;
  }

  static String? validateAge(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter age';
    }
    final age = int.tryParse(value!);
    if (age == null) {
      return 'Age must be a number';
    }
    if (age < 0 || age > 150) {
      return 'Please enter valid age (0-150)';
    }
    return null;
  }
}
