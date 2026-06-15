import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/main.dart'; 

void main() {
  group('Widget Tests (6 тестів)', () {

    testWidgets('1. TaskListWidget displays the list', (tester) async {
      await tester.pumpWidget(const TodoApp());
      expect(find.text('Buy groceries'), findsOneWidget); 
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('2. EmptyState shows when list is empty', (tester) async {
      await tester.pumpWidget(const TodoApp());
      
      await tester.tap(find.byIcon(Icons.delete).at(0));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.delete).at(0));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.delete).at(0));
      await tester.pumpAndSettle();
      
      expect(find.text('No tasks yet!'), findsOneWidget);
    });

    testWidgets('3. Checkbox toggle works', (tester) async {
      await tester.pumpWidget(const TodoApp());
      
      final checkbox = find.byType(Checkbox).first;
      await tester.tap(checkbox);
      await tester.pumpAndSettle();
      
      final textWidget = tester.widget<Text>(find.text('Buy groceries'));
      expect(textWidget.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('4. Delete button removes task', (tester) async {
      await tester.pumpWidget(const TodoApp());
      
      expect(find.text('Call mom'), findsOneWidget);
      
      await tester.tap(find.byIcon(Icons.delete).last);
      await tester.pumpAndSettle();
      
      expect(find.text('Call mom'), findsNothing);
    });

    testWidgets('5. Form validation works on empty submit', (tester) async {
      await tester.pumpWidget(const TodoApp());
      
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();
      
      expect(find.text('Title cannot be empty'), findsOneWidget);
    });

    testWidgets('6. Navigation to Info screen works', (tester) async {
      await tester.pumpWidget(const TodoApp());
      
      await tester.tap(find.byIcon(Icons.info_outline));
      await tester.pumpAndSettle(); 
      
      expect(find.text('About Screen'), findsOneWidget);
    });

  });
}