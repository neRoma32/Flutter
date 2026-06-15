import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/models/task.dart';
import 'package:todo_list_app/utils/task_logic.dart';

void main() {
  group('Performance Tests', () {
    test('Adding and filtering 1000 tasks should be fast', () {
      final logic = TaskLogic();
      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 1000; i++) {
        logic.addTask(Task(
          id: i,
          title: 'Task $i',
          isDone: i % 2 == 0, 
        ));
      }
      stopwatch.stop();
      final addTime = stopwatch.elapsedMilliseconds;
      
      expect(addTime, lessThan(50));
      print('Час додавання 1000 задач: $addTime мс');

      stopwatch.reset();
      stopwatch.start();
      
      final activeTasks = logic.filterTasks('active');
      
      stopwatch.stop();
      final filterTime = stopwatch.elapsedMilliseconds;

      expect(activeTasks.length, 500);
      expect(filterTime, lessThan(20));
      print('Час фільтрації 1000 задач: $filterTime мс');
    });
  });
}