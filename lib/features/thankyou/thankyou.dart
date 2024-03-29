import 'package:dalvi/constants/utils.dart';
import 'package:dalvi/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:dalvi/features/account/screens/account_screen.dart';
import 'package:dalvi/features/account/services/account_services.dart';
import 'package:dalvi/models/order.dart';
import 'package:dalvi/models/product.dart';

class ThankYouPage extends StatefulWidget {
  static const String routeName = '/thankyou';
  const ThankYouPage({Key? key}) : super(key: key);

  @override
  State<ThankYouPage> createState() => _ThankYouPageState();
}

class _ThankYouPageState extends State<ThankYouPage> {
  List<Order>? orders;
  final AccountServices accountServices = AccountServices();
  bool isLoading = true;

  void naviagteToHomeScreen(BuildContext context) {
    Navigator.pushNamed(context, HomeScreen.routeName);
  }

  void navigateToMyOrdersScreen(BuildContext context) {
    Navigator.pushNamed(context, AccountScreen.routeName);
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    try {
      orders = await accountServices.fetchMyOrders(context: context);
    } catch (error) {
      showSnackBar(context, error.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thank You'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Show a loading indicator
            )
          : buildThankYouBody(),
    );
  }

  Widget buildThankYouBody() {
    Order? lastOrder = orders?.first;
    List<Product>? productList = lastOrder?.products;
    int? length = productList?.length ?? 0;
    return Center(
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 100,
                color: Colors.green,
              ),
              const SizedBox(height: 20),
              const Text(
                'Thank You for Your Purchase!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your order has been successfully placed.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 5,
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                left: 15,
                              ),
                              child: const Text(
                                'Order Id :',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                right: 15,
                              ),
                              child: Text(
                                '${lastOrder?.id}',
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0; i < length; i++)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                          left: 15,
                                        ),
                                        child: const Text(
                                          'Product Name :',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                          right: 15,
                                        ),
                                        child: Text(
                                          '${productList?[i].name}',
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                          left: 15,
                                        ),
                                        child: const Text(
                                          'Quantity :',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                          right: 15,
                                        ),
                                        child: Text(
                                          '${lastOrder?.quantity[i]}',
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                    left: 15,
                                  ),
                                  child: const Text(
                                    'Total Price :',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                    right: 15,
                                  ),
                                  child: Text(
                                    '₹ ${lastOrder?.totalPrice}',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      naviagteToHomeScreen(context);
                    },
                    child: const Text(
                      'Continue Shopping',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      navigateToMyOrdersScreen(context);
                    },
                    child: const Text(
                      'My Orders',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
