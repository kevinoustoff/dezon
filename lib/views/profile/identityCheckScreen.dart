import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert';

import '../../constants.dart';

class IdentityCheckScreen extends StatefulWidget {
  final String id;
  IdentityCheckScreen({@required this.id});

  @override
  _IdentityCheckScreenState createState() => _IdentityCheckScreenState();
}

class _IdentityCheckScreenState extends State<IdentityCheckScreen> {
  Future<bool> futureCheckResult;
  final _formKey = GlobalKey<FormState>();
  String nom, phone, cni, adr;
  File docmt;
  bool showSpinner = false;

  Future<bool> fetchCheckResult() async {
    const String whatWeGettin = "Check' result";
    printGetStart(whatWeGettin);
    final response = await http.get(
      Uri.parse(
        ApiRoutes.host + ApiRoutes.checkVerificationStatus + widget.id,
      ),
    );

    if (response.statusCode.toString().startsWith('20')) {
      printGetDone(whatWeGettin);
      return Map.from(jsonDecode(response.body))["status"];
    } else {
      printGetFailed(whatWeGettin);
      throw Exception("Failed to get Check' result");
    }
  }

  selectFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        docmt = File(result.files.single.path);
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  void initState() {
    futureCheckResult = fetchCheckResult();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vérification de l'identité"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        color: Colors.brown,
        dismissible: true,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
        ),
        child: FutureBuilder<bool>(
          future: futureCheckResult,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: snapshot.data
                        ? [
                            Text(
                              "Détails de la vérification",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Vous avez déjà envoyé le document de vérification. Veuillez annuler la vérification pour renvoyer.",
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                setState(() => showSpinner = true);
                                try {
                                  final response = await http.get(
                                    Uri.parse(
                                      ApiRoutes.host +
                                          ApiRoutes.cancelVerification +
                                          widget.id,
                                    ),
                                  );
                                  setState(() => showSpinner = false);
                                  if (response.statusCode
                                      .toString()
                                      .startsWith('20')) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.lightGreen,
                                        duration: Duration(
                                            seconds: 1, milliseconds: 500),
                                        content: Text(
                                          "Annulation effectuée.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(15, 10, 15, 10),
                                      ),
                                    );
                                    await Future.delayed(
                                      Duration(seconds: 1, milliseconds: 20),
                                    );
                                    Navigator.pop(context, true);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.redAccent,
                                        content: Text(
                                          "L'opération n'a pu être effectuée. Assurez vous d'avoir une connexion stable et réessayez.\nSi le problème persiste, contactez le service client.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(15, 10, 15, 10),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  setState(() => showSpinner = false);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "L'opération n'a pu être effectuée. Assurez vous d'avoir une connexion stable et réessayez.\nSi le problème persiste, contactez le service client.",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.redAccent)),
                              child: Text(
                                "Annuler la vérification",
                              ),
                            ),
                          ]
                        : [
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
                                hintText: "Numéro de téléphone",
                                prefixIcon: Icon(Icons.phone),
                              ),
                              validator: (value) {
                                if (['', null].contains(value)) {
                                  return "N'oubliez pas le numéro";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                setState(() {
                                  phone = newValue;
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
                                hintText: "CNI / Passeport",
                                prefixIcon: Icon(Icons.credit_card_outlined),
                              ),
                              validator: (value) {
                                if (['', null].contains(value)) {
                                  return "N'oubliez pas l'identifiant";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                setState(() {
                                  cni = newValue;
                                });
                              },
                            ),
                            SizedBox(height: 15),
                            Text("Document"),
                            ElevatedButton(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.black),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.grey.shade50),
                              ),
                              onPressed: selectFile,
                              child: Row(
                                children: [
                                  Text(
                                    docmt != null
                                        ? "Fichier ajouté"
                                        : "Ajouter un document",
                                  ),
                                  SizedBox(width: 15),
                                  docmt != null
                                      ? IconButton(
                                          onPressed: () =>
                                              setState(() => docmt = null),
                                          icon: Icon(Icons.close),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              minLines: 3,
                              maxLines: 3,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                hintText: "Adresse",
                              ),
                              validator: (value) {
                                if (['', null].contains(value)) {
                                  return "N'oubliez pas l'adresse";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                setState(() {
                                  adr = newValue;
                                });
                              },
                            ),
                            SizedBox(height: 15),
                            Text(
                              "Les informations de votre compte doivent correspondre au document que vous fournissez.",
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        if (docmt != null) {
                                          _formKey.currentState.save();
                                          setState(() => showSpinner = true);
                                          try {
                                            final request = new http
                                                .MultipartRequest(
                                              "POST",
                                              Uri.parse(ApiRoutes.host +
                                                  ApiRoutes.verifyUser),
                                            )
                                              /* ..headers.addAll(
                                                {
                                                  'Authorization':
                                                      "Bearer ${widget.id}",
                                                  "Content-Type":
                                                      "application/json",
                                                  "Accept": "application/json"
                                                },
                                              ) */
                                              ..fields['user_id'] = widget.id
                                              ..fields['name'] = nom ?? ""
                                              ..fields['contact_number'] = phone
                                              ..fields['adress'] = adr
                                              ..fields['verification_number'] =
                                                  cni;
                                            if (docmt != null)
                                              request.files.add(
                                                await http.MultipartFile
                                                    .fromPath(
                                                        'fichier', docmt.path),
                                              );
                                            final response =
                                                await request.send();
                                            var responseData =
                                                await response.stream.toBytes();
                                            var responseString =
                                                String.fromCharCodes(
                                                    responseData);
                                            print(
                                                response.statusCode.toString());
                                            print(responseString);
                                            setState(() => showSpinner = false);
                                            if (response.statusCode
                                                .toString()
                                                .startsWith('20')) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  backgroundColor:
                                                      Colors.lightGreen,
                                                  duration: Duration(
                                                      seconds: 1,
                                                      milliseconds: 500),
                                                  content: Text(
                                                    "Demande envoyée.",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  padding: EdgeInsets.fromLTRB(
                                                      15, 10, 15, 10),
                                                ),
                                              );
                                              await Future.delayed(
                                                Duration(
                                                    seconds: 1,
                                                    milliseconds: 20),
                                              );
                                              Navigator.pop(context, true);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  content: Text(
                                                    "La demande n'a pas pu être envoyée. Assurez vous d'avoir une connexion stable et réessayez.\nSi le problème persiste, contactez le service client.",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  padding: EdgeInsets.fromLTRB(
                                                      15, 10, 15, 10),
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            print("ERROR $e");
                                            setState(() => showSpinner = false);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor:
                                                    Colors.redAccent,
                                                content: Text(
                                                  "La demande n'a pas pu être envoyée. Assurez vous d'avoir une connexion stable et réessayez.\nSi le problème persiste, contactez le service client.",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                padding: EdgeInsets.fromLTRB(
                                                    15, 10, 15, 10),
                                              ),
                                            );
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.redAccent,
                                              content: Text(
                                                "Veuillez choisir un document",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              padding: EdgeInsets.fromLTRB(
                                                  15, 10, 15, 10),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.redAccent)),
                                    child: Text(
                                      "Envoyer",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 100),
                          ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            );
          },
        ),
      ),
    );
  }
}
