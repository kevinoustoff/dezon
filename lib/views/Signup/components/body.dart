import 'package:flutter/material.dart';
import 'package:dezon/views/Login/login_screen.dart';
import 'package:dezon/views/Signup/components/background.dart';
import 'package:dezon/views/Signup/components/or_divider.dart';
import 'package:dezon/views/Signup/components/social_icon.dart';
import 'package:dezon/components/already_have_an_account_acheck.dart';
import 'package:dezon/components/rounded_button.dart';
import 'package:dezon/components/rounded_input_field.dart';
import 'package:dezon/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            Image.asset(
              "assets/images/dezon.jpeg",
              width: size.width * 0.4,
            ),
            RoundedInputField(
              hintText: "Nom",
              onChanged: (value) {},
            ),
            RoundedInputField(
              hintText: "Nom d'utilisateur",
              icon: Icons.mail,
              onChanged: (value) {},
            ),
            
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {},
              icon: Icons.mail
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () {},
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocalIcon(
                  iconSrc: "assets/icons/facebook.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/twitter.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
