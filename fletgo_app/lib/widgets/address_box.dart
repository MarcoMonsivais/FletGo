import 'package:fletgo_user_app/utils/brand.dart';
import 'package:flutter/material.dart';

class AddressBox extends StatelessWidget {
  AddressBox(this.innerText);

  final String innerText;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(fletgoPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.all(Radius.circular(25.0)),
        ),
        child: Text(
          this.innerText,
          style: TextStyle(
            fontFamily: fletgoFontFamily,
            color: Colors.black87,
            fontSize: 16,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
