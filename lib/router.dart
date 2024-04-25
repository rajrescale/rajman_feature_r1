import 'package:dalvi/features/account/screens/account_screen.dart';
import 'package:dalvi/features/address/screens/address_screen.dart';
import 'package:dalvi/features/address/screens/order_confirm.dart';
import 'package:dalvi/features/admin/screens/add_products_screen.dart';
import 'package:dalvi/features/admin/screens/admin_screen.dart';
import 'package:dalvi/features/auth/screens/phone_validation.dart';
import 'package:dalvi/features/auth/screens/register.dart';
import 'package:dalvi/features/auth/screens/update_password.dart';
import 'package:dalvi/features/auth/screens/signin.dart';

import 'package:dalvi/features/cart/screens/cart_screen.dart';

import 'package:dalvi/features/home/screens/home_screen.dart';
import 'package:dalvi/features/order_details/screens/order_details.dart';
import 'package:dalvi/features/product_details/screens/product_details_screen.dart';
import 'package:dalvi/features/search/screens/search_screen.dart';
import 'package:dalvi/features/thankyou/thankyou.dart';
import 'package:dalvi/models/order.dart';
import 'package:dalvi/models/product.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(
    RouteSettings routeSettings, BuildContext context) {
  switch (routeSettings.name) {
    case SignInScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SignInScreen(),
      );
    case PhoneValidation.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const PhoneValidation(),
      );

    case UpdatePassword.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const UpdatePassword(),
      );
    case SignUpScreen.routeName:
      final String phoneNumber = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SignUpScreen(phone: phoneNumber),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case AccountScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AccountScreen(),
      );

    case CartScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const CartScreen(),
      );
    case AdminScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AdminScreen(),
      );
    case AddressScreen.routeName:
      var totalAmount = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddressScreen(
          totalAmount: totalAmount,
        ),
      );
    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddProductScreen(),
      );

    case OrderDetailScreen.routeName:
      var order = routeSettings.arguments as Order;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderDetailScreen(
          order: order,
        ),
      );

    case SearchScreen.routeName:
      var searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchScreen(
          searchQuery: searchQuery,
        ),
      );

    case ProductDetailScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductDetailScreen(
          product: product,
        ),
      );

    case ConfirmOrder.routeName:
      var totalAmount = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ConfirmOrder(totalAmount: totalAmount),
      );
    case ThankYouPage.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ThankYouPage(),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist!'),
          ),
        ),
      );
  }
}
