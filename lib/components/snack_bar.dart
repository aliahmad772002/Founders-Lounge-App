import 'dart:ui';

import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    double sigmaX = 10.0,
    double sigmaY = 10.0,
    double opacity = 0.7,
    Color textColor = Colors.white,
    double fontSize = 16.0,
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
    double borderRadius = 10.0,
    SnackBarAction? action,
  }) {
    final snackBar = SnackBar(
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.black.withOpacity(opacity),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
          child: Padding(
            padding: padding,
            child: Text(
              message,
              style: TextStyle(fontSize: fontSize, color: textColor),
            ),
          ),
        ),
      ),
      duration: duration,
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.zero,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      action: action,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
