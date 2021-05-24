import 'dart:convert';

import 'package:dezon/components/dataConnectionChecker.dart';
import 'package:dezon/views/registerScreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'homePage.dart';

String validatePassword(String s) {
  if (s == null || s.isEmpty) {
    return "Entrer un mot de passe!";
  }
  if (s.length < 8) {
    return "Au moins 8 caractères requis";
  }
  return null;
}

String validateEmail(String s) {
  if (s != null && s.isNotEmpty) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(s)) {
      return "Veuillez entrer un email valide!";
    }
  }
  if (s == null || s.isEmpty) {
    return "N'oubliez pas votre email!";
  }
  return null;
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;

  bool showSpinner = false;
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          color: Colors.brown,
          dismissible: true,
          progressIndicator: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
          ),
          child: Builder(
            builder: (context) => Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 35),
                    Text(
                      "Connectez vous sur Dezon",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      "Connectez-vous pour utiliser votre tableau de bord, c'est rapide et gratuit. Présentez vos compétences, faîtes des demandes de services et bien plus encore.",
                    ),
                    SizedBox(height: 25),
                    TextFormField(
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
                      validator: validateEmail,
                      onSaved: (newValue) {
                        setState(() {
                          email = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
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
                      validator: validatePassword,
                      onSaved: (newValue) {
                        setState(() {
                          password = newValue;
                        });
                      },
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
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                if (await DataConnectionChecker()
                                    .hasConnection) {
                                  setState(() => showSpinner = true);
                                  try {
                                    var uri = Uri.parse(host +
                                        "wordpress/index.php/wp-json/api/login");
                                    var resp = await http.post(
                                      uri,
                                      body: {
                                        'email': email, //"envnews1@gmail.com",
                                        'password': password //"91401376"
                                      },
                                    );
                                    print(
                                        "Response Status code: ${resp.statusCode}");
                                    print("Response body: ${resp.body}");
                                    if (resp.statusCode
                                        .toString()
                                        .startsWith('20')) {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      Map respBody =
                                          Map.from(jsonDecode(resp.body))[
                                              "body_response"];
                                      prefs.setInt('ID', respBody['ID']);
                                      prefs.setBool(
                                          'caps_subscriber',
                                          Map.from(
                                              respBody['caps'])['subscriber']);
                                      prefs.setString(
                                          'cap_key', respBody['cap_key']);
                                      prefs.setStringList('roles', [
                                        for (var i = 0;
                                            i < respBody['roles'].length;
                                            i++)
                                          "${respBody['roles'][i]}"
                                      ]);
                                      prefs.setBool(
                                          'allcaps_read',
                                          Map.from(
                                              respBody['allcaps'])['read']);
                                      prefs.setBool(
                                          'allcaps_level_0',
                                          Map.from(
                                              respBody['allcaps'])['level_0']);
                                      prefs.setBool(
                                          'allcaps_subscriber',
                                          Map.from(respBody['allcaps'])[
                                              'subscriber']);
                                      prefs.setString(
                                          'user_login',
                                          Map.from(
                                              respBody['data'])['user_login']);
                                      prefs.setString(
                                          'user_pass',
                                          Map.from(
                                              respBody['data'])['user_pass']);
                                      prefs.setString(
                                          'user_nicename',
                                          Map.from(respBody['data'])[
                                              'user_nicename']);
                                      prefs.setString(
                                          'user_email',
                                          Map.from(
                                              respBody['data'])['user_email']);
                                      prefs.setString(
                                          'user_registered',
                                          Map.from(respBody['data'])[
                                              'user_registered']);
                                      prefs.setString(
                                          'user_status',
                                          Map.from(
                                              respBody['data'])['user_status']);
                                      prefs.setString(
                                          'display_name',
                                          Map.from(respBody['data'])[
                                              'display_name']);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomePage(),
                                        ),
                                      );
                                    } else if (resp.statusCode
                                        .toString()
                                        .startsWith('401')) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            Map.from(jsonDecode(resp.body))[
                                                'message'],
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Erreur survenue sur le serveur !",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    print("Error: $e");
                                  }
                                  setState(() => showSpinner = false);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Connexion internet faible ou inexistante. Assurez vous d'avoir une bonne liaison internet et réessayez !",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }
                              }
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
          ),
        ),
      ),
    );
  }
}
