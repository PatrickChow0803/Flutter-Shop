import 'package:flutter/material.dart';
import 'package:flutter_shop/screens/cart_screen.dart';
import 'package:flutter_shop/widgets/badge.dart';
import 'package:flutter_shop/widgets/products_grid.dart';
import 'package:provider/provider.dart';
import '../provider/products_provider.dart';
import '../provider/cart.dart';
import '../widgets/app_drawer.dart';

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
  var _isInit = true;

  // CAN"T USE of.(context) IN initState() !!!
  @override
  void initState() {
//    Provider.of<ProductsProvider>(context, listen: false).fetchAndSetProducts();
//    super.initState();
  }

  // This is run when the widgets have been fully initialized but before build runs for the first time
  @override
  void didChangeDependencies() {
    // This code is here to make it so that the products are only obtained only once
    if (_isInit) {
      Provider.of<ProductsProvider>(context).fetchAndSetProducts();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
