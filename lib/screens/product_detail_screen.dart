import 'package:flutter/material.dart';
import 'file:///C:/Users/Agela/AndroidStudioProjects/Max/Flutter-Shop/flutter_shop/lib/provider/product.dart';
import 'package:flutter_shop/provider/products_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
//  final String title;
//
//  ProductDetailScreen({this.title});

  static const nameRoute = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    // Find out which product was chosen by looping through the entire list.
    // Return the first product within the list that has the same id as the chosen produce's id.
    // listen: false makes it so that the widget wont rebuild if notifyListener is called.
    // Use listen:false when you only want the widget to build once.
    // Only want to use if you want to get the data one time from the global data storage
    // but you're not interested in updates.
    // You'd want listen: true (default) in the product_grid widget for example because you'd want the
    // grid to rebuild when a new product is added or when a product changes in some way.
    final chosenProduct =
        Provider.of<ProductsProvider>(context, listen: false).findProductById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(chosenProduct.title),
      ),
    );
  }
}
