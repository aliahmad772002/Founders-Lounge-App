// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../components/custom_button.dart';
// import '../../components/custom_text_field.dart';
// import '../../constants/colors.dart';
// import '../Login Screen/login_in.dart';
// import 'otp_code.dart';
//
// class ForgetPassword extends StatefulWidget {
//   const ForgetPassword({Key? key}) : super(key: key);
//
//   @override
//   State<ForgetPassword> createState() => _ForgetPasswordState();
// }
//
// class _ForgetPasswordState extends State<ForgetPassword> {
//   late FocusNode emailFocusNode;
//
//   @override
//   void initState() {
//     super.initState();
//     emailFocusNode = FocusNode();
//   }
//
//   @override
//   void dispose() {
//     emailFocusNode.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController forgetPasswordController = TextEditingController();
//     return GestureDetector(
//       onTap: () {
//         if (emailFocusNode.hasFocus) {
//           emailFocusNode.unfocus();
//         }
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 const Center(
//                   child: Padding(
//                     padding: EdgeInsets.only(top: 10, bottom: 100),
//                       child: SizedBox(
//                         width: 300,
//                         height: 300,
//                         child: Center(child: Text('Logo Placeholder'),),
//                       )
//                     // child: Lottie.asset("assets/animations/quotes.json"),
//                   ),
//                 ),
//                 CustomTextField(
//                   controller: forgetPasswordController,
//                   txt: "Email",
//                   hidePassword: false,
//                   keyboardType: TextInputType.emailAddress,
//                   unFocusedIcon: const Icon(CupertinoIcons.mail),
//                   focusedIconText: "@",
//                   focusedIcon: const Icon(CupertinoIcons.mail),
//                   focusNode: emailFocusNode,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 20, bottom: 20),
//                   child: CustomButton(
//                     onPress: () async {
//
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Code sent to your email!'),
//                           duration: Duration(seconds: 2),
//                         ),
//                       );
//                       await Future.delayed(const Duration(seconds: 2));
//                       Get.to(() => const OtpCode());
//
//
//                       var forgetEmail = forgetPasswordController.text.trim();
//
//                       try {
//                         await FirebaseAuth.instance.sendPasswordResetEmail(email: forgetEmail).then((value) =>
//                         {
//                           print("Email Sent!"),
//                           Get.off(()=> const LoginIn()),
//                         });
//                       } on FirebaseAuthException catch (e) {
//                         print("Error $e");
//                       }
//                     },
//                     txt: "Forget Password",
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget text(
//       {required String txt,
//       required double fontSize,
//       FontWeight fontWeight = FontWeight.w500,
//       required TextDecoration textDecoration}) {
//     return Padding(
//       padding: const EdgeInsets.all(10),
//       child: Text(
//         txt,
//         style: TextStyle(
//           color: textColor,
//           fontSize: fontSize,
//           fontWeight: fontWeight,
//           decoration: textDecoration,
//         ),
//       ),
//     );
//   }
// }
