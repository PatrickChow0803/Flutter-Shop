import 'package:flutter/material.dart';
import 'product.dart';
// as http here to help avoid name clashes
import 'package:http/http.dart' as http;

// Used to convert my objects into JSON so that the data can be attached to HTTP requests.
import 'dart:convert';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
//    Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ];

  var _showFavoritesOnly = false;

  List<Product> get items {
//    if (_showFavoritesOnly) {
//      return [..._items].where((product) => product.isFavorite).toList();
//    } else {
    // [...] returns a copy of the _items
    // If I were to do return _items, I'd be returning a pointer
    return [..._items];
//    }
  }

  List<Product> get favoriteItems {
    return [...items].where((product) => product.isFavorite).toList();
  }

  Product findProductById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    const url = 'https://flutter-shop-7d47e.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
//      print(response);
      print(json.decode(response.body));
      // The returned data is a nested map. Therefore use keyword dynamic to refer to the nested map
      // Thus use Map<String (The ID of the product), dynamic (For nested map that contains the information of a product)
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<Product> loadedProducts = [];

      // prodId refers to the String, prodData refers to the dynamic
      // forEach means that for each element within the map, do something with each of the elements
      extractedData.forEach((prodId, prodData) {
        // Could also do loadedProducts.insert(0, Product()) to show the most recent products.
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavorite'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // Making this a Future<void> to display a loading indicator.
  // by using the async keyword, the entire block of code therefore returns a future automatically
  Future<void> addProduct(Product product) async {
    // need to add the json when working with Firebase
    // The products list is automatically created by Firebase
    const url = 'https://flutter-shop-7d47e.firebaseio.com/products.json';

    // sends a post request to the url passed as the argument
    // body is the data that gets attached to the post request
    // CTRL + Q highlighting the .post is very helpful
    // .post returns a future!!!
    // TYPED IN RETURN HERE BECAUSE OF Future<void>
    // No longer have to type in RETURN here because it's now async
    // await keyword tells dart that I want to wait for this operation to finish before moving to the next
    // line in the dart code
    // response is what's given back from the server
    try {
      final response = await http.post(
        url,
        // Pass in a map to encode to let it know how the json data should be.
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      // this code is executed after await http.post is finished
      final newProduct = Product(
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
        // json.decode(response.body) gives back a MAP!!! with a key called 'name', hence use the key ['name']
        id: json.decode(response.body)['name'],
      );
      // Adds an product to the end of the list
      _items.add(newProduct);

      // Adds a product to the start of the list
      // _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print('error');
      // This throws the error object up the widget tree.
      // Thus the error is thrown to edit_product_screen since that screen calls this addProduct method.
      throw error;
    }
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((existingProduct) => existingProduct.id == id);

    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
  }

//  void showFavoritesOnly() {
//    _showFavoritesOnly = true;
//    notifyListeners();
//  }
//
//  void showAll() {
//    _showFavoritesOnly = false;
//    notifyListeners();
//  }
}
