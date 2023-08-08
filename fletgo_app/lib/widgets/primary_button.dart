import 'package:fletgo_user_app/utils/brand.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  PrimaryButton({
    this.key,
    @required this.text,
    @required this.height,
    this.width,
    @required this.onPressed,
  }) : super(key: key);

  final Key key;
  final String text;
  final double height;
  final double width;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width, //TODO:
      height: height,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(fletgoBorderRadius)),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: fletgoFontFamily,
            letterSpacing: 1.25,
          ),
        ),
        color: Color(0xffc62828),
        elevation: fletgoElevation,
        splashColor: Colors.blueGrey,
        onPressed: onPressed,
      ),
    );
  }
}
