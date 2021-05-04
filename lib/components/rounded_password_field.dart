import 'package:flutter/material.dart';
import 'package:dezon/components/text_field_container.dart';
import 'package:dezon/constants.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          hintText: "Mot de passe",
          icon: Icon(
            Icons.lock,
            color: kSecondaryColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: kSecondaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}