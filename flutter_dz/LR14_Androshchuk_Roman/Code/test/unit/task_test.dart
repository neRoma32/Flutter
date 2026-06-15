import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/models/task.dart';

void main() {
  group('Task Model Tests', () {
    test('creates a task with default isDone as false', () {
      final task = Task(id: 1, title: 'Learn Flutter');
      expect(task.id, 1);
      expect(task.title, 'Learn Flutter');
      expect(task.isDone, false);
    });

    test('creates a task with isDone as true', () {
      final task = Task(id: 2, title: 'Finish Lab', isDone: true);
      expect(task.isDone, true);
    });

    test('toggle() changes isDone from false to true', () {
      final task = Task(id: 3, title: 'Test Task');
      task.toggle();
      expect(task.isDone, true);
    });

    test('toggle() changes isDone from true to false', () {
      final task = Task(id: 4, title: 'Test Task', isDone: true);
      task.toggle();
      expect(task.isDone, false);
    });
  });
}