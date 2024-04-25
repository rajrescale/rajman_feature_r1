// import 'package:dalvi/constants/global_variable.dart';
import 'package:dalvi/common/widgets/loader.dart';
import 'package:dalvi/features/account/widgets/single_product.dart';
import 'package:dalvi/features/admin/screens/add_products_screen.dart';
import 'package:dalvi/features/admin/services/admin_services.dart';
import 'package:dalvi/models/product.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Product>? products;
  final AdminServices adminServices = AdminServices();
  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  fetchAllProducts() async {
    products = await adminServices.fetchAllProducts(context);
    setState(() {});
  }

  void deleteProduct(Product product, int index) {
    adminServices.deleteProduct(
      context: context,
      product: product,
      onSuccess: () {
        products!.removeAt(index);
        setState(() {});
      },
    );
  }

  void naviageToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Loader()
        : Scaffold(
            body: GridView.builder(
              itemCount: products!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                final productData = products![index];
                return Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: InkWell(
                    onTap: () {
                      // Navigator.pushNamedAndRemoveUntil(
                      //   context,
                      //   AddProductScreen.routeName,
                      //   (route) => true,
                      // );
                    },
                    enableFeedback: true,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 120,
                          child: SingleProduct(
                            image: productData.images.isNotEmpty
                                ? productData.images[0]
                                : "",
                          ),
                          // child: ProductList(products: products ?? []),
                        ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Text(
                                  productData.name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    deleteProduct(productData, index),
                                icon: const Icon(
                                  Icons.delete_outline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: naviageToAddProduct,
              shape: const CircleBorder(),
              // backgroundColor: GlobalVariables.selectedNavBarColor,
              tooltip: "Add to Product",
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
