import 'dart:convert';
import 'dart:io';

import 'package:dezon/components/dataConnectionChecker.dart';
import 'package:dezon/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

const fillColor = Color(0xFFf4f6f9);

class PostService extends StatefulWidget {
  final int userId;
  PostService({@required this.userId});

  @override
  _PostServiceState createState() => _PostServiceState();
}

class _PostServiceState extends State<PostService> {
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;

  ///USER CHOICE
  String title;
  String price;
  String details;
  String address;
  File docmt;
  List addonsChoosed = [];

  ///FETCHED DATA
  String category;
  String disponibilite;
  String competence;
  String delai;
  String pays;

  Future<Map> futureCreationData;

  Future<Map> fetchCreationData() async {
    const String whatWeGettin = "Creation's Data";
    printGetStart(whatWeGettin);
    final response = await http.get(
      Uri.parse(
        ApiRoutes.host + ApiRoutes.createServiceGet + widget.userId.toString(),
      ),
    );

    print("Status Code: " +
        response.statusCode.toString() +
        '\n' +
        "Body: " +
        "${response.body}");

    if (response.statusCode.toString().startsWith('20')) {
      printGetDone(whatWeGettin);
      return Map.from(jsonDecode(response.body));
    } else {
      printGetFailed(whatWeGettin);
      throw Exception("Failed to load $whatWeGettin");
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
    futureCreationData = fetchCreationData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Publier un job",
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        color: Colors.brown,
        dismissible: true,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
        ),
        child: Builder(builder: (context) {
          return Container(
            height: fullHeight(context),
            width: fullWidth(context),
            child: FutureBuilder<Map>(
                future: futureCreationData,
                builder: (context, snapshot) {
                  if ((snapshot.connectionState == ConnectionState.done) &&
                      snapshot.hasData) {
                    final Map<String, dynamic> categoriesList = {
                      for (var i = 0;
                          i < snapshot.data['categories'].length;
                          i++)
                        snapshot.data['categories'][i]['name']:
                            snapshot.data['categories'][i]['term_id']
                    };
                    final Map<String, dynamic> delaisLivraisonsList = {
                      for (var i = 0;
                          i < snapshot.data['delais_livraisons'].length;
                          i++)
                        snapshot.data['delais_livraisons'][i]['name']:
                            snapshot.data['delais_livraisons'][i]['term_id']
                    };
                    final Map<String, dynamic> competencesLevels = {
                      for (var i = 0;
                          i < snapshot.data['competences_levels'].length;
                          i++)
                        snapshot.data['competences_levels'][i]['name']:
                            snapshot.data['competences_levels'][i]['term_id']
                    };
                    final Map<String, dynamic> locationsList = {
                      for (var i = 0;
                          i < snapshot.data['locations'].length;
                          i++)
                        snapshot.data['locations'][i]['name']:
                            snapshot.data['locations'][i]['term_id']
                    };
                    final Map<String, dynamic> disponibilitesList = {
                      for (var i = 0;
                          i < snapshot.data['disponibilites'].length;
                          i++)
                        snapshot.data['disponibilites'][i]['name']:
                            snapshot.data['disponibilites'][i]['term_id']
                    };
                    final Map<String, dynamic> addonsServices = {
                      for (var i = 0;
                          i < snapshot.data['addons_services'].length;
                          i++)
                        snapshot.data['addons_services'][i]['title']: {
                          'id': snapshot.data['addons_services'][i]['id'],
                          'desc': snapshot.data['addons_services'][i]
                              ['content'],
                          'price': snapshot.data['addons_services'][i]['price'],
                        }
                    };

                    return SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 100),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Informations de base",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: fillColor,
                                  labelText: "Titre",
                                  hintText:
                                      "Exemple: Réalisation de clip video",
                                ),
                                validator: (value) {
                                  if ((value == null) ||
                                      value.isEmpty ||
                                      (value.length < 4)) {
                                    return "Titre invalide";
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  setState(() {
                                    title = newValue;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: fillColor,
                                  labelText: "Prix (CFA)",
                                ),
                                validator: (value) {
                                  if ((value == null) ||
                                      value.isEmpty ||
                                      (int.tryParse(value) == null)) {
                                    return "Prix invalide";
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  setState(() {
                                    price = newValue;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Container(
                                color: fillColor,
                                child: DropdownButton<String>(
                                  elevation: 2,
                                  focusColor: Colors.white,
                                  dropdownColor: Colors.white,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  hint: const Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "Sélectionner une catégorie",
                                    ),
                                  ),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  value: category,
                                  items: <String>[...categoriesList.keys]
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (value) =>
                                      setState(() => category = value),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Container(
                                color: fillColor,
                                child: DropdownButton<String>(
                                  elevation: 2,
                                  focusColor: Colors.white,
                                  dropdownColor: Colors.white,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  hint: const Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "Delai de livraison",
                                    ),
                                  ),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  value: delai,
                                  items: <String>[...delaisLivraisonsList.keys]
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (value) =>
                                      setState(() => delai = value),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Container(
                                color: fillColor,
                                child: DropdownButton<String>(
                                  elevation: 2,
                                  focusColor: Colors.white,
                                  dropdownColor: Colors.white,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  hint: const Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "Localisation",
                                    ),
                                  ),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  value: pays,
                                  items: <String>[...locationsList.keys]
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (value) =>
                                      setState(() => pays = value),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Container(
                                color: fillColor,
                                child: DropdownButton<String>(
                                  elevation: 2,
                                  focusColor: Colors.white,
                                  dropdownColor: Colors.white,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  hint: const Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "Compétences",
                                    ),
                                  ),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  value: competence,
                                  items: <String>[...competencesLevels.keys]
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (value) =>
                                      setState(() => competence = value),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Container(
                                color: fillColor,
                                child: DropdownButton<String>(
                                  elevation: 2,
                                  focusColor: Colors.white,
                                  dropdownColor: Colors.white,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  hint: const Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "Disponibilité",
                                    ),
                                  ),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  value: disponibilite,
                                  items: <String>[...disponibilitesList.keys]
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (value) =>
                                      setState(() => disponibilite = value),
                                ),
                              ),
                            ),
                            Text(
                              "Votre disponibilité déterminera la vitesse d'exécution du job.",
                              style: TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            SizedBox(height: 25),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Détail du job",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: TextFormField(
                                maxLines: 4,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: fillColor,
                                  labelText: "Description",
                                ),
                                validator: (value) {
                                  if ((value == null) ||
                                      value.isEmpty ||
                                      (value.length < 4)) {
                                    return "Description invalide";
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  setState(() {
                                    details = newValue;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: (docmt == null)
                                  ? TextButton.icon(
                                      style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.blue.shade900)),
                                      onPressed: selectFile,
                                      icon: Icon(Icons.attach_file_outlined),
                                      label: Text(
                                        "Joindre des pièces jointes",
                                      ),
                                    )
                                  : Wrap(
                                      spacing: 5,
                                      runSpacing: 5,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Text(
                                          docmt.path.substring(
                                            docmt.path.lastIndexOf('/') + 1,
                                          ),
                                        ),
                                        TextButton.icon(
                                          style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.blue.shade900)),
                                          onPressed: selectFile,
                                          icon: Icon(Icons.edit_outlined),
                                          label: Text(
                                            "Modifier",
                                          ),
                                        )
                                      ],
                                    ),
                            ),
                            Text(
                              "Jobs sponsorisés",
                              style: TextStyle(
                                fontSize: 16,
                                //fontWeight: FontWeight.w500,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 15, 0, 15),
                              child: Wrap(
                                spacing: 8,
                                children: [
                                  for (var i = 0;
                                      i < addonsServices.keys.length;
                                      i++)
                                    Builder(builder: (context) {
                                      final theId = addonsServices[
                                              addonsServices.keys.toList()[i]]
                                          ['id'];
                                      final theDesc = addonsServices[
                                              addonsServices.keys.toList()[i]]
                                          ['desc'];
                                      final thePrice = addonsServices[
                                              addonsServices.keys.toList()[i]]
                                          ['price'];
                                      return GestureDetector(
                                        onTap: () {
                                          if (addonsChoosed.contains(theId)) {
                                            setState(() {
                                              addonsChoosed.remove(theId);
                                            });
                                          } else {
                                            setState(() {
                                              addonsChoosed.add(theId);
                                            });
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: Row(
                                            children: [
                                              Chip(
                                                backgroundColor: addonsChoosed
                                                        .contains(theId)
                                                    ? kPrimaryColor
                                                    : Color.fromRGBO(
                                                        255, 180, 19, 0.2),
                                                label: Text(
                                                  addonsServices.keys
                                                      .toList()[i],
                                                  style: TextStyle(
                                                      color: addonsChoosed
                                                              .contains(theId)
                                                          ? Colors.white
                                                          : Colors.black),
                                                ),
                                              ),
                                              SizedBox(width: 5),
                                              Flexible(
                                                child: Text(
                                                  (theDesc ?? '..') +
                                                      "\n" +
                                                      (thePrice ?? ".."),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                ],
                              ),
                            ),
                            SizedBox(height: 25),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red)),
                              onPressed: () async {
                                if (_formKey.currentState.validate() &&
                                    (![
                                      category,
                                      delai,
                                      pays,
                                      competence,
                                      disponibilite,
                                    ].contains(null)) &&
                                    addonsChoosed.isNotEmpty) {
                                  _formKey.currentState.save();
                                  if (await DataConnectionChecker()
                                      .hasConnection) {
                                    setState(() => showSpinner = true);
                                    try {
                                      final request = new http.MultipartRequest(
                                        "POST",
                                        Uri.parse(ApiRoutes.host +
                                            ApiRoutes.createServicePost),
                                      )
                                        ..headers.addAll(
                                          {
                                            /* 'Authorization':
                                                                "Bearer ${widget.id}", */
                                            "Content-Type": "application/json",
                                            "Accept": "application/json"
                                          },
                                        )
                                        ..fields['service_title'] = title
                                        ..fields['service_description'] =
                                            details
                                        ..fields['service_price'] = price
                                        ..fields['response_time'] =
                                            disponibilite
                                        ..fields['delivery_time'] = delai
                                        ..fields['service_level'] = competence
                                        ..fields['service_location'] = pays
                                        ..fields['service_category'] = category
                                        ..fields['service_latitude'] =
                                            "6.1238376"
                                        ..fields['service_longitude'] = "1.623"
                                        ..fields['user_id'] =
                                            widget.userId.toString()
                                        ..fields['addons_service'] =
                                            addonsChoosed.toString();
                                      if (docmt != null)
                                        request.files.add(
                                          await http.MultipartFile.fromPath(
                                              'service_attachment', docmt.path),
                                        );
                                      final response = await request.send();
                                      var responseData =
                                          await response.stream.toBytes();
                                      var responseString =
                                          String.fromCharCodes(responseData);
                                      print(response.statusCode.toString());
                                      print(responseString);
                                      setState(() => showSpinner = false);
                                      if (response.statusCode
                                          .toString()
                                          .startsWith('20')) {
                                        _formKey.currentState.reset();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.lightGreen,
                                            duration: Duration(
                                                seconds: 1, milliseconds: 500),
                                            content: Text(
                                              "Job publié.",
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
                                              seconds: 1, milliseconds: 20),
                                        );
                                        Navigator.pop(context, true);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.redAccent,
                                            content: Text(
                                              "Le job n'a pas pu être publié. Assurez vous d'avoir une connexion stable et réessayez.\nSi le problème persiste, contactez le service client.",
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
                                          backgroundColor: Colors.redAccent,
                                          content: Text(
                                            "Le job n'a pas pu être publié. Assurez vous d'avoir une connexion stable et réessayez.\nSi le problème persiste, contactez le service client.",
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          padding: EdgeInsets.fromLTRB(
                                              15, 10, 15, 10),
                                        ),
                                      );
                                    }
                                    setState(() => showSpinner = false);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          noConnectionText,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Veuillez remplir tous les champs correctement.",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Publier",
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                }),
          );
        }),
      ),
    );
  }
}
