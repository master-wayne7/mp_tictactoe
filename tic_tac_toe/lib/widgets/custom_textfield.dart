import 'package:flutter/material.dart';
import 'package:tic_tac_toe/utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isReadOnly;
  final String hintText;
  const CustomTextField({
    super.key,
    required this.controller,
    this.isReadOnly = false,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.blue,
            blurRadius: 5,
            spreadRadius: 2,
          )
        ],
      ),
      child: TextField(
        readOnly: isReadOnly,
        controller: controller,
        decoration: InputDecoration(
          fillColor: bgColor,
          filled: true,
          hintText: hintText,
        ),
      ),
    );
  }
}
