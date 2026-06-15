import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:todo_list_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End App Flow', () {
    testWidgets('Full flow: Create -> Verify -> Delete task', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'Integration Task');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(find.text('Integration Task'), findsOneWidget);

      final deleteIcon = find.descendant(
        of: find.ancestor(
          of: find.text('Integration Task'),
          matching: find.byType(Card),
        ),
        matching: find.byIcon(Icons.delete),
      );
      
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      expect(find.text('Integration Task'), findsNothing);
    });
  });
}