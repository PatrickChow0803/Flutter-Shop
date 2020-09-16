import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  // The string in this map is used as a key.
  // Might make more since to remember _items as the actual cart.
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items == null ? 0 : _items.length;
  }

  void addItem(String productId, double price, String title) {
    // If the item already exists in the cart, then add one to the quantity
    if (_items.containsKey(productId)) {
      // add quantity
      _items.update(
        // productId is the key that I pass in to look for within the map
        productId,
        // existingCartItem is the CartItem that was found given the productId
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      // If the item doesn't exist in the cart, then add it to the map.
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          price: price,
          title: title,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }
}
