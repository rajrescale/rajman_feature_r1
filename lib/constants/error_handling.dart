import 'dart:convert';

import 'package:dalvi/constants/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> httpErrorHandle({
  required BuildContext context,
  required http.Response response,
  required VoidCallback onSuccess,
}) async {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackBar(context, jsonDecode(response.body)['msg']);
      break;
    case 500:
      showSnackBar(context, jsonDecode(response.body)['error']);
      break;
    default:
      showSnackBar(context, response.body);
  }
}
