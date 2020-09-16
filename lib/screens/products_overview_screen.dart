import 'package:flutter/material.dart';
import 'package:flutter_shop/widgets/badge.dart';
import 'package:flutter_shop/widgets/products_grid.dart';
import 'package:provider/provider.dart';
import '../provider/products_provider.dart';
import '../provider/cart.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    // listen: false here because I don't care about the data or whether it changes.
    // I only need access to that I can call the favorite/all methods.
//    final productsContainer = Provider.of<ProductsProvider>(context, listen: false);

    // I need access to the cart to get the cart's length. But instead of doing
    // final cart = Provider.of<Cart>(context), I should use a consumer because only one little widget is
    // dependent on the cart's information. If i had done final cart = Provider.of<Cart>(context), then
    // the entire widget would have to rebuild when I rather only have one little widget (The cart icon) rebuild

    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
//                productsContainer.showFavoritesOnly();
                  _showOnlyFavorites = true;
                } else {
//                productsContainer.showAll();
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Show Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              )
            ],
          ),
          Consumer<Cart>(
            // cartData is what I use to get access to the cart methods.
            // The ch refers to the IconButton child below.
            // I want to move the IconButton out of the builder to prevent it from rebuilding
            // The only things I want inside the builder method are things that will actually change.
            builder: (context, cartData, ch) => Badge(
              child: ch,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
