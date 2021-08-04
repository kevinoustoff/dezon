import 'package:dezon/constants.dart';
import 'package:dezon/views/makeOfferScreen.dart';
import 'package:flutter/material.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final String id;
  ProjectDetailsScreen({@required this.id});
  @override
  _ProjectDetailsScreenState createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    TextStyle aStyle = const TextStyle(color: Colors.black54);
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du projet'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Publié le 18/04/2021"),
            Divider(
              thickness: 1,
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 15,
              runSpacing: 10,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Type de prestataire",
                      style: aStyle,
                    ),
                    Text("Niveau basique"),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Durée du projet",
                      style: aStyle,
                    ),
                    Text("2 Mois"),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Catégorie",
                      style: aStyle,
                    ),
                    Text("Informatique"),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Languages",
                      style: aStyle,
                    ),
                    Text("Anglais Arabe Espagnol"),
                  ],
                ),
              ],
            ),
            Divider(
              thickness: 1,
            ),
            Text(
              "React Native developer is required for our office",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            Wrap(
              spacing: 15,
              children: [
                Text(
                  'Budget (Fixe) :',
                ),
                Text(
                  "800 FCFA",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Text("Expire dans 799 jours"),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      'Jason',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              tilePadding: EdgeInsets.all(0),
              iconColor: Colors.black,
              textColor: Colors.black,
              expandedAlignment: Alignment.topLeft,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              childrenPadding: EdgeInsets.fromLTRB(5, 0, 5, 15),
              title: Text(
                'Fichiers joints (4)',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              children: <Widget>[
                Text(
                  'Cliquez le titre pour afficher le fichier',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 15,
                  runSpacing: 8,
                  children: [
                    for (var i = 0; i < 4; i++)
                      Text(
                        "Project Destription.txt",
                        style: TextStyle(
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              "Tech Software is looking for a Mobile Developer who has a solid creation foundation to React Native to go along with us in creating premium local encounters for our purchasers. In this job, you will convey very much planned, profoundly testable, and tough versatile applications.\nMain Requirements:\n1. An author should finish 5 articles every day.\n2. Cutoff time adherent.\n3. Installments will be made week after week.\n4. Singular Native author or Indian essayist/group.\n5. Articles should be novel, should go through Copyscape, and should be liberated from any syntactic errors.\n6. We pay Rs.80 per 500 words. Apply just if this rate is worthy for you.\nYou will likewise be instrumental in driving our portable innovation guide forward and evangelizing versatile turn of events and testing rehearses.",
            ),
            SizedBox(height: 20),
            Text(
              'Compétences requises',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Wrap(
              children: [
                Chip(
                  backgroundColor: Color.fromRGBO(255, 180, 19, 0.2),
                  label: Text(
                    "Développeur d'application",
                  ),
                ),
              ],
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MakeOfferScreen(),
          ),
        ),
        backgroundColor: kPrimaryColor,
        child: Icon(Icons.work_outline_rounded),
      ),
    );
  }
}
