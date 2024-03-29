import 'package:dalvi/common/widgets/custom_button.dart';
import 'package:dalvi/common/widgets/custom_textfield.dart';
import 'package:dalvi/constants/global_variables.dart';
import 'package:dalvi/features/address/services/address_services.dart';
import 'package:dalvi/features/thankyou/thankyou.dart';
import 'package:dalvi/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dalvi/constants/utils.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;
  const AddressScreen({
    Key? key,
    required this.totalAmount,
  }) : super(key: key);

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
  final AddressServices addressServices = AddressServices();

  String? payment =
      "CashOnDelivery"; // Initial value for the radio button group

// Function to handle radio button changes
  void _handleRadioValueChange(String? value) {
    setState(() {
      payment = value; // Update the selected value
    });
  }

  void navigateToThankYouPage() {
    Navigator.pushNamed(context, ThankYouPage.routeName);
  }

  void cashOnDelivery(address) async {
    if ((Provider.of<UserProvider>(context, listen: false).user.address !=
            addressToBeUsed) ||
        (Provider.of<UserProvider>(context, listen: false)
            .user
            .address
            .isEmpty)) {
      addressServices.saveUserAddress(
          context: context, address: addressToBeUsed);
    }
    if (addressToBeUsed.isNotEmpty ||
        Provider.of<UserProvider>(context, listen: false)
            .user
            .address
            .isNotEmpty) {
      addressServices
          .placeOrder(
        context: context,
        address: addressToBeUsed,
        totalSum: double.parse(widget.totalAmount),
      )
          .then((_) {
        navigateToThankYouPage();
      }).catchError((error) {
        showSnackBar(context, error);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
  }

  void payPressed(String addressFromProvider) {
    addressToBeUsed = "";

    bool isForm = flatBuildingController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        pincodeController.text.isNotEmpty ||
        cityController.text.isNotEmpty;

    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            '${flatBuildingController.text}, ${areaController.text}, ${cityController.text} - ${pincodeController.text}';
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please enter all the values!")));
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Address Required!")));
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
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
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
                          color: Colors.black12,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          address,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
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
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: pincodeController,
                      hintText: 'Pincode',
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: cityController,
                      hintText: 'Town/City',
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                tileColor: GlobalVariables.greyBackgroundCOlor,
                title: const Text(
                  'Cash On Delivery',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: Radio(
                  activeColor: GlobalVariables.secondaryColor,
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
                      payPressed(address),
                      cashOnDelivery(address),
                    }
                  else
                    {
                      {showSnackBar(context, 'Select Product!')},
                    }
                },
                text: "Place Order",
                color: GlobalVariables.customCyan,
              )
            ],
          ),
        ),
      ),
    );
  }
}
