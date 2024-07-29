import 'package:flutter/material.dart';

import '../constants/colors.dart';


class CustomButton extends StatelessWidget {
  final VoidCallback onPress;
  final Color backgroundColor;
  final String txt;
  final double fontSize;
  final FontWeight fontWeight;
  const CustomButton(
      {super.key,
      required this.onPress,
      this.backgroundColor = Colors.white,
      required this.txt,
      this.fontSize = 18,
      this.fontWeight = FontWeight.w400});

  @override
  Widget build(BuildContext context) {
    // For Login Button
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // boxShadow: [
          //   const BoxShadow(
          //     color: color2,
          //     spreadRadius: 0.1,
          //     blurRadius: 10,
          //     // offset: Offset(8, 8),
          //   ),
          // ],
        ),
        child: ElevatedButton(
          onPressed: onPress,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: color2,
            minimumSize: const Size(120, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            txt,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
