import 'dart:convert';

import 'package:dezon/components/dataConnectionChecker.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool showSpinner = false;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  String email, resetKey, password;
  int userId;
  bool emailSent = false, resetDone = false;

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
            child: emailSent
                ? (!resetDone
                    ? Form(
                        key: _formKey2,
                        child: Column(
                          children: [
                            SizedBox(height: 15),
                            Text(
                              "Un code vous a été envoyé par email. Entrez le suivi de votre nouveau mot de passe pour terminer la réinitialisation.",
                              style: TextStyle(fontSize: 17),
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: "Code",
                              ),
                              validator: validateResetKey,
                              onSaved: (newValue) {
                                setState(() {
                                  resetKey = newValue;
                                });
                              },
                            ),
                            SizedBox(height: 25),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: "Nouveau mot de passe",
                              ),
                              validator: validatePassword,
                              onSaved: (newValue) {
                                setState(() {
                                  password = newValue;
                                });
                              },
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                kPrimaryColor)),
                                    onPressed: () async {
                                      if (_formKey2.currentState.validate()) {
                                        _formKey2.currentState.save();
                                        if (await DataConnectionChecker()
                                            .hasConnection) {
                                          setState(() => showSpinner = true);
                                          try {
                                            var uri = Uri.parse(ApiRoutes.host +
                                                ApiRoutes.forgotPasswordSetNew);
                                            var resp = await http.post(
                                              uri,
                                              body: {
                                                "user_id": userId.toString(),
                                                "reset_key": resetKey,
                                                "password": password
                                              },
                                            );
                                            print(
                                                "Response Status code: ${resp.statusCode}");
                                            print(
                                                "Response body: ${resp.body}");
                                            if (resp.statusCode
                                                .toString()
                                                .startsWith('20')) {
                                              setState(() {
                                                resetDone = true;
                                              });
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
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
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
                                      "Terminer la réinitialisation",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          SizedBox(height: 15),
                          Text(
                            "Réinitialisation terminée avec succès.\n✅",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 17),
                          ),
                        ],
                      ))
                : Form(
                    key: _formKey1,
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
                                    backgroundColor: MaterialStateProperty.all(
                                        kPrimaryColor)),
                                onPressed: () async {
                                  if (_formKey1.currentState.validate()) {
                                    _formKey1.currentState.save();
                                    if (await DataConnectionChecker()
                                        .hasConnection) {
                                      setState(() => showSpinner = true);
                                      try {
                                        print("URL: " +
                                            ApiRoutes.host +
                                            ApiRoutes.forgotPassword);
                                        var uri = Uri.parse(ApiRoutes.host +
                                            ApiRoutes.forgotPassword);
                                        print("EMAIL :" + email);
                                        var resp = await http.post(
                                          uri,
                                          body: {'email': email},
                                        );
                                        /* print(
                                          "Response Status code: ${resp.statusCode}");
                                      print("Response body: ${resp.body}"); */
                                        if (resp.statusCode
                                            .toString()
                                            .startsWith('20')) {
                                          setState(() {
                                            userId =
                                                Map.from(jsonDecode(resp.body))[
                                                    "user_id"];
                                            emailSent = true;
                                          });
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
