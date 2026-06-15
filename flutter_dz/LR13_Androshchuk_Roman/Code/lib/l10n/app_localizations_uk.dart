// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Мій Магазин';

  @override
  String get productsTab => 'Товари';

  @override
  String get settingsTab => 'Налаштування';

  @override
  String get languageLabel => 'Мова';

  @override
  String get selectLanguage => 'Виберіть мову';

  @override
  String get availableLanguages => 'Доступні мови:';

  @override
  String helloUser(String name) {
    return 'Привіт, $name!';
  }

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count товарів',
      few: '$count товари',
      one: '1 товар',
      zero: 'Немає товарів',
    );
    return '$_temp0';
  }

  @override
  String totalPrice(String price) {
    return 'Сума: $price';
  }

  @override
  String addedDate(String date) {
    return 'Додано: $date';
  }

  @override
  String get save => 'Зберегти';

  @override
  String get cancel => 'Скасувати';

  @override
  String get delete => 'Видалити';

  @override
  String get edit => 'Редагувати';

  @override
  String get add => 'Додати';

  @override
  String get productShirt => 'Футболка';

  @override
  String get productShoes => 'Кросівки';

  @override
  String get productJacket => 'Куртка';

  @override
  String languageChanged(String language) {
    return 'Мову змінено на $language';
  }

  @override
  String get noProducts => 'Товарів ще немає';

  @override
  String get errorLoading => 'Помилка завантаження даних';
}
