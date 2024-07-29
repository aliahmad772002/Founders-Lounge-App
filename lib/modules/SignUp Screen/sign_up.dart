import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fouders_longe/Controlllers/firebase_controller.dart';
import 'package:fouders_longe/components/custom_button.dart';
import 'package:fouders_longe/components/custom_text_field.dart';
import 'package:fouders_longe/constants/colors.dart';
import 'package:fouders_longe/modules/Bottom Navigation Bar Screen/bottom_navbar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../Login Screen/login_in.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final controller = Get.put(FirebaseController());

  final FocusNode userNameFocusNode = FocusNode();
  final FocusNode profesionFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode cnfpasswordFocusNode = FocusNode();

  // Image variables for profile picture.
  File? image;
  final picker = ImagePicker();

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
  }

  Future<bool> checkEmailExistence(String email) async {
    const apiKey = '80b8493e3d42bae9bf9a837e7e492ec4'; // Replace with your actual API key
    final endpoint = 'https://apilayer.com/api/check?access_key=$apiKey&email=$email';

    final response = await http.get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['format_valid'] && data['smtp_check'];
    } else {
      throw Exception('Failed to verify email existence');
    }
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        userNameFocusNode.unfocus();
        profesionFocusNode.unfocus();
        phoneFocusNode.unfocus();
        emailFocusNode.unfocus();
        passwordFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10,),
                    child: InkWell(
                      onTap: () async {
                        await pickImage();
                        setState(() {});
                      },
                      child: image != null
                          ? Container(
                              width: 150,
                              height: 150,
                              margin: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                image: DecorationImage(
                                  image: FileImage(image!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: color2,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: const Center(
                                child: Text(
                                  "Upload Image",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                CustomTextField(
                  // controller: FirebaseController.instance.nameController,
                  controller: controller.nameController,
                  txt: "User Name",
                  hidePassword: false,
                  keyboardType: TextInputType.name,
                  unFocusedIcon: const Icon(Icons.account_circle_outlined),
                  focusedIconText: "@",
                  focusedIconTextSize: 18,
                  padding: const EdgeInsets.only(top: 11, left: 15),
                  focusedIcon: const Icon(CupertinoIcons.eye),
                  focusNode: userNameFocusNode, // Assign userNameFocusNode
                ),
                CustomTextField(
                  // controller: FirebaseController.instance.nameController,
                  controller: controller.profesionController,
                  focusedIconText: "",
                  txt: "Profession",
                  hidePassword: false,
                  keyboardType: TextInputType.text,
                  unFocusedIcon: const Icon(Icons.work),

                  focusedIconTextSize: 18,
                  padding: const EdgeInsets.only(top: 11, left: 15),
                  focusedIcon: const Icon(CupertinoIcons.eye),
                  focusNode: profesionFocusNode, // Assign userNameFocusNode
                ),
                CustomTextField(
                  // controller: FirebaseController.instance.phoneController,
                  controller: controller.phoneController,
                  txt: "Phone Number",
                  hidePassword: false,
                  keyboardType: TextInputType.phone,
                  unFocusedIcon: const Icon(CupertinoIcons.phone),
                  focusedIconText: "+92",
                  focusedIconTextSize: 15,
                  padding: const EdgeInsets.only(top: 14, left: 13),
                  focusedIcon: const Icon(CupertinoIcons.eye),
                  focusNode: phoneFocusNode, // Assign phoneFocusNode
                ),
                CustomTextField(
                  // controller: FirebaseController.instance.emailController,
                  controller: controller.emailController,
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
                CustomTextField(
                  // controller: FirebaseController.instance.cnfController,
                  controller: controller.cnfController,
                  padding: const EdgeInsets.only(top: 12, left: 13),
                  focusedIconTextSize: 18,
                  fontWeight: FontWeight.w400,
                  txt: "Confirm Password",
                  hidePassword: true,
                  keyboardType: TextInputType.visiblePassword,
                  unFocusedIcon: const Icon(Icons.password_rounded),
                  focusedIconText: "",
                  focusedIcon: const Icon(CupertinoIcons.eye),
                  focusNode: cnfpasswordFocusNode,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: CustomButton(
                    backgroundColor: Colors.amber,

                    onPress: () {
                      if (controller.nameController.text.isEmpty) {
                        _showSnackBar(context, "Please enter your name");
                      } else if (controller.profesionController.text.isEmpty) {
                        _showSnackBar(context, "Please enter your profession");
                      } else if (controller.phoneController.text.isEmpty) {
                        _showSnackBar(context, "Please enter your phone number");
                      } else if (controller.emailController.text.isEmpty) {
                        _showSnackBar(context, "Please enter your email");
                      } else if (controller.passwordController.text.isEmpty) {
                        _showSnackBar(context, "Please enter your password");
                      } else if (controller.cnfController.text.isEmpty) {
                        _showSnackBar(context, "Please enter your confirm password");
                      } else if (controller.passwordController.text != controller.cnfController.text) {
                        _showSnackBar(context, "Password and Confirm Password must be same");
                      } else if (controller.passwordController.text.length < 6) {
                        _showSnackBar(context, "Password must be at least 6 characters");
                      } else if (image == null) {
                        _showSnackBar(context, "Please select an image");
                      } else if (checkEmailExistence(controller.emailController.text) == false) {
                        _showSnackBar(context, "Please enter a valid email");
                      } else {
                        controller.signUp(
                          image: image!,
                        );
                      }
                    },
                    txt: "SignUp",
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.off(
                      const LoginIn(),
                      transition: Transition.leftToRight,
                    );
                  },
                  style: TextButton.styleFrom(
                    elevation: 0,
                  ),
                  child: text(
                    txt: "Already have Account?",
                    fontSize: 15,
                    textDecoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget text({
    required String txt,
    required double fontSize,
    FontWeight fontWeight = FontWeight.w500,
    required TextDecoration textDecoration,
  }) {
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
