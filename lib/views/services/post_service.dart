import 'package:dezon/constants.dart';
import 'package:flutter/material.dart';

const fillColor = Color(0xFFf4f6f9);

class PostService extends StatefulWidget {
  final int userId;
  PostService({@required this.userId});

  @override
  _PostServiceState createState() => _PostServiceState();
}

class _PostServiceState extends State<PostService> {
  String category;
  final Map<String, dynamic> categoryTypes = {
    "Assistance à la personne": 'CE',
    "Livraison de médicaments": 'CNI',
    "Livraison de matériel": 'PP',
    "Visite à domicile": 'CMI',
    "Accompagnement en course": 'XPP',
  };
  String projectDuration;
  final Map<String, dynamic> projectDurations = {
    "1 an": 'CE',
    "1-3 mois": 'CNI',
    "1-3 semaines": 'CNIa',
    "1-5 jours": 'CNIb',
    "À court terme": 'CNIc',
    "À long terme": 'CNId',
    "Autres": 'CNIe',
  };
  String pays;
  final Map<String, dynamic> paysList = {
    "Togo": 'CE',
    "Bénin": 'CNI',
  };
  String competence;
  final Map<String, dynamic> competences = {
    "Artiste musicien": 'CE',
    "Carreleur": 'CNI',
    "Coursier": 'CNIa',
    "Développeur d'application": 'CNIb',
    "Électricien": 'CNIc',
  };
  String disponibilite;
  final Map<String, dynamic> disponibilites = {
    "A negocier": 'CE',
    "Immediate": 'CNI',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Publier un projet",
        ),
      ),
      body: Container(
        height: fullHeight(context),
        width: fullWidth(context),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 100),
          child: Form(
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
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: fillColor,
                      labelText: "Titre",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: fillColor,
                      labelText: "Prix (FCFA)",
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
                          "Sélectionner une catégorie",
                        ),
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      value: category,
                      items:
                          <String>[...categoryTypes.keys].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => category = value),
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
                      value: projectDuration,
                      items: <String>[...projectDurations.keys]
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
                          "Localisation",
                        ),
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      value: pays,
                      items: <String>[...paysList.keys].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => pays = value),
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
                      items: <String>[...competences.keys].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => competence = value),
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
                      items:
                          <String>[...disponibilites.keys].map((String value) {
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
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Détail du service",
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
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: fillColor,
                      labelText: "Description",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: TextButton.icon(
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.blueAccent)),
                    onPressed: () {},
                    icon: Icon(Icons.attach_file_outlined),
                    label: Text(
                      "Joindre des pièces jointes",
                    ),
                  ),
                ),
                SizedBox(height: 25),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  onPressed: () {},
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
        ),
      ),
    );
  }
}
