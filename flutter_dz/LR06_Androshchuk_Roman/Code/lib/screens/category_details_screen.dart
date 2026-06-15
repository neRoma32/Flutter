import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/category.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final ExpenseCategory category;
  final List<Expense> expenses;

  const CategoryDetailsScreen({
    super.key,
    required this.category,
    required this.expenses,
  });

  List<Expense> get _categoryExpenses {
    return expenses.where((e) => e.category == category).toList();
  }

  double get _total {
    return _categoryExpenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: category.color,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            color: category.color.withValues(alpha: 0.1),
            width: double.infinity,
            child: Column(
              children: [
                Icon(category.icon, size: 48, color: category.color),
                const SizedBox(height: 8),
                Text(
                  'Total: \$${_total.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text('${_categoryExpenses.length} transactions'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _categoryExpenses.length,
              itemBuilder: (context, index) {
                final expense = _categoryExpenses[index];
                return ListTile(
                  leading: Icon(expense.category.icon, color: expense.category.color),
                  title: Text(expense.title),
                  subtitle: Text(expense.formattedDate),
                  trailing: Text(
                    expense.formattedAmount,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}