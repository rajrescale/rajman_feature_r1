import 'package:dalvi/constants/global_variables.dart';
import 'package:dalvi/constants/utils.dart';
import 'package:dalvi/features/account/services/account_services.dart';
import 'package:dalvi/features/address/services/address_services.dart';
import 'package:dalvi/features/thankyou/thankyou.dart';
import 'package:dalvi/models/order.dart';
import 'package:dalvi/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmOrder extends StatefulWidget {
  static const String routeName = '/confirm-order';
  final String totalAmount;
  const ConfirmOrder({
    super.key,
    required this.totalAmount,
  });

  @override
  State<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  int _value = 1;
  List<Order>? orders;
  final AccountServices accountServices = AccountServices();
  final AddressServices addressServices = AddressServices();
  bool isLoading = true;
  double tax = 100;
  double deliveryCharge = 50;
  double offer = 0;
  double totalPrice = 0;
  void navigateToThankYouScreen() {
    Navigator.pushReplacementNamed(
      context,
      ThankYouPage.routeName,
    );
  }

  void cashOnDelivery(double totalPrice) async {
    setState(() {
      totalPrice =
          double.parse(widget.totalAmount) + tax + deliveryCharge - offer;
    });
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isNotEmpty) {
      addressServices
          .placeOrder(
        context: context,
        address: Provider.of<UserProvider>(context, listen: false).user.address,
        totalSum: totalPrice,
      )
          .then((_) {
        navigateToThankYouScreen();
      }).catchError((error) {
        showSnackBar(context, error);
      });
    }
  }

  Widget build(BuildContext context) {
    String address =
        Provider.of<UserProvider>(context, listen: false).user.address;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Dalvi Farms'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Order now.',
                style: TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(
                  minHeight: 0,
                  maxHeight: double.infinity,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Address details',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Shipping to :        '),
                          Expanded(
                            child: Tooltip(
                              message: address,
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(
                                    2), // Optional: Add border radius
                              ),
                              child: Text(
                                address,
                                maxLines:
                                    1, // Set the maximum number of lines before wrapping
                                overflow: TextOverflow
                                    .ellipsis, // Handle overflow with ellipsis
                              ),
                            ),
                          )
                        ],
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Estimated delivery :'),
                          Text(
                            'Order will be delivered in approximately 2-3 Days',
                          )
                        ],
                      ),
                      Divider(
                        thickness: 1,
                        color: Theme.of(context).primaryColor,
                      ),
                      const Text(
                        'Bill details',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Item Total:'),
                          Text('₹ ${widget.totalAmount}')
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Delivery charge:'),
                          Text('₹ $deliveryCharge'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tax:'),
                          Text(
                            ' ₹ $tax',
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Offers :'),
                          Text(
                            '- ₹ $offer',
                            style: const TextStyle(
                                color: GlobalVariables.specialColor),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Order Total :',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '₹ ${double.parse(widget.totalAmount) + tax + deliveryCharge - offer}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 0,
                  maxHeight: double.infinity,
                ),
                width: double.infinity,
                decoration: (BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7)
                    ])),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Payment mode',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Radio(
                            value: 1,
                            groupValue: _value,
                            onChanged: (value) {
                              setState(() {
                                _value = value as int;
                              });
                            },
                          ),
                          const Text(
                            'Cash on delivery',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    if (Provider.of<UserProvider>(context, listen: false)
                        .user
                        .cart
                        .isNotEmpty) {
                      cashOnDelivery(totalPrice);
                    } else {
                      showSnackBar(context, "Select Product");
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.amber.shade300),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Confirm your order',
                    style: TextStyle(color: Colors.black),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
