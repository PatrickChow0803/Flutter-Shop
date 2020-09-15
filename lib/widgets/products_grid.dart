import 'package:flutter/material.dart';
import 'file:///C:/Users/Agela/AndroidStudioProjects/Max/Flutter-Shop/flutter_shop/lib/provider/product.dart';
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

      /*
      Instead of using the commented out method below, use ChangeNotifierProvider.value method below when
      using a provider on a list or a grid. .value makes sure that the provider works even if the
      data changes for a widget.
      return ChangeNotifierProvider(
      // Return the data that you want to provide
      create: (ctx) => ProductsProvider(),
     */
      itemBuilder: ((ctx, index) => ChangeNotifierProvider.value(
            value: products[index],
            child: ProductItem(
                // These are no longer needed because of provider.
//              title: products[index].title,
//              id: products[index].id,
//              imageUrl: products[index].imageUrl,
                ),
          )),
      itemCount: products.length,
    );
  }
}
