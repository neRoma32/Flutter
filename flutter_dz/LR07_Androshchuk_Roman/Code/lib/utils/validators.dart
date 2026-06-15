class Validators {
  static String? required(String? value, {String fieldName = 'Поле'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName є обов\'язковим';
    }
    return null;
  }

  //перевірка email
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) {
      return 'Невірний формат email';
    }
    return null;
  }

  //перевірка телефону
  static String? phoneUA(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final regex = RegExp(r'^\+380\d{9}$');
    if (!regex.hasMatch(value)) {
      return 'Формат: +380XXXXXXXXX';
    }
    return null;
  }

  //перевірка пароля
  static String? strongPassword(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (value.length < 8) return 'Мінімум 8 символів';
    if (!value.contains(RegExp(r'[A-Z]'))) return 'Має містити велику літеру';
    if (!value.contains(RegExp(r'[0-9]'))) return 'Має містити цифру';
    return null;
  }

  static String? Function(String?) combine(List<String? Function(String?)> validators) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}