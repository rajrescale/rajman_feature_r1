import 'dart:convert';
import 'dart:typed_data';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dalvi/constants/error_handling.dart';
import 'package:dalvi/constants/global_variables.dart';
import 'package:dalvi/constants/utils.dart';
import 'package:dalvi/features/admin/models/sales.dart';
import 'package:dalvi/models/order.dart';
import 'package:dalvi/models/product.dart';
import 'package:dalvi/providers/user_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AdminServices {
  List<String> imageUrls = [];
// Function to determine the image type based on the first few bytes of the image data
  String getImageType(Uint8List imageData) {
    if (imageData.length >= 2 && imageData[0] == 0xFF && imageData[1] == 0xD8) {
      return 'jpeg';
    } else if (imageData.length >= 8 &&
        imageData[0] == 0x89 &&
        imageData[1] == 0x50 &&
        imageData[2] == 0x4E &&
        imageData[3] == 0x47 &&
        imageData[4] == 0x0D &&
        imageData[5] == 0x0A &&
        imageData[6] == 0x1A &&
        imageData[7] == 0x0A) {
      return 'png';
    } else {
      // Default to 'jpeg' if the image type cannot be determined
      return 'jpeg';
    }
  }

  String getImageTypePath(String imageData) {
    if (imageData.endsWith(".png")) {
      return 'png';
    } else if (imageData.endsWith(".jpeg")) {
      return 'jpeg';
    } else if (imageData.endsWith(".jpg")) {
      return 'jpg';
    } else {
      return "jpeg"; // Default to 'jpeg' if the image type cannot be determined
    }
  }

  Future<List<String>> uploadImageToCloudinary(
      BuildContext context, Uint8List imageData) async {
    // Convert the image bytes to base64
    String base64Image = base64Encode(imageData);
    // Determine the image type based on the first few bytes of the image data
    String imageType = getImageType(imageData);

    // Prepare the data to be sent in the POST request
    Map<String, String> data = {
      'file':
          'data:image/$imageType;base64,$base64Image', // Adjust the image type if needed
      'upload_preset':
          'uuwxob6q', // Replace 'your_upload_preset' with your Cloudinary upload preset
    };

    // Make the POST request to Cloudinary's upload API endpoint
    http.Response response = await http.post(
      Uri.parse('https://api.cloudinary.com/v1_1/drixhjpsy/image/upload'),
      body: data,
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse the response JSON
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Extract the secure URL of the uploaded image
      String imageUrl = jsonResponse['secure_url'];
      imageUrls.add(imageUrl);
      // Handle the uploaded image URL as needed
      // print('Uploaded image URL: $imageUrl');
    } else {
      // Handle error
      showSnackBar(context,
          'Failed to upload image. Status code: ${response.statusCode}');
      showSnackBar(context, 'Product Added Successfully!');
    }
    // print(imageUrls);
    return imageUrls;
  }

  Future<String> uploadimage(BuildContext context, PlatformFile file) async {
    final cloudinary = CloudinaryPublic('drixhjpsy', 'uuwxob6q');
    CloudinaryResponse res = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(file.path!, folder: file.extension));
    imageUrls.add(res.secureUrl);
    return res.secureUrl;
  }

  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required int quantity,
    required List<String> imageUrls,
    required List<Map<String, dynamic>> sizesAndPrices,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      // print(imageUrls);
      // print(imageUrls[0]);
      Product product = Product(
        name: name,
        description: description,
        quantity: quantity,
        images: imageUrls,
        sizesAndPrices: sizesAndPrices,
      );

      http.Response res = await http.post(
        Uri.parse('$uri/admin/add-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: product.toJson(),
      );
      httpErrorHandle(
          context: context,
          response: res,
          onSuccess: () {
            showSnackBar(context, 'Product Added Successfully!');

            Navigator.pop(context);
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // void changeProductDetails({
  //   required BuildContext context,
  //   required String name,
  //   required String description,
  //   required int price,
  //   required int quantity,
  //   required String image,
  // }) async {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //   List<String> imageUrls = [image];
  //   try {
  //     Product product = Product(
  //       name: name,
  //       description: description,
  //       quantity: quantity,
  //       images: imageUrls,
  //     );

  //     http.Response res = await http.post(
  //       Uri.parse('$uri/admin/change-product-details'),
  //       headers: {
  //         'Content-Type': 'application/json; charset=UTF-8',
  //         'x-auth-token': userProvider.user.token,
  //       },
  //       body: product.toJson(),
  //     );
  //     httpErrorHandle(
  //         context: context,
  //         response: res,
  //         onSuccess: () {
  //           showSnackBar(context, 'Changed Successfully!');

  //           Navigator.pop(context);
  //         });
  //   } catch (e) {
  //     showSnackBar(context, e.toString());
  //   }
  // }

// get all the productss
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/admin/get-products'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
          context: context,
          response: res,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body).length; i++) {
              productList.add(
                Product.fromJson(
                  jsonEncode(
                    jsonDecode(res.body)[i],
                  ),
                ),
              );
            }
          });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }

// delete Product
  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/delete-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/admin/get-orders'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            orderList.add(
              Order.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return orderList;
  }

  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
    required int lastUpdate,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/change-order-status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': order.id,
          'status': status,
          'lastUpdate': lastUpdate, // Include lastUpdate in the request body
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: onSuccess,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Sales> sales = [];
    int totalEarning = 0;
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/admin/analytics'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': userProvider.user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var response = jsonDecode(res.body);
          totalEarning = response['totalEarnings'];
          sales = [
            Sales('Mobiles', response['mobileEarnings']),
            Sales('Essentials', response['essentialEarnings']),
            Sales('Books', response['booksEarnings']),
            Sales('Appliances', response['applianceEarnings']),
            Sales('Fashion', response['fashionEarnings']),
          ];
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return {
      'sales': sales,
      'totalEarnings': totalEarning,
    };
  }

  static signinUserFirebase(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      showSnackBar(context, 'You are Logged in');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(context, 'No user Found with this Email');
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, 'Password did not match');
      }
    }
  }
}
