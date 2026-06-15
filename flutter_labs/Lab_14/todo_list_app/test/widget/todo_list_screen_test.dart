import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/main.dart';

void main() {
  group('TodoListScreen Widget Tests', () {
    
    testWidgets('1. renders initial tasks and title', (tester) async {
      await tester.pumpWidget(const TodoApp());
      
      expect(find.text('My Tasks'), findsOneWidget);
      expect(find.text('Buy groceries'), findsOneWidget); 
      expect(find.text('Call mom'), findsOneWidget);
    });

    testWidgets('2. floating action button opens add task dialog', (tester) async {
      await tester.pumpWidget(const TodoApp());
      
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle(); 
      
      expect(find.text('Add New Task'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('3. adds a new task successfully', (tester) async {
      await tester.pumpWidget(const TodoApp());
      
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      
      await tester.enterText(find.byType(TextField), 'New Widget Task');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();
      
      expect(find.text('New Widget Task'), findsOneWidget);
    });

    testWidgets('4. deletes a task via delete icon button', (tester) async {
      await tester.pumpWidget(const TodoApp());
      
      expect(find.text('Buy groceries'), findsOneWidget);
      
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();
      
      expect(find.text('Buy groceries'), findsNothing);
      expect(find.text('Task deleted'), findsOneWidget);
    });

    testWidgets('5. shows empty state when all tasks are deleted', (tester) async {
      await tester.pumpWidget(const TodoApp());
      
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byIcon(Icons.delete).first);
        await tester.pumpAndSettle();
      }
      
      expect(find.text('No tasks yet!'), findsOneWidget);
      expect(find.text('Tap + to add'), findsOneWidget);
    });
    
  });
}