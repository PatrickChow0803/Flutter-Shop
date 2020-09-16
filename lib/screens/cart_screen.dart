import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// show Cart makes it so that only the class named Cart within the cart.dart file is implemented
import '../provider/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../provider/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20.0),
                  ),
//                  SizedBox(width: 10.0),
                  // Spacer moves the widgets to the right of it as much right as possible
                  // Therefore the Chip widget is pushed to the right even though MainAxisAlignment
                  // is set spaceBetween.
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount}',
                      style: TextStyle(color: Theme.of(context).primaryTextTheme.headline6.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: Text(
                      'Order Now',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    onPressed: () {
                      // listen: false here because idc about changes in the order
                      // I only care about the changes in the cart in this screen.
                      Provider.of<Orders>(context, listen: false).addOrder(
                        cart.items.values.toList(),
                        cart.totalAmount,
                      );
                      cart.clearCart();
                    },
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => CartItem(
                // cart.items is a map. In order to get the values from the map, use .values
                // .values gives an iterable, which you should turn into a list and look at that list's at an index
                id: cart.items.values.toList()[index].id,
                productId: cart.items.keys.toList()[index],
                title: cart.items.values.toList()[index].title,
                quantity: cart.items.values.toList()[index].quantity,
                price: cart.items.values.toList()[index].price,
              ),
              itemCount: cart.itemCount,
            ),
          )
        ],
      ),
    );
  }
}
