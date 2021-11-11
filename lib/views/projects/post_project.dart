import 'package:dezon/constants.dart';
import 'package:flutter/material.dart';

const fillColor = Color(0xFFf4f6f9);

class PostProject extends StatefulWidget {
  final int userId;
  PostProject({@required this.userId});

  @override
  _PostProjectState createState() => _PostProjectState();
}

class _PostProjectState extends State<PostProject> {
  String category;
  final Map<String, dynamic> categoryTypes = {
    "Assistance à la personne": 'CE',
    "Livraison de médicaments": 'CNI',
    "Livraison de matériel": 'PP',
    "Visite à domicile": 'CMI',
    "Accompagnement en course": 'XPP',
  };
  String prestataireType;
  final Map<String, dynamic> prestataireTypes = {
    "Étudiant": 'CE',
    "Particulier": 'CNI',
    "Professionnel": 'PP',
  };
  String remunerationType;
  final Map<String, dynamic> remunerationTypes = {
    "Par heure": 'CE',
    "Fixe": 'CNI',
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
  String language;
  final Map<String, dynamic> languages = {
    "Allemand": 'CE',
    "Anglais": 'CNI',
    "Arabe": 'CNIa',
    "Chinois": 'CNIb',
    "Espagnol": 'CNIc',
    "Français": 'CNId',
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
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: fillColor,
                      labelText: "Titre",
                      hintText: "Exemple: Réalisation de clip video",
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
                          "Type de prestataire souhaité",
                        ),
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      value: prestataireType,
                      items: <String>[...prestataireTypes.keys]
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
                      items: <String>[...remunerationTypes.keys]
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
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: fillColor,
                      labelText: "Prix",
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
                          "Durée du projet",
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
                          "Pays",
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
                          "Compétences requises",
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
                          "Langues requises",
                        ),
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      value: language,
                      items: <String>[...languages.keys].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => language = value),
                    ),
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
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: fillColor,
                      labelText: "Adresse",
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
