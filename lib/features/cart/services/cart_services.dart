import 'dart:convert';

import 'package:dalvi/constants/error_handling.dart';
import 'package:dalvi/constants/global_variables.dart';
import 'package:dalvi/constants/utils.dart';
import 'package:dalvi/models/product.dart';
import 'package:dalvi/models/user.dart';
import 'package:dalvi/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CartServices {
  void removeFromCart({
    required BuildContext context,
    required Product product,
    required String size,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/api/remove-from-cart'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id!,
          'size': size,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          Users user =
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          userProvider.setUserFromModel(user);
          // showSnackBar(
          //   context,
          //   'Product Removed!',
          // );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> increaseProduct({
    required BuildContext context,
    required Product product,
    required String size,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/increase-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id!,
          'size': size,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          Users user =
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
