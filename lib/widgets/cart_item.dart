import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';

class CartItem extends StatelessWidget {
  // id is the Cart's id
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem({this.id, this.productId, this.price, this.quantity, this.title});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),

        // margin values are the same as the card so that the animation only affects the card.
        margin: EdgeInsets.symmetric(
          // horizontal value should be the same value of the margin inside cart_screen
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        // listen: false here because I don't care about changes here.
        // I do care about changes inside of the cart_screen though,
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      // confirmDismiss is all the code for alerting about the removal of a product from the cart.
      confirmDismiss: (direction) {
        // confirmDismiss requires a Boolean to be returned.
        // showDialog is a Future<bool>, therefore return showDialog here.
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove the item from the cart?'),
            actions: [
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  // This passed the value of false to showDialog
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                // This passed the value of true to showDialog
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        );
      },
      child: Card(
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
      ),
    );
  }
}
