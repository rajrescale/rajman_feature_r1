import 'package:dalvi/common/widgets/custom_button.dart';
import 'package:dalvi/common/widgets/custom_textfield.dart';
import 'package:dalvi/features/address/screens/order_confirm.dart';
import 'package:dalvi/features/address/services/address_services.dart';
import 'package:dalvi/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dalvi/constants/utils.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;
  const AddressScreen({
    super.key,
    required this.totalAmount,
  });

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController flatBuildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();

  String addressToBeUsed = "";
  bool sameAddress = false;
  final AddressServices addressServices = AddressServices();

  String? payment =
      "CashOnDelivery"; // Initial value for the radio button group

// Function to handle radio button changes
  void _handleRadioValueChange(String? value) {
    setState(() {
      payment = value; // Update the selected value
    });
  }

  void navigateToOrderConfirmScreen() {
    Navigator.pushReplacementNamed(
      context,
      ConfirmOrder.routeName,
      arguments: widget.totalAmount,
    );
  }

  @override
  void dispose() {
    super.dispose();
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
  }

  void saveAddress(String addressFromProvider) {
    addressToBeUsed = "";

    // 1. Validate Form Fields and Build Address Strin
    if (!sameAddress) {
      if (flatBuildingController.text.isNotEmpty ||
          areaController.text.isNotEmpty ||
          pincodeController.text.isNotEmpty ||
          cityController.text.isNotEmpty) {
        if (_addressFormKey.currentState!.validate()) {
          addressToBeUsed =
              '${flatBuildingController.text}, ${areaController.text}, '
              '${cityController.text}, ${pincodeController.text}';
        } else {
          showSnackBar(context, "Please enter all the values correctly!");
          return; // Exit the function early if validation fails
        }
      }
    }

    // 2. Handle Address Selection (Form or Provider)
    if (addressToBeUsed.isNotEmpty) {
      // Address entered through the form
      _handleAddressUpdate(addressToBeUsed);
    } else if (addressFromProvider.isNotEmpty) {
      // Address retrieved from a provider
      _handleAddressUpdate(addressFromProvider)
          .then((_) => {navigateToOrderConfirmScreen()});
    } else {
      showSnackBar(context, "Please enter or select an address!");
    }
  }

// Helper function to handle address update logic
  Future<void> _handleAddressUpdate(String address) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user.address != address ||
        userProvider.user.address.isEmpty) {
      addressServices.saveUserAddress(context: context, address: address).then(
            (value) => {
              navigateToOrderConfirmScreen(),
            },
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;
    var cart = Provider.of<UserProvider>(context).user.cart;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: sameAddress
                                ? Theme.of(context).primaryColor
                                : Colors.black12,
                            width: sameAddress ? 2 : 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              sameAddress = !sameAddress;
                            });
                          },
                          child: Text(
                            address,
                            style: const TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // sameAddress
                    //     ? CustomButton(
                    //         text: "Next",
                    //         onTap: () {
                    //           saveAddress(address);
                    //         })
                    //     : const SizedBox(),
                    const SizedBox(height: 20),
                    const Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text("Add a new Address"),
                  ),
                ],
              ),
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: flatBuildingController,
                      hintText: 'Flat, House no, Building',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: areaController,
                      hintText: 'Area, Street',
                      labelText: "Area, Street", // Provide a descriptive label
                      semanticLabel:
                          "Area, Street Input Field", // Provide a brief description for accessibility
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: pincodeController,
                      hintText: 'Pincode',
                      labelText: "Pincode", // Provide a descriptive label
                      semanticLabel:
                          "Pincode Input Field", // Provide a brief description for accessibility
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: cityController,
                      hintText: 'Town/City',
                      labelText: "Town/City", // Provide a descriptive label
                      semanticLabel:
                          "Town/City Input Field", // Provide a brief description for accessibility
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                tileColor: Theme.of(context).primaryColorDark,
                title: const Text(
                  'Cash On Delivery',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value: "CashOnDelivery", // Value for this radio button
                  groupValue: payment, // Current selected value in the group
                  onChanged: _handleRadioValueChange, // Callback function
                ),
              ),
              const SizedBox(height: 10),
              CustomButton(
                onTap: () => {
                  if (cart.isNotEmpty)
                    {
                      saveAddress(address),
                      // cashOnDelivery(address),
                    }
                  else
                    {
                      {showSnackBar(context, 'Select Product!')},
                    }
                },
                text: "Next",
                // color: GlobalVariables.customCyan,
              )
            ],
          ),
        ),
      ),
    );
  }
}
