import 'package:flutter/material.dart';
import 'package:dezon/constants.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        border: Border.all(
                    color: kSecondaryColor,
                    style: BorderStyle.solid,
                    width: 1.0,
                ),
        color: Colors.white, 
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}