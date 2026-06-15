class AuthErrors {
  static String getErrorMessage(String code) {
    switch (code) {
      case 'weak-password': return 'Пароль занадто слабкий. Мінімум 6 символів.';
      case 'email-already-in-use': return 'Цей email вже зареєстрований.';
      case 'user-not-found': return 'Користувача з таким email не знайдено.';
      case 'wrong-password': return 'Неправильний пароль.';
      case 'invalid-email': return 'Неправильний формат email.';
      case 'user-disabled': return 'Цей акаунт заблоковано.';
      case 'network-request-failed': return 'Помилка мережі. Перевірте підключення.';
      default: return 'Виникла помилка. Спробуйте ще раз.';
    }
  }
}