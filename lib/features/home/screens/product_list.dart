import 'package:dalvi/constants/global_variables.dart';
import 'package:dalvi/features/product_details/screens/product_details_screen.dart';
import 'package:dalvi/models/product.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  final List<Product> products;

  const ProductList({required this.products, super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.products.map((product) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20), // Add bottom margin
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: product),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.network(
                    product.images.isEmpty
                        ? "https://res.cloudinary.com/drixhjpsy/image/upload/v1712149156/ne4bi3wxn0eegmowqypx.png"
                        : product.images[0],
                    fit: BoxFit.fitWidth,
                    height: 125,
                    width: 125,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SizedBox(
                      // width: 170,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // width: 100,
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                Text(
                                  ' ${product.name} ',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  semanticsLabel:
                                      'Title is ${product.name}  ${product.sizesAndPrices[0]['size']}',
                                ),
                                Text(
                                    ' ( ${product.sizesAndPrices[0]['size']} )')
                              ],
                            ),
                          ),
                          Container(
                            // width: 100,
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              '₹ ${product.sizesAndPrices[0]['price']} ',
                              // "Price",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            // width: 100,
                            padding: const EdgeInsets.only(top: 5),
                            child: const Text(
                              'In Stock',
                              style: TextStyle(
                                color: GlobalVariables.specialColor,
                                fontSize: 10,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
