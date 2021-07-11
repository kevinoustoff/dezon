import 'dart:convert';

import 'package:dezon/components/dataConnectionChecker.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();
  String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mot de passe oublié'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        color: Colors.brown,
        dismissible: true,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
        ),
        child: Builder(
          builder: (context) => SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
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
                  SizedBox(height: 40),
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
                                      host + ApiRoutes.forgotPassword);
                                  var resp = await http.post(
                                    uri,
                                    body: {
                                      'email': email,
                                    },
                                  );
                                  print(
                                      "Response Status code: ${resp.statusCode}");
                                  print("Response body: ${resp.body}");
                                  if (resp.statusCode
                                      .toString()
                                      .startsWith('20')) {
                                    Map respBody = Map.from(
                                        jsonDecode(resp.body))["body_response"];
                                    if (respBody != null) {}
                                  } else if (resp.statusCode
                                      .toString()
                                      .startsWith('401')) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          Map.from(
                                              jsonDecode(resp.body))['message'],
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
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
                            "Réinitialisez le mot de passe",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
