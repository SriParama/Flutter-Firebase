import 'package:emailfirebase/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyTextField extends StatelessWidget {
  final dynamic controller;
  final String hintText;
  final bool obscureText;
  var ontab;
  Widget? sufficsIcons;
  Widget? prefficsIcons;
  bool? keyboard;

  MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      this.ontab,
      this.keyboard,
      this.sufficsIcons,
      this.prefficsIcons});

  formvalidator(value) {
    if (value.isEmpty) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        readOnly: keyboard ?? false,
        controller: controller,
        obscureText: obscureText,
        keyboardType:
            keyboard == true ? TextInputType.none : TextInputType.text,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => formvalidator(value),
        onTap: ontab ??
            () {
              print('hji');
            },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15),
            isDense: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              borderSide:
                  BorderSide(color: Color.fromARGB(255, 219, 25, 41), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            fillColor: Colors.white,
            suffixIcon: sufficsIcons,
            prefixIcon: prefficsIcons,
            errorStyle: TextStyle(height: 0),
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500])),
      ),
    );
  }
}
