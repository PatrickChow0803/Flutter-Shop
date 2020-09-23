import 'package:flutter/material.dart';
import 'package:flutter_shop/provider/auth.dart';
import 'package:flutter_shop/provider/cart.dart';
import 'package:flutter_shop/provider/products_provider.dart';
import 'package:flutter_shop/screens/product_detail_screen.dart';
import 'package:flutter_shop/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';
import 'screens/cart_screen.dart';
import 'provider/orders.dart';
import 'screens/orders_screen.dart';
import 'screens/user_products_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*
      Instead of using the commented out method below, use ChangeNotifierProvider.value method below when
      using a provider on a list or a grid. .value makes sure that the provider works even if the
      data changes for a widget.
      return ChangeNotifierProvider(
      // Return the data that you want to provide
      create: (ctx) => ProductsProvider(),
     */
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth()),
          ChangeNotifierProvider.value(
            // Return the data that you want to provide
            value: ProductsProvider(),
          ),
          ChangeNotifierProvider.value(
            // Return the data that you want to provide
            value: Cart(),
          ),
          ChangeNotifierProvider.value(
            value: Orders(),
          ),
        ],
        // Consumer widget makes it so that the MaterialApp is rebuilt whenever Auth changes.
        // This is used so that if a user is already logged in, i want to the user to automatically directed to the ProductsOverScreen
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrangeAccent,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
            routes: {
              ProductDetailScreen.nameRoute: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
