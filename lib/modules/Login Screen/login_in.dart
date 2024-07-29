import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fouders_longe/Controlllers/firebase_controller.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';
import '../../constants/colors.dart';
import '../Foreget Password/forget_password.dart';
import '../SignUp Screen/sign_up.dart';

class LoginIn extends StatefulWidget {
  final String email;
  final String password;
  const LoginIn({super.key, this.email = '', this.password = ''});

  @override
  State<LoginIn> createState() => _LoginInState();
}

class _LoginInState extends State<LoginIn> {
  final controller = Get.put(FirebaseController());
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;

  Future<String?> _checkEmailExistence(String email) async {
    // Replace with your server-side logic to check email existence
    // For example, using Firebase Authentication:
    try {
      await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return 'This email is already in use';
    } on FirebaseAuthException catch (e) {
      if (e.code != 'user-not-found') {
        return 'Error checking email: ${e.message}';
      }
    }
    return null; // Email does not exist
  }


  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.email);
    passwordController = TextEditingController(text: widget.password);
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {



    bool passwordVisible = true;
    void togglePasswordVisibility() {
      if (passwordVisible == true) {
        setState(() {
          passwordVisible = false;
        });
      } else {
        setState(() {
          passwordVisible = true;
        });
      }
    }

    return GestureDetector(
      onTap: () {
        if (emailFocusNode.hasFocus) {
          emailFocusNode.unfocus();
        }
        if (passwordFocusNode.hasFocus) {
          passwordFocusNode.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 40),
                      child: SizedBox(
                        width: 300,
                        height: 300,
                        child: Center(
                          child: Lottie.asset(
                            "assets/animations/Animation - 1704693578981.json",
                            fit: BoxFit.fill,
                            filterQuality: FilterQuality.medium,
                          ),
                        ),
                      )
                      // child: Lottie.asset("assets/animations/quotes.json"),
                      ),
                ),
                // const Spacer(),
                CustomTextField(
                  // controller: FirebaseController.instance.emailController,
                  controller: controller.emailController,
                  validator: (email) {
                    if (!EmailValidator.validate(email!)) {
                      return 'Please enter a valid email address';
                    }
                    // Check for email existence (optional)
                    return null;
                  },
                  txt: "Email",
                  hidePassword: false,
                  keyboardType: TextInputType.emailAddress,
                  unFocusedIcon: const Icon(CupertinoIcons.mail),
                  focusedIconText: "@",
                  focusedIcon: const Icon(CupertinoIcons.mail),
                  focusNode: emailFocusNode,
                ),
                CustomTextField(
                  // controller: FirebaseController.instance.passwordController,
                  controller: controller.passwordController,
                  padding: const EdgeInsets.only(top: 12, left: 13),
                  focusedIconTextSize: 18,
                  fontWeight: FontWeight.w400,
                  txt: "Password",
                  hidePassword: true,
                  keyboardType: TextInputType.visiblePassword,
                  unFocusedIcon: const Icon(Icons.password_rounded),
                  focusedIconText: "",
                  focusedIcon: const Icon(CupertinoIcons.eye),
                  focusNode: passwordFocusNode,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        onPress: () {
                          if (controller.emailController.text.isEmpty) {
                            showSnackBar(
                              "Error",
                              "Please enter your email",
                              Icons.error,
                              Colors.red,
                            );
                          } else if (controller.passwordController
                              .text.isEmpty) {
                            showSnackBar(
                              "Error",
                              "Please enter your password",
                              Icons.error,
                              Colors.red,
                            );
                          } else {
                            controller.signin();
                          }
                        },
                        txt: "Login",
                      ),
                      CustomButton(
                        onPress: () {
                          Get.to(
                            SignUp(),
                            transition: Transition.rightToLeft,
                          );
                        },
                        txt: "SignUp",
                      ),
                    ],
                  ),
                ),
                // TextButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const ForgetPassword(),
                //       ),
                //     );
                //   },
                //   style: TextButton.styleFrom(
                //     elevation: 0,
                //   ),
                //   child: text(
                //     txt: "Forget Password?",
                //     fontSize: 15,
                //     textDecoration: TextDecoration.underline,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(
      String title, String message, IconData icon, Color iconColor) {
    Get.snackbar(
      title,
      message,
      icon: Icon(icon, color: iconColor),
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.black,
      borderRadius: 10,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
    );
  }

  Widget text(
      {required String txt,
      required double fontSize,
      FontWeight fontWeight = FontWeight.w500,
      required TextDecoration textDecoration}) {
    return Text(
      txt,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: textDecoration,
      ),
    );
  }
}
