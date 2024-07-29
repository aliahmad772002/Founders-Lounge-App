// import 'package:flutter/material.dart';
//
// class OtpCode extends StatefulWidget {
//   const OtpCode({super.key});
//
//   @override
//   State<OtpCode> createState() => _OtpCodeState();
// }
// final defaultPinTheme = PinTheme(
//   width: 56,
//   height: 56,
//   textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
//   decoration: BoxDecoration(
//     border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
//     borderRadius: BorderRadius.circular(20),
//   ),
// );
//
// final focusedPinTheme = defaultPinTheme.copyDecorationWith(
//   border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
//   borderRadius: BorderRadius.circular(8),
// );
//
// final submittedPinTheme = defaultPinTheme.copyWith(
//   decoration: defaultPinTheme.decoration?.copyWith(
//     color: const Color.fromRGBO(234, 239, 243, 1),
//   ),
// );
//
// class _OtpCodeState extends State<OtpCode> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(child: Column(children: [
//         Container(
//           height: 100,
//           width: 800,
//           color: Colors.amber,
//           child: Pinput(
//            length: 6,
//             showCursor: true,
//             onCompleted: (pin) => print(pin),
//             // hi hello
//
//           )
//         ),
//         ElevatedButton(onPressed: () {
//
//         }, child: const Text("Enter Pin"),),
//       ],)),
//     );
//   }
// }
