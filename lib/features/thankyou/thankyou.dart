import 'package:dalvi/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:dalvi/features/account/screens/account_screen.dart';
import 'package:dalvi/features/account/services/account_services.dart';

class ThankYouPage extends StatefulWidget {
  static const String routeName = '/thankyou';
  const ThankYouPage({super.key});

  @override
  State<ThankYouPage> createState() => _ThankYouPageState();
}

class _ThankYouPageState extends State<ThankYouPage> {
  final AccountServices accountServices = AccountServices();

  void naviagteToHomeScreen(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      HomeScreen.routeName,
      (route) => false,
    );
  }

  void navigateToMyOrdersScreen(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AccountScreen.routeName,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // final userProvider = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thank You'),
      ),
      body: buildThankYouBody(),
    );
  }

  Widget buildThankYouBody() {
    return Center(
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
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
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Your order has been successfully placed.',
                style: TextStyle(fontSize: 16),
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
