// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My Store';

  @override
  String get productsTab => 'Products';

  @override
  String get settingsTab => 'Settings';

  @override
  String get languageLabel => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get availableLanguages => 'Available Languages:';

  @override
  String helloUser(String name) {
    return 'Hello, $name!';
  }

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products',
      one: '1 product',
      zero: 'No products',
    );
    return '$_temp0';
  }

  @override
  String totalPrice(String price) {
    return 'Total: $price';
  }

  @override
  String addedDate(String date) {
    return 'Added: $date';
  }

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get productShirt => 'T-Shirt';

  @override
  String get productShoes => 'Sneakers';

  @override
  String get productJacket => 'Jacket';

  @override
  String languageChanged(String language) {
    return 'Language changed to $language';
  }

  @override
  String get noProducts => 'No products yet';

  @override
  String get errorLoading => 'Error loading data';
}
