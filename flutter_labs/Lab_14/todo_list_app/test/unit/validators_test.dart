import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/utils/validators.dart';

void main() {
  group('Validators Tests', () {
    test('returns error when title is null', () {
      expect(Validators.validateTitle(null), 'Title cannot be empty');
    });

    test('returns error when title is empty string', () {
      expect(Validators.validateTitle(''), 'Title cannot be empty');
    });

    test('returns error when title is only spaces', () {
      expect(Validators.validateTitle('   '), 'Title cannot be empty');
    });

    test('returns null when title is valid', () {
      expect(Validators.validateTitle('Valid Task'), isNull);
    });
  });
}