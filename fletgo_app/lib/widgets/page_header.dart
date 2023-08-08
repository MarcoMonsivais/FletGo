import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {

  final String text;

  PageHeader({
    @required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Text( this.text,
      style: TextStyle(
        color: Colors.red,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        
      ),
    );
  }

}