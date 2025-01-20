import 'package:flutter/material.dart';

class AppBorders {
  static final transparentBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(
      width: 1,
      color: Color.fromRGBO(117, 117, 117, 0.5),
    ),
  );

  static final secondaryBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        width: 1,
        color: Color(0XFF757575),
      ));
}
