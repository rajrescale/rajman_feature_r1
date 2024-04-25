import 'dart:convert';

import 'package:dalvi/constants/error_handling.dart';
import 'package:dalvi/constants/global_variables.dart';
import 'package:dalvi/constants/utils.dart';
import 'package:dalvi/features/admin/screens/admin_screen.dart';
import 'package:dalvi/features/cart/screens/cart_screen.dart';
import 'package:dalvi/features/home/screens/home_screen.dart';
import 'package:dalvi/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dalvi/models/user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String id = "";
  Future<String> getUserDetails({
    required BuildContext context,
    required String otp,
    required String newpass,
    required String confnewpass,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$uri/updatepassword'),
        body: jsonEncode(
            {'otp': otp, 'newpass': newpass, "confnewpass": confnewpass}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          // Assuming res.body contains the JSON response
          // String responseBody = res.body;

          // Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

          // String userId = jsonResponse['user']['otp'];
          id = 'Password reset successfully!';
          // print(userId);
        },
      );
    } catch (e) {
      // Catch any exceptions thrown during the request
      showSnackBar(context, e.toString());
    }
    return id;
  }

  // signup user
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      Users user = Users(
        id: '',
        name: name,
        email: email,
        phone: phone,
        password: password,
        address: '',
        otp: [], // Change from empty string to empty list
        type: '',
        token: '',
        cart: [],
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          showSnackBar(
            context,
            'Signup Successfully!',
          );

          Navigator.pushNamedAndRemoveUntil(
            context,
            HomeScreen.routeName,
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> getEmailResetPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$uri/generateotp'),
        body: jsonEncode({'email': email}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          showSnackBar(context, "check your email!");
        },
      );
    } catch (e) {
      // Catch any exceptions thrown during the request
      showSnackBar(context, e.toString());
    }
  }

// sign In user
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);
          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          // print(Provider.of<UserProvider>(context, listen: false).user.token);
          Future.microtask(() {
            final userType =
                Provider.of<UserProvider>(context, listen: false).user.type;
            if (userType == "admin") {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AdminScreen.routeName,
                (route) => false,
              );
            } else if (userType == "user") {
              // Check if the user has items in their cart
              if (userProvider.user.cart.isNotEmpty) {
                // Navigate to cart screen
                Navigator.pushReplacementNamed(context, CartScreen.routeName);
              } else {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  HomeScreen.routeName,
                  (route) => false,
                );
              }
            }
          });
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //  get user data
  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  static String verifyId = "";

  // to sent and otp to user
  static Future sentOtp({
    required String phone,
    required Function errorStep,
    required Function nextStep,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      timeout: const Duration(seconds: 120),
      phoneNumber: "+91$phone",
      verificationCompleted: (phoneAuthCredential) async {},
      verificationFailed: (error) async {
        errorStep();
      },
      codeSent: (verificationId, forceResendingToken) async {
        verifyId = verificationId;
        nextStep();
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
  }

  // verify the otp code and login
  static Future verifyOtp({required String otp}) async {
    final cred =
        PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp);

    try {
      final user = await _firebaseAuth.signInWithCredential(cred);
      if (user.user != null) {
        return "Success";
      } else {
        return "Error in Otp login";
      }
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  // to logout the user
  static Future logout() async {
    await _firebaseAuth.signOut();
  }

  // check whether the user is logged in or not
  static Future<bool> isLoggedIn(
    BuildContext context,
  ) async {
    var user = _firebaseAuth.currentUser;
    return user != null;
  }
}
