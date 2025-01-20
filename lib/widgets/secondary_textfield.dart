import 'package:flutter/material.dart';
import 'package:todoapp/constants/borders.dart';

class SecondaryTextfield extends StatefulWidget {
  final TextEditingController controller;
  final void Function()? onEditingComplete;
  const SecondaryTextfield(
      {super.key, required this.controller, this.onEditingComplete});

  @override
  State<SecondaryTextfield> createState() => _SecondaryTextfieldState();
}

class _SecondaryTextfieldState extends State<SecondaryTextfield> {
  bool readOnly = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onEditingComplete: widget.onEditingComplete,
      controller: widget.controller,
      readOnly: readOnly,
      decoration: InputDecoration(
          border: AppBorders.secondaryBorder,
          enabledBorder: AppBorders.secondaryBorder,
          focusedBorder: AppBorders.secondaryBorder,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                readOnly = false;
              });
            },
            child: const Icon(
              Icons.edit_note,
              color: Color(0XFF757575),
            ),
          )),
    );
  }
}
