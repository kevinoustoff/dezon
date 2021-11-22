import 'dart:convert';

import 'package:dezon/components/dataConnectionChecker.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import '../home/homePage.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String email, password, identifiant, nom;
  bool showSpinner = false;
  ValueNotifier<bool> obscurePass = ValueNotifier(true);

  persistData(http.Response resp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map respBody = Map.from(jsonDecode(resp.body))["body_response"];
    prefs.setInt('ID', respBody['ID']);
    prefs.setBool('caps_subscriber', Map.from(respBody['caps'])['subscriber']);
    prefs.setString('cap_key', respBody['cap_key']);
    prefs.setStringList('roles', [
      for (var i = 0; i < respBody['roles'].length; i++)
        "${respBody['roles'][i]}"
    ]);
    prefs.setBool('allcaps_read', Map.from(respBody['allcaps'])['read']);
    prefs.setBool('allcaps_level_0', Map.from(respBody['allcaps'])['level_0']);
    prefs.setBool(
        'allcaps_subscriber', Map.from(respBody['allcaps'])['subscriber']);
    prefs.setString('user_login', Map.from(respBody['data'])['user_login']);
    prefs.setString('user_pass', Map.from(respBody['data'])['user_pass']);
    prefs.setString(
        'user_nicename', Map.from(respBody['data'])['user_nicename']);
    prefs.setString('user_email', Map.from(respBody['data'])['user_email']);
    prefs.setString(
        'user_registered', Map.from(respBody['data'])['user_registered']);
    prefs.setString('user_status', Map.from(respBody['data'])['user_status']);
    prefs.setString('display_name', Map.from(respBody['data'])['display_name']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Image.asset(
          AppAssets.appIcon,
          width: 40,
        ),
      ),
      body: ModalProgressHUD(
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
                  SizedBox(height: 15),
                  Text(
                    "S'inscrire chez Dezon",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    "Créez un nouveau compte avec nous et commencez à utiliser la plateforme la plus fiable pour embaucher des jobeurs et fournir des jobs.",
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
                      hintText: "Nom",
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                    validator: validateNom,
                    onSaved: (newValue) {
                      setState(() {
                        nom = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: "Identifiant",
                      prefixIcon: Icon(Icons.dashboard_outlined),
                    ),
                    validator: (value) => null,
                    onSaved: (newValue) {
                      setState(() {
                        identifiant = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 15),
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
                  SizedBox(height: 15),
                  ValueListenableBuilder(
                      valueListenable: obscurePass,
                      builder: (context, obscureV, _) {
                        return TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintText: "Mot de passe",
                            prefixIcon: Icon(Icons.security_rounded),
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  obscurePass.value = !obscurePass.value,
                              icon: Icon(
                                obscureV
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: validatePassword,
                          obscureText: obscureV,
                          onSaved: (newValue) {
                            setState(() {
                              password = newValue;
                            });
                          },
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: GestureDetector(
                      onTap: () async {
                        await canLaunch(
                                ApiRoutes.host + ApiRoutes.termsAndConditions)
                            ? await launch(
                                ApiRoutes.host + ApiRoutes.termsAndConditions)
                            : throw 'Could not launch ${ApiRoutes.host + ApiRoutes.termsAndConditions}';
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "En vous inscrivant, vous acceptez nos ",
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                          children: const <TextSpan>[
                            TextSpan(
                              text: "Termes et Conditions >",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
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
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(kPrimaryColor)),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              if (await DataConnectionChecker().hasConnection) {
                                setState(() => showSpinner = true);
                                try {
                                  var uri = Uri.parse(
                                      ApiRoutes.host + ApiRoutes.register);
                                  var resp = await http.post(
                                    uri,
                                    headers: {
                                      "Content-Type": "application/json",
                                      "Accept": "application/json"
                                    },
                                    body: json.encode(
                                      {
                                        'username': identifiant,
                                        "fullname": nom,
                                        'email': email,
                                        'password': password
                                      },
                                    ),
                                  );
                                  /* print(
                                      "Response Status code: ${resp.statusCode}");
                                  print("Response body: ${resp.body}"); */
                                  if (resp.statusCode
                                      .toString()
                                      .startsWith('20')) {
                                    ///PERSIST DATA
                                    ///
                                    persistData(resp);

                                    ///
                                    ///
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()),
                                      (Route<dynamic> route) => false,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          Map.from(jsonDecode(resp.body))[
                                                  'message'] ??
                                              "Erreur survenue sur le serveur !",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  //print("Error: $e");
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
                            "Créer le compte",
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(thickness: 2),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "Vous avez déjà un compte?",
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                          children: const <TextSpan>[
                            TextSpan(
                              text: " Se connecter ici",
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
