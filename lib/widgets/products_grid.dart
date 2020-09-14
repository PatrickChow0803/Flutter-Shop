import 'package:flutter/material.dart';
import 'package:flutter_shop/models/product.dart';
import 'package:flutter_shop/provider/products_provider.dart';
import 'package:flutter_shop/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = productsData.items;

    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // The number of columns
          childAspectRatio: 3 / 2, // The items should be a little bit higher than they are wide
          crossAxisSpacing: 10.0, // The spacing between the columns
          mainAxisSpacing: 10.0 // The spacing between the rows
          ),
      itemBuilder: ((ctx, index) {
        return ProductItem(
          title: products[index].title,
          id: products[index].id,
          imageUrl: products[index].imageUrl,
        );
      }),
      itemCount: products.length,
    );
  }
}
