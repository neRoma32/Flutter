import 'package:flutter/material.dart';
import '../main.dart';
import '../models/todo_item.dart';
import '../services/storage_service.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final StorageService _storage = StorageService();

  List<TodoItem> _todos = [];
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = true;

  String _selectedCategory = 'Work';

  int _totalCreated = 0;
  int _streak = 0;
  String? _lastActiveDate;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    final todos = await _storage.loadTodos();
    
    _totalCreated = _storage.loadTotalCreated();
    _streak = _storage.loadStreak();
    _lastActiveDate = _storage.loadLastActiveDate();
    
    setState(() {
      _todos = todos;
      _isLoading = false;
    });
  }

  Future<void> _saveData() async {
    await _storage.saveTodos(_todos);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('💾 Saved successfully'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _addTodo() async {
    if (_textController.text.trim().isEmpty) return;

    final newTodo = TodoItem(
      id: DateTime.now().toString(),
      title: _textController.text.trim(),
      isCompleted: false,
      createdAt: DateTime.now(),
      category: _selectedCategory, 
    );

    _totalCreated++;
    final now = DateTime.now();
    final todayStr = DateTime(now.year, now.month, now.day).toIso8601String();

    if (_lastActiveDate != null) {
      final lastDate = DateTime.parse(_lastActiveDate!);
      final lastDateClean = DateTime(lastDate.year, lastDate.month, lastDate.day);
      final todayClean = DateTime(now.year, now.month, now.day);
      final difference = todayClean.difference(lastDateClean).inDays;

      if (difference == 1) {
        _streak++;
      } else if (difference > 1) {
        _streak = 1;
      }
    } else {
      _streak = 1;
    }
    _lastActiveDate = todayStr;
    
    await _storage.saveStats(_totalCreated, _streak, _lastActiveDate!);

    setState(() {
      _todos.add(newTodo);
    });

    _textController.clear();
    _saveData();
  }

  void _showStatsDialog() {
    final now = DateTime.now();
    final completedToday = _todos.where((t) => t.isCompleted && 
        t.createdAt.year == now.year && 
        t.createdAt.month == now.month && 
        t.createdAt.day == now.day).length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.bar_chart, color: Colors.blue),
            SizedBox(width: 8),
            Text('Statistics'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total tasks created: $_totalCreated'),
            const SizedBox(height: 8),
            Text('Completed today: $completedToday'),
            const SizedBox(height: 8),
            Text('🔥 Current Streak: $_streak days'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _toggleTodo(TodoItem todo) {
    setState(() {
      final index = _todos.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        _todos[index] = todo.copyWith(isCompleted: !todo.isCompleted);
      }
    });
    _saveData();
  }

  void _deleteTodo(TodoItem todo) {
    setState(() {
      _todos.removeWhere((t) => t.id == todo.id);
    });
    _saveData();
  }

  void _clearCompleted() {
    setState(() {
      _todos.removeWhere((todo) => todo.isCompleted);
    });
    _saveData();
  }

  void _toggleTheme() {
    final newThemeState = !themeNotifier.value;
    themeNotifier.value = newThemeState;
    _storage.saveThemeMode(newThemeState);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: _showStatsDialog,
          ),
          IconButton(
            icon: Icon(themeNotifier.value ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              decoration: const InputDecoration(
                                hintText: 'Add new task...',
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted: (_) => _addTodo(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filled(
                            icon: const Icon(Icons.add),
                            onPressed: _addTodo,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      //Dropdown для категорії
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Select Category:', style: TextStyle(fontWeight: FontWeight.bold)),
                          DropdownButton<String>(
                            value: _selectedCategory,
                            items: <String>['Work', 'Personal', 'Shopping']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedCategory = newValue;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '📋 Tasks (${_todos.length})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _todos.isEmpty ? _buildEmptyState() : _buildTodoList(),
                ),
                _buildFooter(),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No tasks yet!', style: TextStyle(fontSize: 20, color: Colors.grey)),
          SizedBox(height: 8),
          Text('Add your first task above', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTodoList() {
    return ListView.builder(
      itemCount: _todos.length,
      itemBuilder: (context, index) {
        final todo = _todos[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: Checkbox(
              value: todo.isCompleted,
              onChanged: (_) => _toggleTodo(todo),
            ),
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            //А
            subtitle: todo.category != null 
                ? Text('🏷️ ${todo.category}', style: const TextStyle(fontSize: 12)) 
                : null,
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteTodo(todo),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    final completedCount = _todos.where((t) => t.isCompleted).length;
    final lastSaveTime = _storage.getLastSaveTime();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('✅ Completed: $completedCount/${_todos.length}'),
              if (lastSaveTime != null)
                Text('💾 Last saved: $lastSaveTime', style: const TextStyle(fontSize: 12)),
            ],
          ),
          if (completedCount > 0) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _clearCompleted,
                child: const Text('Clear All Completed'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}