class LanguageModel {
  final String code;
  final String name;
  final String flag;

  const LanguageModel({
    required this.code,
    required this.name,
    required this.flag,
  });

  static const List<LanguageModel> languages = [
    LanguageModel(code: 'uk', name: 'Українська', flag: '🇺🇦'),
    LanguageModel(code: 'en', name: 'English', flag: '🇬🇧'),
    LanguageModel(code: 'pl', name: 'Polski', flag: '🇵🇱'),
  ];

  static LanguageModel? getByCode(String code) {
    try {
      return languages.firstWhere((lang) => lang.code == code);
    } catch (e) {
      return null;
    }
  }
}
