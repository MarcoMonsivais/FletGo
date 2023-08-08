import 'package:flutter/material.dart';

class FloatSearchBar extends StatelessWidget {

  final Widget child;

  const FloatSearchBar({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: 64,
            minWidth: MediaQuery.of(context).size.width - 100,
            maxWidth: MediaQuery.of(context).size.width - 50),
        child: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Colors.grey[100],
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: Offset.fromDirection(90, 5))
              ]),
          child: Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: child
          ),
        ));
  }
}
