import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MyTextField extends StatelessWidget {
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String hintText, labeltext;
  final bool obscureText;
  final String? Function(String?)? validator; // Custom validator function

  const MyTextField({
    super.key,
    this.controller,
    required this.hintText,
    required this.labeltext,
    required this.obscureText,
    this.validator,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labeltext,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 15.sp),
          ),
          ClipRect(
            child: TextFormField(
              keyboardType: keyboardType,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              controller: controller,
              obscureText: obscureText,
              validator: validator,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(width: 0.2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                fillColor: Colors.transparent.withOpacity(0.1),
                filled: true,
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
