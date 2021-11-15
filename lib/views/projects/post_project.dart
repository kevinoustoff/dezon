import 'dart:io';

import 'package:dezon/components/dataConnectionChecker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dezon/constants.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

const fillColor = Color(0xFFf4f6f9);

class PostProject extends StatefulWidget {
  final int userId;
  PostProject({@required this.userId});

  @override
  _PostProjectState createState() => _PostProjectState();
}

class _PostProjectState extends State<PostProject> {
  final _formKey = GlobalKey<FormState>();
  bool showSpinner = false;
  bool isRemote = false;

  ///USER CHOICE
  String title;
  String price;
  String details;
  String address;
  File docmt;
  List languagesChoosed = [];
  List skillsChoosed = [];

  ///FETCHED DATA
  String category;
  String prestataireType;
  String remunerationType;
  String projectDuration;
  String pays;

  Future<Map> futureCreationData;

  Future<Map> fetchCreationData() async {
    const String whatWeGettin = "Creation's Data";
    printGetStart(whatWeGettin);
    final response = await http.get(
      Uri.parse(
        ApiRoutes.host + ApiRoutes.createProjectGet,
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
          "Publier un projet",
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
            child: FutureBuilder(
              future: futureCreationData,
              builder: (context, snapshot) {
                if ((snapshot.connectionState == ConnectionState.done) &&
                    snapshot.hasData) {
                  final Map<String, dynamic> locationsList = {
                    for (var i = 0; i < snapshot.data['locations'].length; i++)
                      if (snapshot.data['locations'][i]['villes'].length != 0)
                        for (var j = 0;
                            j < snapshot.data['locations'][i]['villes'].length;
                            j++)
                          (snapshot.data['locations'][i]['name'] +
                              " :: " +
                              snapshot.data['locations'][i]['villes'][j]
                                  ['name']): snapshot.data['locations'][i]
                              ['villes'][j]['id']
                      else
                        snapshot.data['locations'][i]['name']:
                            snapshot.data['locations'][i]['id']
                  };
                  final Map<String, dynamic> typesFreelancers = {
                    for (var i = 0;
                        i < snapshot.data['types-freelancers'].length;
                        i++)
                      snapshot.data['types-freelancers'][i]['name']:
                          snapshot.data['types-freelancers'][i]['id']
                  };
                  final Map<String, dynamic> skillsFreelancers = {
                    for (var i = 0;
                        i < snapshot.data['skills-freelancers'].length;
                        i++)
                      snapshot.data['skills-freelancers'][i]['name']:
                          snapshot.data['skills-freelancers'][i]['term_id']
                  };
                  final Map<String, dynamic> languagesFreelancers = {
                    for (var i = 0;
                        i < snapshot.data['languages-freelancers'].length;
                        i++)
                      snapshot.data['languages-freelancers'][i]['name']:
                          snapshot.data['languages-freelancers'][i]['id']
                  };
                  final Map<String, dynamic> durationsList = {
                    for (var i = 0; i < snapshot.data['durations'].length; i++)
                      snapshot.data['durations'][i]['name']:
                          snapshot.data['durations'][i]['term_id']
                  };
                  final Map<String, dynamic> paymentsList = {
                    for (var i = 0; i < snapshot.data['payments'].length; i++)
                      snapshot.data['payments'][i]['name_fr']:
                          snapshot.data['payments'][i]['term_id']
                  };
                  final Map<String, dynamic> categoriesList = {
                    for (var i = 0; i < snapshot.data['categories'].length; i++)
                      snapshot.data['categories'][i]['name']:
                          snapshot.data['categories'][i]['term_id']
                  };

                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 100),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Lors de la création d'un projet, assurez-vous de le créer dans une catégorie inappropriée.",
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
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
                                hintText: "Exemple: Réalisation de clip video",
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
                                    "Type de prestataire souhaité",
                                  ),
                                ),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                value: prestataireType,
                                items: <String>[...typesFreelancers.keys]
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) =>
                                    setState(() => prestataireType = value),
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
                                    "Type de rémuneration",
                                  ),
                                ),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                value: remunerationType,
                                items: <String>[...paymentsList.keys]
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) =>
                                    setState(() => remunerationType = value),
                              ),
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
                                labelText: "Prix",
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
                                    "Durée du projet",
                                  ),
                                ),
                                icon: const Icon(Icons.keyboard_arrow_down),
                                value: projectDuration,
                                items: <String>[...durationsList.keys]
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) =>
                                    setState(() => projectDuration = value),
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
                                    "Pays",
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
                            child: CheckboxListTile(
                              value: isRemote,
                              onChanged: (value) {
                                setState(() {
                                  isRemote = !isRemote;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: const EdgeInsets.all(0),
                              dense: true,
                              isThreeLine: false,
                              title: const Text(
                                "Sélectionnez ce champ pour une localisation distante.",
                                //style: AppStyles.information,
                              ),
                            ),
                          ),
                          Text(
                            "Compétences requises",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Wrap(
                              spacing: 8,
                              children: [
                                for (var i = 0;
                                    i < skillsFreelancers.keys.length;
                                    i++)
                                  Builder(builder: (context) {
                                    final theId = skillsFreelancers[
                                        skillsFreelancers.keys.toList()[i]];
                                    return GestureDetector(
                                      onTap: () {
                                        if (skillsChoosed.contains(theId)) {
                                          setState(() {
                                            skillsChoosed.remove(theId);
                                          });
                                        } else {
                                          setState(() {
                                            skillsChoosed.add(theId);
                                          });
                                        }
                                      },
                                      child: Chip(
                                        backgroundColor: skillsChoosed
                                                .contains(theId)
                                            ? kPrimaryColor
                                            : Color.fromRGBO(255, 180, 19, 0.2),
                                        label: Text(
                                          skillsFreelancers.keys.toList()[i],
                                          style: TextStyle(
                                              color:
                                                  skillsChoosed.contains(theId)
                                                      ? Colors.white
                                                      : Colors.black),
                                        ),
                                      ),
                                    );
                                  }),
                              ],
                            ),
                          ),
                          Text(
                            "Langues requises",
                            style: TextStyle(
                              fontSize: 16,
                              //fontWeight: FontWeight.w500,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Wrap(
                              spacing: 8,
                              children: [
                                for (var i = 0;
                                    i < languagesFreelancers.keys.length;
                                    i++)
                                  Builder(builder: (context) {
                                    final theId = languagesFreelancers[
                                        languagesFreelancers.keys.toList()[i]];
                                    return GestureDetector(
                                      onTap: () {
                                        if (languagesChoosed.contains(theId)) {
                                          setState(() {
                                            languagesChoosed.remove(theId);
                                          });
                                        } else {
                                          setState(() {
                                            languagesChoosed.add(theId);
                                          });
                                        }
                                      },
                                      child: Chip(
                                        backgroundColor: languagesChoosed
                                                .contains(theId)
                                            ? kPrimaryColor
                                            : Color.fromRGBO(255, 180, 19, 0.2),
                                        label: Text(
                                          languagesFreelancers.keys.toList()[i],
                                          style: TextStyle(
                                              color: languagesChoosed
                                                      .contains(theId)
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                      ),
                                    );
                                  }),
                              ],
                            ),
                          ),
                          SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Détail du projet",
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
                                    children: [
                                      Text(docmt.path),
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
                          SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Localisation du client",
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
                                labelText: "Adresse",
                              ),
                              validator: (value) {
                                if ((value == null) ||
                                    value.isEmpty ||
                                    (value.length < 4)) {
                                  return "Adresse invalide";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                setState(() {
                                  address = newValue;
                                });
                              },
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
                                    prestataireType,
                                    remunerationType,
                                    projectDuration,
                                    pays
                                  ].contains(null)) &&
                                  skillsChoosed.isNotEmpty &&
                                  languagesChoosed.isNotEmpty) {
                                _formKey.currentState.save();
                                if (await DataConnectionChecker()
                                    .hasConnection) {
                                  setState(() => showSpinner = true);
                                  try {
                                    final request = new http.MultipartRequest(
                                      "POST",
                                      Uri.parse(ApiRoutes.host +
                                          ApiRoutes.createProjectPost),
                                    )
                                      ..headers.addAll(
                                        {
                                          /* 'Authorization':
                                                      "Bearer ${widget.id}", */
                                          "Content-Type": "application/json",
                                          "Accept": "application/json"
                                        },
                                      )
                                      ..fields['project_name'] = title
                                      ..fields['project_description'] = details
                                      ..fields['project_cost'] = price
                                      ..fields['project_category'] =
                                          categoriesList[category].toString()
                                      ..fields['freelancer_type'] =
                                          typesFreelancers[prestataireType]
                                              .toString()
                                      ..fields['project_type'] =
                                          categoriesList[category].toString()
                                      ..fields['project_duration'] =
                                          durationsList[projectDuration]
                                              .toString()
                                      ..fields['project_location'] =
                                          durationsList[pays].toString()
                                      ..fields['project_location_remote'] =
                                          isRemote ? '1' : '0'
                                      ..fields['project_skills'] =
                                          skillsChoosed.toString()
                                      ..fields['project_languages'] =
                                          languagesChoosed.toString()
                                      ..fields['project_address'] = address
                                      ..fields['project_lat'] = "6.1238376"
                                      ..fields['project_long'] = "1.623"
                                      ..fields['user_id'] =
                                          widget.userId.toString();
                                    if (docmt != null)
                                      request.files.add(
                                        await http.MultipartFile.fromPath(
                                            'project_attachment_0', docmt.path),
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
                                            "Projet publié.",
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          padding: EdgeInsets.fromLTRB(
                                              15, 10, 15, 10),
                                        ),
                                      );
                                      await Future.delayed(
                                        Duration(seconds: 1, milliseconds: 20),
                                      );
                                      Navigator.pop(context, true);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.redAccent,
                                          content: Text(
                                            "Le projet n'a pas pu être publié. Assurez vous d'avoir une connexion stable et réessayez.\nSi le problème persiste, contactez le service client.",
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          padding: EdgeInsets.fromLTRB(
                                              15, 10, 15, 10),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    print("ERROR $e");
                                    setState(() => showSpinner = false);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.redAccent,
                                        content: Text(
                                          "Le projet n'a pas pu être publié. Assurez vous d'avoir une connexion stable et réessayez.\nSi le problème persiste, contactez le service client.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(15, 10, 15, 10),
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
              },
            ),
          );
        }),
      ),
    );
  }
}
