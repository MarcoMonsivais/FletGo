import 'package:flutter/material.dart';

class RightMapOptions extends StatefulWidget {
  final IconData icon;
  final Function onTap;

  RightMapOptions({ this.icon, this.onTap, Key key}) : super(key: key);
  @override
  _RightMapOptionsState createState() => _RightMapOptionsState();
}

class _RightMapOptionsState extends State<RightMapOptions> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.red,
        ),
        padding: EdgeInsets.all(8),
        child: Icon(widget.icon),
      ),
    );
  }
}
