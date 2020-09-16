import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;

  CartItem({this.id, this.price, this.quantity, this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        // horizontal value should be the same value of the margin inside cart_screen
        horizontal: 15,
        vertical: 4,
      ),
      child: Padding(
        // padding value should be the same value of the padding inside cart_screen
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: FittedBox(
                child: Text('\$$price'),
              ),
            ),
          ),
          title: Text(title),
          subtitle: Text('\$${price * quantity}'),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}
