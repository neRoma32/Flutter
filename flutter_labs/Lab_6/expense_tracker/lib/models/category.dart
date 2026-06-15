import 'package:flutter/material.dart';

enum ExpenseCategory { food, transport, shopping, other }

extension ExpenseCategoryExtension on ExpenseCategory {
  String get name {
    switch (this) {
      case ExpenseCategory.food: return 'Food';
      case ExpenseCategory.transport: return 'Transport';
      case ExpenseCategory.shopping: return 'Shopping';
      case ExpenseCategory.other: return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case ExpenseCategory.food: return Icons.restaurant;
      case ExpenseCategory.transport: return Icons.directions_car;
      case ExpenseCategory.shopping: return Icons.shopping_bag;
      case ExpenseCategory.other: return Icons.category;
    }
  }

  Color get color {
    switch (this) {
      case ExpenseCategory.food: return Colors.orange;
      case ExpenseCategory.transport: return Colors.blue;
      case ExpenseCategory.shopping: return Colors.purple;
      case ExpenseCategory.other: return Colors.grey;
    }
  }
}