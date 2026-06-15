// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Mój Sklep';

  @override
  String get productsTab => 'Produkty';

  @override
  String get settingsTab => 'Ustawienia';

  @override
  String get languageLabel => 'Język';

  @override
  String get selectLanguage => 'Wybierz język';

  @override
  String get availableLanguages => 'Dostępne języki:';

  @override
  String helloUser(String name) {
    return 'Witaj, $name!';
  }

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count produktu',
      many: '$count produktów',
      few: '$count produkty',
      one: '1 produkt',
      zero: 'Brak produktów',
    );
    return '$_temp0';
  }

  @override
  String totalPrice(String price) {
    return 'Suma: $price';
  }

  @override
  String addedDate(String date) {
    return 'Dodano: $date';
  }

  @override
  String get save => 'Zapisz';

  @override
  String get cancel => 'Anuluj';

  @override
  String get delete => 'Usuń';

  @override
  String get edit => 'Edytuj';

  @override
  String get add => 'Dodaj';

  @override
  String get productShirt => 'Koszulka';

  @override
  String get productShoes => 'Buty';

  @override
  String get productJacket => 'Kurtka';

  @override
  String languageChanged(String language) {
    return 'Język zmieniony na $language';
  }

  @override
  String get noProducts => 'Brak produktów';

  @override
  String get errorLoading => 'Błąd ładowania danych';
}
