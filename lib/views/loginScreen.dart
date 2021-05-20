import 'package:dezon/views/homePage.dart';
import 'package:dezon/views/registerScreen.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 35),
              Text(
                "Connectez vous sur Dezon",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                "Connectez-vous pour utiliser votre tableau de bord, c'est rapide et gratuit. Présentez vos compétences, faîtes des demandes de services et bien plus encore.",
              ),
              SizedBox(height: 25),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Email",
                  prefixIcon: Icon(Icons.mail_outline_rounded),
                ),
              ),
              SizedBox(height: 37),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Mot de passe",
                  prefixIcon: Icon(Icons.security_rounded),
                ),
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(child: Text("Mot de passe oublié >")),
                ],
              ),
              SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      //style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xFF))),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      },
                      child: Text(
                        "Se connecter",
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterScreen(),
                    ),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: "Vous n'avez pas de compte?",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                    children: const <TextSpan>[
                      TextSpan(
                        text: " Inscrivez-vous ici",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
