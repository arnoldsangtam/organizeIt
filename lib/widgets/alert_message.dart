import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertMessage extends StatelessWidget {
  final String message;
  final String buttonText;
  final void Function()? onPressed;

  const AlertMessage(
      {super.key,
      required this.buttonText,
      required this.onPressed,
      required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        message,
        style: GoogleFonts.inter(
          color: const Color(0XFF757575),
          fontWeight: FontWeight.w300,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: GoogleFonts.roboto(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }
}
