import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 7.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(labeltext,
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp),
              )),
          ClipRect(
            child: TextFormField(
              keyboardType: keyboardType,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontSize: 18),
              controller: controller,
              obscureText: obscureText,
              validator: validator,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    width: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(width: 0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                fillColor: Colors.transparent.withOpacity(0.1),
                filled: true,
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: 17,
                  color: Theme.of(context)
                      .colorScheme
                      .onSecondaryFixedVariant
                      .withAlpha(100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
