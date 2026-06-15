import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

final productsProvider = Provider<List<Product>>((ref) {
  return [
    const Product(id: '1', name: 'iPhone 14', price: 999.99, category: 'Electronics', image: '📱'),
    const Product(id: '2', name: 'MacBook Pro', price: 1999.99, category: 'Electronics', image: '💻'),
    const Product(id: '3', name: 'Apple Watch', price: 399.99, category: 'Electronics', image: '⌚'),
    const Product(id: '4', name: 'Футболка', price: 29.99, category: 'Clothing', image: '👕'),
    const Product(id: '5', name: 'Джинси', price: 59.99, category: 'Clothing', image: '👖'),
    const Product(id: '6', name: 'Книга Flutter', price: 49.99, category: 'Books', image: '📘'),
  ];
});

//варіант A
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final categoriesProvider = Provider<List<String>>((ref) {
  final products = ref.watch(productsProvider);
  return products.map((p) => p.category).toSet().toList();
});

//варіант D
final searchQueryProvider = StateProvider<String>((ref) => '');

//фільтрує продукти за категорією та пошуком
final filteredProductsProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productsProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();

  return products.where((product) {
    final matchesCategory = selectedCategory == null || product.category == selectedCategory;
    final matchesSearch = product.name.toLowerCase().contains(searchQuery);
    
    return matchesCategory && matchesSearch;
  }).toList();
});