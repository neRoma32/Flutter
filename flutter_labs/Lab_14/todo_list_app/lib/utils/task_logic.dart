import '../models/task.dart';

class TaskLogic {
  List<Task> tasks = [];

  void addTask(Task t) => tasks.add(t);
  void removeTask(int id) => tasks.removeWhere((t) => t.id == id);
  void toggleTask(int id) => tasks.firstWhere((t) => t.id == id).toggle();

  List<Task> filterTasks(String filterType) {
    if (filterType == 'active') return tasks.where((t) => !t.isDone).toList();
    if (filterType == 'completed') return tasks.where((t) => t.isDone).toList();
    return tasks; // all
  }
}