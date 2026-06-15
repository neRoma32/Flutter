import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../widgets/category_card.dart';
import 'category_details_screen.dart';

enum SortOption { dateNewest, dateOldest, amountHighest, amountLowest }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Expense> _expenses = [];

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  ExpenseCategory _selectedCategory = ExpenseCategory.food;

  SortOption _currentSort = SortOption.dateNewest;

  @override
  void initState() {
    super.initState();
    _expenses.addAll([
      Expense(id: 1, title: 'Lunch', amount: 25.00, category: ExpenseCategory.food, date: DateTime.now()),
      Expense(id: 2, title: 'Uber', amount: 15.50, category: ExpenseCategory.transport, date: DateTime.now()),
    ]);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  //загальні гроші
  double get _totalExpenses {
    return _expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  //гроші по категорії
  double _getCategoryTotal(ExpenseCategory category) {
    return _expenses
        .where((e) => e.category == category)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  List<Expense> get _sortedExpenses {
    final sortedList = List<Expense>.from(_expenses);
    switch (_currentSort) {
      case SortOption.dateNewest:
        sortedList.sort((a, b) => b.date.compareTo(a.date));
        break;
      case SortOption.dateOldest:
        sortedList.sort((a, b) => a.date.compareTo(b.date));
        break;
      case SortOption.amountHighest:
        sortedList.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case SortOption.amountLowest:
        sortedList.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }
    return sortedList;
  }

  void _deleteExpense(int id) {
    setState(() {
      _expenses.removeWhere((expense) => expense.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Expense deleted')),
    );
  }

  void _navigateToCategoryDetails(ExpenseCategory category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CategoryDetailsScreen(
          category: category,
          expenses: _expenses,
        ),
      ),
    );
  }

  //додавання
  void _addExpense() {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();

    if (title.isEmpty || amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid data')),
      );
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid amount')),
      );
      return;
    }

    setState(() {
      final newExpense = Expense(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        amount: amount,
        category: _selectedCategory,
        date: DateTime.now(),
      );
      
      _expenses.add(newExpense);
      
      _titleController.clear();
      _amountController.clear();
    });

    Navigator.pop(context);
  }

  //діалогове вікно
  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Expense'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Amount', prefixText: '\$'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<ExpenseCategory>(
                    value: _selectedCategory,
                    isExpanded: true, 
                    items: ExpenseCategory.values.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Row(
                          children: [
                            Icon(category.icon, color: category.color),
                            const SizedBox(width: 8),
                            Text(category.name),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => _selectedCategory = value);
                      }
                    },
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _titleController.clear();
                    _amountController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _addExpense,
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Expenses'),
        backgroundColor: Colors.blue.shade100,
        actions: [
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort),
            onSelected: (SortOption option) {
              setState(() {
                _currentSort = option;
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: SortOption.dateNewest, child: Text('Date: Newest First')),
              PopupMenuItem(value: SortOption.dateOldest, child: Text('Date: Oldest First')),
              PopupMenuItem(value: SortOption.amountHighest, child: Text('Amount: Highest First')),
              PopupMenuItem(value: SortOption.amountLowest, child: Text('Amount: Lowest First')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Text(
              'Total: \$${_totalExpenses.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 8),
          
          Expanded(
            flex: 1, 
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: ExpenseCategory.values.map((category) {
                return CategoryCard(
                  category: category,
                  totalAmount: _getCategoryTotal(category),
                  onTap: () => _navigateToCategoryDetails(category),
                );
              }).toList(),
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: _sortedExpenses.length, 
              itemBuilder: (context, index) {
                final expense = _sortedExpenses[index]; 
                return Dismissible(
                  key: Key(expense.id.toString()),
                  direction: DismissDirection.endToStart, 
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) => _deleteExpense(expense.id),
                  child: ListTile(
                    leading: Icon(expense.category.icon, color: expense.category.color),
                    title: Text(expense.title),
                    subtitle: Text(expense.formattedDate),
                    trailing: Text(
                      expense.formattedAmount,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}