import 'package:flutter/material.dart';

class DefaultTextField extends StatelessWidget {
  DefaultTextField({
    this.key,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.icon,
    this.maxLines = 1
  }) : super (key: key);

  final Key key;
  final String labelText;
  final String hintText;
  final Icon prefixIcon;
  final TextEditingController controller;
  final bool obscureText;
  final validator;
  final Icon icon;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: Theme.of(context).accentColor),
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: obscureText,
        maxLines: maxLines,
        decoration: InputDecoration(
          icon: icon,
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(8.0)
            )
          ),
        ),
      ),
    );
  }

}