import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/borders.dart';

class DateTimeTextField extends StatefulWidget {
  final TextEditingController controller;
  final void Function()? onTap;
  final IconData icon;
  final String? hintText;

  const DateTimeTextField({
    super.key,
    required this.controller,
    required this.onTap,
    required this.icon,
    this.hintText,
  });

  @override
  State<DateTimeTextField> createState() => _DateTimeTextFieldState();
}

class _DateTimeTextFieldState extends State<DateTimeTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: GoogleFonts.inter(
          color: const Color(0XFF757575),
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.italic,
        ),
        suffixIcon: GestureDetector(
          onTap: widget.onTap,
          child: Icon(
            widget.icon,
            color: const Color(0XFF9747FF),
          ),
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
