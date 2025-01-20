import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryButton extends StatelessWidget {
  final String buttonText;
  final Color? color;
  final Color? textColor;
  final void Function()? onPressed;

  const CategoryButton(
      {super.key,
      required this.buttonText,
      this.onPressed,
      this.color,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? const Color(0XFFe0c8ff),
      ),
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: GoogleFonts.inter(
          color: textColor ?? Colors.black,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
