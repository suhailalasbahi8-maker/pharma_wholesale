import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;
  
  int get itemCount => _items.length;
  
  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalPrice => _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  bool isInCart(String productId) {
    return _items.any((item) => item.id == productId);
  }

  void addToCart(CartItem item) {
    final existingIndex = _items.indexWhere((i) => i.id == item.id);
    
    if (existingIndex != -1) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void increaseQuantity(String productId) {
    final index = _items.indexWhere((item) => item.id == productId);
    if (index != -1) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String productId) {
    final index = _items.indexWhere((item) => item.id == productId);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
