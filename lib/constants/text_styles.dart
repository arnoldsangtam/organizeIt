import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextStyles {
  static final TextStyle categoryStyle = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );
  static final TextStyle titleStyle = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );
  static final TextStyle smallStyle = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  static final TextStyle fieldTitleStyle = GoogleFonts.inter(
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle alertTitle = GoogleFonts.inter(
    color: const Color(0XFF757575),
    fontWeight: FontWeight.w300,
  );

  static final TextStyle alertButton = GoogleFonts.roboto(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}
