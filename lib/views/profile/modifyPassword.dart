import 'dart:convert';

import 'package:dezon/components/dataConnectionChecker.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import 'package:http/http.dart' as http;

class ModifyPassword extends StatefulWidget {
  @override
  _ModifyPasswordState createState() => _ModifyPasswordState();
}

class _ModifyPasswordState extends State<ModifyPassword> {
  final _formKey = GlobalKey<FormState>();
  String password;
  String newPassword;
  bool showPass = false;
  bool showNewPass = false;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modification Mot de passe'),
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
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Mot de passe actuel",
                      suffix: IconButton(
                        icon: Icon(
                          showPass ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () => setState(
                          () => showPass = !showPass,
                        ),
                      ),
                    ),
                    validator: validatePassword,
                    onSaved: (newValue) {
                      setState(() {
                        password = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Nouveau Mot de passe",
                      suffix: IconButton(
                        icon: Icon(
                          showNewPass ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () => setState(
                          () => showNewPass = !showNewPass,
                        ),
                      ),
                    ),
                    validator: validatePassword,
                    onSaved: (newValue) {
                      setState(() {
                        newPassword = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 25),
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
                              setState(() => showSpinner = true);
                              if (await DataConnectionChecker().hasConnection) {
                                try {
                                  int userId =
                                      (await SharedPreferences.getInstance())
                                          .getInt('ID');
                                  if (userId != null) {
                                    var uri = Uri.parse(
                                        ApiRoutes.host + ApiRoutes.modifyPass);
                                    var resp = await http.post(
                                      uri,
                                      body: {
                                        "user_id": userId.toString(),
                                        "old_password": password,
                                        "new_password": newPassword,
                                        "confirm_password": newPassword,
                                      },
                                    );
                                    /* print(
                                        "Response Status code: ${resp.statusCode}");
                                    print("Response body: ${resp.body}"); */
                                    if (resp.statusCode
                                        .toString()
                                        .startsWith('20')) {
                                      _formKey.currentState.reset();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text("Modification réussie"),
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
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "L'application a rencontré une erreur. Veuillez réessayer plus tard !",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  //print("Error: $e");
                                }
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
                              setState(() => showSpinner = false);
                            }
                          },
                          child: Text(
                            "SOUMETTRE",
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
