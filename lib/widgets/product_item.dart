import 'package:flutter/material.dart';
import 'package:flutter_shop/provider/product.dart';
import 'package:flutter_shop/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
//  final String id;
//  final String title;
//  final String imageUrl;
//
//  ProductItem({
//    this.id,
//    this.title,
//    this.imageUrl,
//  });

  @override
  Widget build(BuildContext context) {
    // This takes the closest product available. Which is in the grid. Look at products_grid's
    // GridView builder and look at ProductItem widget using it.
    final product = Provider.of<Product>(context, listen: false);
    print('Widget has been rebuilt');
    // Use ClipRRect here to make the boxes circular since GridTile doesn't have a borderRadius
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
//            Navigator.of(context).push(
//              MaterialPageRoute(
//                builder: (ctx) => ProductDetailScreen(
//                  title: title,
//                ),
//              ),
//            );
            Navigator.of(context).pushNamed(
              ProductDetailScreen.nameRoute,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          // Consumer can be used to only rebuild parts of the widget tree instead of the entire widget.
          // Best to only wrap something in a consumer widget if you expect it to change.
          // By having the consumer here, only the IconButton gets rebuilt. The above must be listen: false
          // in order to have consumer work properly.
          leading: Consumer<Product>(
            builder: (context, product, child) => IconButton(
              icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavoriteStatus();
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black87,
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
