import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// This class used to be in the models package.
// This was moved to the provider package because isFavorite is dynamic.
// I want to modify the UI because isFavorite will change.

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final url = 'https://flutter-shop-7d47e.firebaseio.com/products/$id.json';
      final response = await http.patch(url, body: json.encode({'isFavorite': isFavorite}));

      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
      // Incase the favorite status toggle didn't work properly, make the favorite the old value
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
