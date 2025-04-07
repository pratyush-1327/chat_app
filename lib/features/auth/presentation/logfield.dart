import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MyTextField extends StatelessWidget {
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String hintText, labeltext;
  final bool obscureText;
  final String? Function(String?)? validator;

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
      padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 7.sp),
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
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 17.sp),
              controller: controller,
              obscureText: obscureText,
              validator: validator,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.w),
                  borderSide: BorderSide(
                    width: 0.5.w,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 0.1.w),
                  borderRadius: BorderRadius.circular(4.w),
                ),
                fillColor:
                    Theme.of(context).colorScheme.surface.withOpacity(0.1),
                filled: true,
                hintText: hintText,
                hintStyle: TextStyle(
                  fontSize: 16.sp,
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
