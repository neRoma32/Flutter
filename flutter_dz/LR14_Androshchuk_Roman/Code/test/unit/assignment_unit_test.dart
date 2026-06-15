import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/utils/task_logic.dart'; // Переконайся, що ім'я проекту правильне
import 'package:todo_list_app/utils/validators.dart';

void main() {
  group('Unit Tests (7 тестів)', () {
    
    // --- 1. Task model (fromJson, toJson) ---
    test('1. Task model fromJson and toJson works', () {
      final task = Task(id: 1, title: 'Test Task', isDone: true);
      final json = task.toJson();
      final newTask = Task.fromJson(json);
      
      expect(json['title'], 'Test Task');
      expect(newTask.title, 'Test Task');
      expect(newTask.isDone, true);
    });

    test('2. Task validation returns error when empty', () {
      expect(Validators.validateTitle(''), 'Title cannot be empty');
      expect(Validators.validateTitle(null), 'Title cannot be empty');
      expect(Validators.validateTitle('Good Task'), isNull);
    });

    test('3. Task list operation: Add task', () {
      final logic = TaskLogic();
      logic.addTask(Task(id: 1, title: 'New'));
      expect(logic.tasks.length, 1);
    });

    test('4. Task list operation: Remove task', () {
      final logic = TaskLogic();
      logic.addTask(Task(id: 1, title: 'New'));
      logic.removeTask(1);
      expect(logic.tasks.isEmpty, true);
    });

    test('5. Task list operation: Toggle task', () {
      final logic = TaskLogic();
      logic.addTask(Task(id: 1, title: 'New'));
      logic.toggleTask(1);
      expect(logic.tasks.first.isDone, true);
    });

    test('6. Filter logic: Active tasks', () {
      final logic = TaskLogic();
      logic.addTask(Task(id: 1, title: 'Active', isDone: false));
      logic.addTask(Task(id: 2, title: 'Done', isDone: true));
      
      final active = logic.filterTasks('active');
      expect(active.length, 1);
      expect(active.first.title, 'Active');
    });

    test('7. Filter logic: Completed tasks', () {
      final logic = TaskLogic();
      logic.addTask(Task(id: 1, title: 'Active', isDone: false));
      logic.addTask(Task(id: 2, title: 'Done', isDone: true));
      
      final completed = logic.filterTasks('completed');
      expect(completed.length, 1);
      expect(completed.first.title, 'Done');
    });

  });
}