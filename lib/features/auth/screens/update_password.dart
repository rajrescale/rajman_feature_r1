import 'package:dalvi/common/widgets/custom_button.dart';
import 'package:dalvi/common/widgets/custom_textfield.dart';

import 'package:dalvi/constants/utils.dart';
import 'package:dalvi/features/auth/screens/signin.dart';
import 'package:dalvi/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';

class UpdatePassword extends StatefulWidget {
  static const String routeName = '/updatepassword';
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confnewPasswordController =
      TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKeyEmail =
      GlobalKey<FormState>(); // Corrected typo
  final GlobalKey<FormState> _formKeyPass = GlobalKey<FormState>();

  String otp = "";
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _newPasswordController.dispose();
    _confnewPasswordController.dispose();
    _otpController.dispose();
  }

  void getOtp() {
    authService.getEmailResetPassword(
      email: _emailController.text, // Use email entered by the user
      context: context,
    );
  }

  void updatePassword() {
    authService
        .getUserDetails(
      otp: _otpController.text,
      context: context,
      newpass: _newPasswordController.text,
      confnewpass: _confnewPasswordController.text,
    )
        .then((value) {
      if (value == "Password reset successfully!") {
        showSnackBar(
          context,
          'Password Updated Successfully!',
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          SignInScreen.routeName,
          (route) => false,
        );
      }
    }).catchError((error) {
      // Handle any errors that occurred during the getUserDetails() call
      showSnackBar(context, error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Update Your Password',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: _formKeyEmail,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: _emailController,
                              hintText: "Email",
                              labelText: "Email", // Provide a descriptive label
                              semanticLabel:
                                  "Email Input Field", // Provide a brief description for accessibility
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 200,
                              child: CustomButton(
                                text: 'Get otp',
                                onTap: () {
                                  if (_formKeyEmail.currentState!.validate()) {
                                    getOtp();
                                  }
                                },
                                // color: GlobalVariables.customCyan,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Form(
                        key: _formKeyPass,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: _otpController,
                              hintText: "OTP",
                              labelText: "OTP", // Provide a descriptive label
                              semanticLabel:
                                  "OTP Input Field", // Provide a brief description for accessibility
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextField(
                              controller: _newPasswordController,
                              hintText: "New Password",
                              labelText:
                                  "New Password", // Provide a descriptive label
                              semanticLabel:
                                  "New Password Input Field", // Provide a brief description for accessibility
                              obscureText: true,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextField(
                              controller: _confnewPasswordController,
                              hintText: "Confirm New Password",
                              labelText:
                                  "Confirm New Password", // Provide a descriptive label
                              semanticLabel: "Confirm New Password Input Field",
                              obscureText: true,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 200,
                              child: CustomButton(
                                text: 'Update Password',
                                onTap: () {
                                  if (_formKeyPass.currentState!.validate()) {
                                    updatePassword();
                                  }
                                },
                                // color: GlobalVariables.customCyan,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Password updated? ",
                                ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, SignInScreen.routeName);
                                    },
                                    child: Text(
                                      "Sign in",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .primaryColor, // Use primary color
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
