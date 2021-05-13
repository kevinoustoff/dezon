import 'package:flutter/material.dart';
import 'package:dezon/views/Login/components/background.dart';
import 'package:dezon/views/Signup/signup_screen.dart';
import 'package:dezon/components/already_have_an_account_acheck.dart';
import 'package:dezon/components/rounded_button.dart';
import 'package:dezon/components/rounded_input_field.dart';
import 'package:dezon/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dezon/states/AuthState.dart';
import 'package:provider/provider.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:dezon/resources/user_api_provider.dart';
import 'dart:developer' as developer;

class Body extends StatefulWidget{
  @override
  _BodyState createState() => _BodyState();
   Body({
      Key key,
      TextEditingController myController,
  }) : super(key: key);
}

class _BodyState extends State<Body> {
  String email;
  String password;
  bool showSpinner;
  
  
  @override
  Widget build(BuildContext context) {
    AuthState authState = Provider.of<AuthState>(context, listen: false);
     UserApiProvider provider = UserApiProvider(); 
    Size size = MediaQuery.of(context).size;
    return ProgressHUD(child:  Builder(
          builder: (context) =>  Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            /* SvgPicture.asset(
              "assets/images/dezon.svg",
              height: size.height * 0.35,
            ), */
            Image.asset(
              "assets/images/dezon.jpeg",
              width: size.width * 0.4,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "e-mail",
              onChanged: (value) {
                this.email = value; 
                
              },
            ),
            RoundedPasswordField(
              onChanged: (value) {
                this.password = value;
              },
            ),
            RoundedButton(
              text: "LOGIN",
              press: () async {
                setState(() {
                    showSpinner = true;
                  });
                  final progress = ProgressHUD.of(context);
                        progress?.show();
                print(this.email);
                print(this.password);

                 /* List response = await authState.signIn(email: this.email ,password:this.password); */
                /* print(response); */
                var answ;
                 provider.login(this.email, this.password).then((response){
                    var answ;
                    print(response);
                    setState(() {
                      answ = response;
                      progress.dismiss();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SignUpScreen();
                          },
                        ));
                    });
                 }); 
                 
                 /* var res;
                 setState(() {
                   res = response;
                   print(res);
                 }); */
                /* if(response[0])
                {
                  progress?.show();
                  setState(() {
                    showSpinner = false;
                  });
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  )); 
                } */  
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    )));
  
  }
}
