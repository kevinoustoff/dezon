import 'package:flutter/material.dart';

import '../constants.dart';
import 'homePage.dart';
import 'loginScreen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                "S'inscrire chez Dezon",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                "Créez un nouveau compte avec nous et commencez à utiliser la plateforme la plus fiable pour embaucher des perstataires et fournir des services.",
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
                  hintText: "Nom",
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Identifiant",
                  prefixIcon: Icon(Icons.security_rounded),
                ),
              ),
              SizedBox(height: 20),
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
              SizedBox(height: 20),
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: GestureDetector(
                  onTap: () {
                    /* Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    ); */
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "En vous inscrivant, vous acceptez nos ",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                      children: const <TextSpan>[
                        TextSpan(
                          text: "Termes et Conditions >",
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
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
                        "Créer le compte",
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Divider(),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: "Vous avez déjà un compte?",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                    children: const <TextSpan>[
                      TextSpan(
                        text: " Se connecter ici",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
