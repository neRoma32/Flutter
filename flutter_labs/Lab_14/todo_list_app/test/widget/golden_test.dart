import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/main.dart';

void main() {
  group('Golden Tests', () {
    testWidgets('TodoListScreen golden test', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3.0;

      await tester.pumpWidget(const TodoApp());
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(TodoApp),
        matchesGoldenFile('goldens/todo_list_screen.png'),
      );

      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    });
  });
}