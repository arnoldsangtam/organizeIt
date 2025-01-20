import 'package:flutter/material.dart';

class CustomIcons extends StatelessWidget {
  final IconData icon;
  const CustomIcons({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: const Color(0XFF757575),
      fill: 0,
      weight: 100,
      opticalSize: 24,
      grade: 200,
    );
  }
}
