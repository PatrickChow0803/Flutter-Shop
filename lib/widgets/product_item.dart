import 'package:flutter/material.dart';
import 'package:flutter_shop/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  ProductItem({
    this.id,
    this.title,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
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
              arguments: id,
            );
          },
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {},
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            title,
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
