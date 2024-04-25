import 'package:dalvi/constants/utils.dart';
import 'package:dalvi/features/auth/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dalvi/features/auth/screens/register.dart';
import 'package:telephony/telephony.dart';

class PhoneValidation extends StatefulWidget {
  static const String routeName = '/phonevalidation';
  const PhoneValidation({super.key});

  @override
  State<PhoneValidation> createState() => _PhoneValidationState();
}

class _PhoneValidationState extends State<PhoneValidation> {
  final _otpFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();
  String str = "";
  bool canShow = false;
  bool allreadyAccount = false;
  bool reSend = false;
  bool showOtp = false;
  late ConfirmationResult confirmationResult;
  late ConfirmationResult temp;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final Telephony telephony = Telephony.instance;

  Future<ConfirmationResult> sendOTPWeb(String phoneNumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber(
      '+91 $phoneNumber',
    );
    printMessage("OTP Sent to +91 $phoneNumber");
    return confirmationResult;
  }

  Future<bool> authenticateMe(
    ConfirmationResult confirmationResult,
    String otp,
    BuildContext context, // Pass the context to showSnackBar
  ) async {
    try {
      await confirmationResult.confirm(otp);
      return true;
    } catch (e) {
      setState(() {
        reSend = !reSend;
      });
      showSnackBar(context, "Error: Invalid OTP"); // Show error message
      return false; // Return false to indicate authentication failure
    }
  }

  void printMessage(String msg) {
    debugPrint(msg);
  }

  Future<ConfirmationResult> sentOtpFromWeb(
      BuildContext context, String text) async {
    temp = await sendOTPWeb(_phoneController.text);
    setState(() {
      canShow = !canShow;
    });
    if (temp.verificationId.isNotEmpty) {
      confirmationResult = temp;
      return temp;
    }
    return temp;
  }

  void handleSubmitOnWeb(ConfirmationResult temp, BuildContext context) async {
    bool isAuthenticated =
        await authenticateMe(temp, _otpController.text, context);
    if (isAuthenticated) {
      // Navigator.pop(context);
      Navigator.pushNamed(
        context,
        SignUpScreen.routeName,
        arguments: _phoneController.text,
      );
      // const SignUpScreen();
    }
  }

  void listenToIncomingSMS(BuildContext context) {
    telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          if (message.body!.contains("phone-auth-15bdb")) {
            String otpCode = message.body!.substring(0, 6);
            setState(
              () {
                _otpController.text = otpCode;
                // wait for 1 sec and then press handle submit
                Future.delayed(const Duration(seconds: 1), () {
                  handleSubmitOnPhone(context);
                });
              },
            );
          }
        },
        listenInBackground: false);
  }

  // handle after otp is submitted
  Future<void> handleSubmitOnPhone(BuildContext context) async {
    AuthService.verifyOtp(otp: _otpController.text).then(
      (value) {
        if (value == "Success") {
          str = value;
          // Navigator.pop(context);
          // signUpUser();
          Navigator.pushNamed(context, SignUpScreen.routeName,
              arguments: _phoneController.text);
        } else {
          setState(() {
            reSend = !reSend;
          });
          showSnackBar(context, value);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Form(
                key: _phoneFormKey,
                child: Semantics(
                  label: 'Phone',
                  hint: 'Enter your Phone',
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: '+91',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value!.length != 10) {
                        return "Invalid Number";
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_phoneFormKey.currentState!.validate() && !kIsWeb) {
                      AuthService.sentOtp(
                        phone: _phoneController.text,
                        errorStep: () =>
                            showSnackBar(context, "Error in sending OTP"),
                        nextStep: () {
                          setState(() {
                            showOtp = !showOtp;
                          });
                        },
                      );
                    } else if (_phoneFormKey.currentState!.validate() &&
                        kIsWeb) {
                      sentOtpFromWeb(context, _phoneController.text)
                          .then((value) => {
                                setState(() {
                                  showOtp = !showOtp;
                                })
                              });
                    }
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  child: const Text('Get OTP'),
                ),
              ),
            ),
            const SizedBox(height: 40),
            showOtp
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Form(
                          key: _otpFormKey,
                          child: Semantics(
                            label: 'OTP',
                            hint: 'Enter your OTP',
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _otpController,
                              decoration: InputDecoration(
                                labelText: 'OTP',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) {
                                if (value!.length != 6) {
                                  return "Invalid OTP";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_otpFormKey.currentState!.validate() &&
                                  !kIsWeb) {
                                handleSubmitOnPhone(context);
                              } else if (_otpFormKey.currentState!.validate() &&
                                  kIsWeb) {
                                handleSubmitOnWeb(confirmationResult, context);
                              }
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8)))),
                            child: const Text('Verify OTP'),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
