import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fouders_longe/Controlllers/firebase_controller.dart';
import 'package:fouders_longe/components/custom_button.dart';
import 'package:fouders_longe/components/custom_text_field.dart';
import 'package:fouders_longe/constants/colors.dart';
import 'package:fouders_longe/modules/Bottom Navigation Bar Screen/bottom_navbar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileScreen extends StatefulWidget {
  final String profileImage;
  final String name;
  final String profession;
  final String phone;

  const UpdateProfileScreen({
    Key? key,
    required this.profileImage,
    required this.name,
    required this.profession,
    required this.phone,
  }) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final controller = Get.put(FirebaseController());

  final FocusNode userNameFocusNode = FocusNode();
  final FocusNode professionFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  // final FocusNode passwordFocusNode = FocusNode();
  // final FocusNode cnfpasswordFocusNode = FocusNode();

  File? image;
  final picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
  }

  @override
  void initState() {
    super.initState();
    controller.nameController.text = widget.name;
    controller.profesionController.text = widget.profession;
    controller.phoneController.text = widget.phone;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Unfocus all text fields when tapping outside
        userNameFocusNode.unfocus();
        professionFocusNode.unfocus();
        phoneFocusNode.unfocus();
        emailFocusNode.unfocus();
        // passwordFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: InkWell(
                      onTap: () async {
                        await pickImage();
                        setState(() {});
                      },
                      child: Container(
                        width: 250,
                        height: 250,
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: color2,
                          borderRadius: BorderRadius.circular(40),
                          image: DecorationImage(
                            // Use selected image if available, else use profileImage
                            image: image != null
                                ? FileImage(image!) as ImageProvider
                                : NetworkImage(widget.profileImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                CustomTextField(
                  controller: controller.nameController,
                  txt: "User Name",
                  hidePassword: false,
                  keyboardType: TextInputType.name,
                  unFocusedIcon: const Icon(Icons.account_circle_outlined),
                  focusedIconText: "@",
                  focusedIconTextSize: 18,
                  padding: const EdgeInsets.only(top: 11, left: 15),
                  focusedIcon: const Icon(Icons.visibility),
                  focusNode: userNameFocusNode,
                ),
                CustomTextField(
                  controller: controller.profesionController,
                  focusedIconText: "",
                  txt: "Profession",
                  hidePassword: false,
                  keyboardType: TextInputType.text,
                  unFocusedIcon: const Icon(Icons.work),
                  focusedIconTextSize: 18,
                  padding: const EdgeInsets.only(top: 11, left: 15),
                  focusedIcon: const Icon(Icons.visibility),
                  focusNode: professionFocusNode,
                ),
                CustomTextField(
                  controller: controller.phoneController,
                  txt: "Phone Number",
                  hidePassword: false,
                  keyboardType: TextInputType.phone,
                  unFocusedIcon: const Icon(Icons.phone),
                  focusedIconText: "+92",
                  focusedIconTextSize: 15,
                  padding: const EdgeInsets.only(top: 14, left: 13),
                  focusedIcon: const Icon(Icons.visibility),
                  focusNode: phoneFocusNode,
                ),
                // CustomTextField(
                //   controller: controller.emailController,
                //   txt: "Email",
                //   hidePassword: false,
                //   keyboardType: TextInputType.emailAddress,
                //   unFocusedIcon: const Icon(Icons.mail),
                //   focusedIconText: "@",
                //   focusedIcon: const Icon(Icons.mail),
                //   focusNode: emailFocusNode,
                // ),
                // CustomTextField(
                //   controller: controller.passwordController,
                //   padding: const EdgeInsets.only(top: 12, left: 13),
                //   focusedIconTextSize: 18,
                //   fontWeight: FontWeight.w400,
                //   txt: "Password",
                //   hidePassword: true,
                //   keyboardType: TextInputType.visiblePassword,
                //   unFocusedIcon: const Icon(Icons.password_rounded),
                //   focusedIconText: "",
                //   focusedIcon: const Icon(Icons.visibility),
                //   focusNode: passwordFocusNode,
                // ),
                // CustomTextField(
                //   controller: controller.cnfController,
                //   padding: const EdgeInsets.only(top: 12, left: 13),
                //   focusedIconTextSize: 18,
                //   fontWeight: FontWeight.w400,
                //   txt: "Confirm Password",
                //   hidePassword: true,
                //   keyboardType: TextInputType.visiblePassword,
                //   unFocusedIcon: const Icon(Icons.password_rounded),
                //   focusedIconText: "",
                //   focusedIcon: const Icon(Icons.visibility),
                //   focusNode: cnfpasswordFocusNode,
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: CustomButton(
                    backgroundColor: Colors.amber,
                    onPress: () {
                      controller.updateUserData(
                        image: image,
                      );
                    },
                    txt: "Update Profile",
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.off(
                      const BottomNavBarScreen(),
                      transition: Transition.leftToRight,
                    );
                  },
                  style: TextButton.styleFrom(
                    elevation: 0,
                  ),
                  child: const Text(
                    "Back to Home",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
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
