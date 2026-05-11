class TaskFlowValidators {
  const TaskFlowValidators._();

  static String? name(String? value) {
    final text = value?.trim() ?? '';
    if (text.length < 2) {
      return 'Enter your name.';
    }
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    final isValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text);
    if (!isValid) {
      return 'Enter a valid email.';
    }
    return null;
  }

  static String? password(String? value) {
    if ((value ?? '').length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  static String? requiredText(String? value, String label) {
    if ((value ?? '').trim().isEmpty) {
      return '$label is required.';
    }
    return null;
  }
}
