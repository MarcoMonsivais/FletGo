import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  SecondaryButton({
    this.key,
    @required this.text,
    @required this.height,
    @required this.width,
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
      child: OutlineButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0)
        ),
        borderSide: BorderSide(
          color: Color(0xffc62828), //Color of the border
          style: BorderStyle.solid, //Style of the border
          width: 2.0, //width of the border
        ),
        child: Text(text,
          style: TextStyle(
            color: Color(0xffc62828),
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            letterSpacing: 1.25,
          ),
        ),
        color: Colors.white,
        splashColor: Colors.red[100],
        onPressed: onPressed,
      ),
    );
  }
}