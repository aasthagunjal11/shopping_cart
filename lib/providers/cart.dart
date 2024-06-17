import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class Cart with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice {
    return _items.fold(
        0, (total, item) => total + item.product.price * item.quantity);
  }

  void addToCart(Product product) {
    bool isExisting = false;
    for (var item in _items) {
      if (item.product.name == product.name) {
        item.quantity++;
        isExisting = true;
        break;
      }
    }
    if (!isExisting) {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void increaseQuantity(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
      notifyListeners();
    }
  }
}
