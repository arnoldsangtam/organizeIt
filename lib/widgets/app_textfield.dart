import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/borders.dart';

class AppTextfield extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;

  const AppTextfield(
      {super.key, required this.hintText, required this.controller});

  @override
  State<AppTextfield> createState() => _AppTextfieldState();
}

class _AppTextfieldState extends State<AppTextfield> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: GoogleFonts.inter(
          color: const Color(0XFF757575),
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.italic,
        ),
        fillColor: const Color.fromRGBO(255, 255, 255, 0.5),
        filled: true,
        border: AppBorders.transparentBorder,
        enabledBorder: AppBorders.transparentBorder,
        focusedBorder: AppBorders.transparentBorder,
        errorBorder: AppBorders.transparentBorder,
      ),
    );
  }
}
