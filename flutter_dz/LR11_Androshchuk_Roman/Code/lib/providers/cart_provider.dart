import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

class CartNotifier extends StateNotifier<List<Product>> {
  CartNotifier() : super([]);

  void addProduct(Product product) {
    //варіант B
    final existingIndex = state.indexWhere((p) => p.id == product.id);
    
    if (existingIndex >= 0) {
      final newState = [...state];
      final existingProduct = newState[existingIndex];
      newState[existingIndex] = existingProduct.copyWith(quantity: existingProduct.quantity + 1);
      state = newState;
    } else {
      state = [...state, product];
    }
  }

  void decreaseQuantity(String productId) {
    final existingIndex = state.indexWhere((p) => p.id == productId);
    
    if (existingIndex >= 0) {
      final existingProduct = state[existingIndex];
      if (existingProduct.quantity > 1) {
        final newState = [...state];
        newState[existingIndex] = existingProduct.copyWith(quantity: existingProduct.quantity - 1);
        state = newState;
      } else {
        removeProduct(productId);
      }
    }
  }

  void removeProduct(String productId) {
    state = state.where((p) => p.id != productId).toList();
  }

  void clear() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<Product>>((ref) {
  return CartNotifier();
});

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0.0, (sum, product) => sum + (product.price * product.quantity));
});

final cartCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, product) => sum + product.quantity);
});