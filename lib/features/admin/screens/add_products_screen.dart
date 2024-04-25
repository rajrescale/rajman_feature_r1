import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dalvi/common/widgets/custom_button.dart';
import 'package:dalvi/common/widgets/custom_textfield.dart';
import 'package:dalvi/constants/global_variables.dart';
import 'package:dalvi/features/admin/services/admin_services.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final List<TextEditingController> sizeControllers =
      List.generate(3, (index) => TextEditingController());
  final List<TextEditingController> priceControllers =
      List.generate(3, (index) => TextEditingController());

  final AdminServices adminServices = AdminServices();
  File? file;
  FilePickerResult? result;
  Uint8List? imageBytes;
  Uint8List? images;
  List<String> url = [];
  final _addProductFormKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    for (var controller in sizeControllers) {
      controller.dispose();
    }
    for (var controller in priceControllers) {
      controller.dispose();
    }
  }

  Future<Object?> pickImages() async {
    try {
      if (kIsWeb) {
        // For web, iOS, and Android, pick image as bytes
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
        );

        if (result != null && result.files.isNotEmpty) {
          // Read the selected file as bytes
          PlatformFile file = result.files.first;
          Uint8List? fileBytes = file.bytes;
          Uint8List bytes = Uint8List.fromList(fileBytes!);
          imageBytes = bytes;
        } else {
          // User canceled the picker or no file was selected
          return [];
        }

        if (imageBytes != null) {
          adminServices
              .uploadImageToCloudinary(context, imageBytes!)
              .then((List<String> imageUrlList) {
            setState(() {
              url = imageUrlList;
            });
          });
        }
      } else if (await Permission.storage.request().isGranted) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
        );

        if (result != null && result.files.isNotEmpty) {
          // Get the file path
          PlatformFile file = result.files.first;
          adminServices.uploadimage(context, file).then((String imageUrlList) {
            setState(() {
              url.add(imageUrlList);
            });
          });
        } else {
          // User canceled the picker or no file was selected
          return [];
        }
      }
    } catch (e) {
      // Handle any errors that occur during the file picking process
      return [];
    }

    return imageBytes;
  }

  void sellProduct() {
    // Extract size and price data from controllers
    List<Map<String, dynamic>> sizesAndPrices = List.generate(3, (index) {
      return {
        'size': sizeControllers[index].text,
        'price': int.parse(priceControllers[index].text),
      };
    });
    if (_addProductFormKey.currentState!.validate()) {
      print('URL length: ${url}');
      print('URL : ${url[0]}');
      adminServices.sellProduct(
        context: context,
        name: productNameController.text,
        description: descriptionController.text,
        sizesAndPrices: sizesAndPrices,
        imageUrls: url,
        quantity: int.parse(quantityController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          title: const Text(
            'Add Product',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      // body: ,
      body: SingleChildScrollView(
        child: Form(
          key: _addProductFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                if (url.isNotEmpty) ...{
                  CarouselSlider(
                    items: url.map((imageUrl) {
                      return Builder(
                        builder: (BuildContext context) => Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          height: 200,
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      viewportFraction: 1,
                      height: 200,
                    ),
                  ),
                } else ...{
                  GestureDetector(
                    onTap: pickImages,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(10),
                      dashPattern: const [10, 4],
                      strokeCap: StrokeCap.round,
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_open,
                              size: 40,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Select Product Images",
                              style: TextStyle(
                                fontSize: 15,
                                color: GlobalVariables.specialGray,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                },
                const SizedBox(
                  height: 25,
                ),
                CustomTextField(
                  controller: productNameController,
                  hintText: 'Product Name',
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'Description',
                  maxLines: 3,
                ),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: sizeControllers.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        CustomTextField(
                          controller: sizeControllers[index],
                          hintText: 'Size ${index + 1}',
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: priceControllers[index],
                          hintText: 'Price ${index + 1}',
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: quantityController,
                  hintText: 'Quantity',
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                  text: 'Sell',
                  onTap: sellProduct,
                  // color: GlobalVariables.customCyan,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
