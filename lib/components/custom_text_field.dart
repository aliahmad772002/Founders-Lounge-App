import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String txt;
  final TextInputType keyboardType;
  final bool hidePassword;
  final Icon unFocusedIcon;
  final String? focusedIconText;
  final Color? focusedIconTextColor;
  final double focusedIconTextSize;
  final EdgeInsetsGeometry padding;
  final FontWeight fontWeight;
  final Icon? focusedIcon; // Make focusedIcon optional
  final FocusNode focusNode; // Accept a FocusNode as a parameter
  // validator
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.txt,
    required this.unFocusedIcon,
    this.focusedIconText,
    this.focusedIconTextSize = 22,
    this.focusedIcon,
    required this.focusNode,
    required this.keyboardType,
    required this.hidePassword,
    this.padding = const EdgeInsets.only(left: 17, top: 10),
    this.fontWeight = FontWeight.w500,
    this.focusedIconTextColor,
    this.validator,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  BorderSide _borderSide = BorderSide.none;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _borderSide =
          widget.focusNode.hasFocus ? const BorderSide() : BorderSide.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: color2.withOpacity(0.2),
            spreadRadius: 0.1,
            blurRadius: 10,
            // offset: Offset(8, 8),
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        keyboardType: widget.keyboardType,
        obscureText: widget.hidePassword,
        validator: widget.validator,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: widget.txt, // Use widget.txt to access the txt property
          prefixIcon: widget.focusNode.hasFocus
              ? Padding(
                  padding: widget.padding,
                  child: Text(
                    widget.focusedIconText!,
                    style: TextStyle(
                      color: widget.focusedIconTextColor ?? Colors.black,
                      fontSize: widget.focusedIconTextSize,
                      fontWeight: widget.fontWeight,
                    ),
                  ),
                )
              : widget.unFocusedIcon,
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            borderSide: _borderSide,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: color2, width: 2),
          ),
        ),
      ),
    );
  }
}
