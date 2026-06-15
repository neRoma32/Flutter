import 'package:flutter/material.dart';
import 'models/task.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Tasks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<Task> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _tasks.addAll([
      Task(id: 1, title: 'Buy groceries'),
      Task(id: 2, title: 'Finish homework', isDone: true),
      Task(id: 3, title: 'Call mom'),
    ]);
  }

  int get _completedCount => _tasks.where((task) => task.isDone).length;

  void _toggleTask(int id) {
    setState(() {
      final task = _tasks.firstWhere((t) => t.id == id);
      task.toggle();
    });
  }

  void _deleteTask(int id) {
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task deleted')),
    );
  }

  void _addTask() {
    final title = _controller.text.trim();

    if (title.isEmpty) return;

    setState(() {
      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
      );

      _tasks.add(newTask);
    });

    _controller.clear();
    Navigator.pop(context);
  }

 void _showAddTaskDialog() {
    final formKey = GlobalKey<FormState>(); 

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: Form( 
            key: formKey,
            child: TextFormField( 
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Task title'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Title cannot be empty';
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _controller.clear();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _addTask();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatistics() {
    final completed = _completedCount;
    final total = _tasks.length;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue[50],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$completed of $total completed',
            style: const TextStyle(fontSize: 16),
          ),
          const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No tasks yet!',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Tap + to add',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];

          return Dismissible(
            key: Key(task.id.toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _deleteTask(task.id);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: Checkbox(
                  value: task.isDone,
                  onChanged: (value) {
                    _toggleTask(task.id);
                  },
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _deleteTask(task.id);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        backgroundColor: Colors.blue[100],
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(title: const Text('Info')),
                  body: const Center(child: Text('About Screen')),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatistics(),
          _tasks.isEmpty ? _buildEmptyState() : _buildTaskList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}