import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoWithName extends StatelessWidget {
  final double fontSize;
  final double iconSize;

  const LogoWithName({
    super.key,
    required this.iconSize,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: iconSize,
          ),
          const SizedBox(
            width: 14,
          ),
          Text(
            'OrganizeIt',
            style: GoogleFonts.inter(
              textStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600, //Semi Bold
              ),
            ),
          ),
        ],
      ),
    );
  }
}
