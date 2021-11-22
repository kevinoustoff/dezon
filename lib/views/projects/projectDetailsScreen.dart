import 'dart:convert';

import 'package:dezon/views/profile/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dezon/constants.dart';
import 'package:dezon/views/projects/makeOfferScreen.dart';
import 'package:simple_html_css/simple_html_css.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final String id;
  ProjectDetailsScreen({@required this.id});
  @override
  _ProjectDetailsScreenState createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  Future<Map> futureProjectData;
  final TextStyle sectionStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  Future<Map> fetchProjectData() async {
    const String whatWeGettin = "Project's Data";
    printGetStart(whatWeGettin);
    final response = await http.get(
      Uri.parse(
        ApiRoutes.host + ApiRoutes.fetchProjectById + widget.id,
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

  @override
  void initState() {
    futureProjectData = fetchProjectData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle aStyle = const TextStyle(color: Colors.black54);
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du projet'),
      ),
      body: FutureBuilder<Map>(
        future: futureProjectData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final respBody = snapshot.data;
            List<Map> savedSkills = [
              for (var i = 0; i < respBody["saved_skills"].length; i++)
                Map.from(respBody["saved_skills"][i])
            ];
            return Container(
              height: fullHeight(context),
              width: fullWidth(context),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
                            child: Text("Publié le " +
                                (respBody["publish-date"] ?? '')),
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 15,
                            runSpacing: 5,
                            children: [
                              for (var i = 0; i < 4; i++)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      [
                                        "Type de jobeur",
                                        "Durée",
                                        "Catégorie",
                                        "Langues",
                                      ][i],
                                      style: aStyle,
                                    ),
                                    Builder(
                                      builder: (context) {
                                        String tf = '';
                                        if (i == 3) {
                                          for (var j = 0;
                                              j < respBody["languages"].length;
                                              j++) {
                                            tf = tf +
                                                (j == 0 ? '' : ' ') +
                                                Map.from(respBody["languages"]
                                                    [j])['name'];
                                          }
                                        } else {
                                          tf = respBody[[
                                            "freelancer_type",
                                            "duration",
                                            "category"
                                          ][i]];
                                        }
                                        return Text(tf ?? '');
                                      },
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          Text(
                            respBody["title"] ?? '',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 15,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Budget :',
                              ),
                              Builder(
                                builder: (context) {
                                  String dPrice = '';
                                  if (respBody["cost"] != null) {
                                    dPrice = respBody["cost"];
                                  } else {
                                    dPrice = (respBody["hourly_price"] ?? '0') +
                                        '/h' +
                                        '\n~ ' +
                                        (respBody["estimated_hours"] ?? '0') +
                                        ' h';
                                  }
                                  return Text(
                                    dPrice,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          Text(respBody["project_expiry"] ?? ''),
                          SizedBox(height: 8),
                          Divider(),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => UserProfile(
                                    id: 1,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                /* CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 15,
                                  backgroundImage: Image.network(
                                    respBody["freelance-photo-profile"],
                                    height: fullHeight(context) * 0.13,
                                    width: double.infinity,
                                    fit: BoxFit.fitWidth,
                                  ).image,
                                ), */
                                //SizedBox(width: 10),
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: Text(
                                      respBody["employer_name"] ?? '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "Togo, 0 projets finalisés, Email verifié.\n Paiement par .....",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Divider(),
                          ExpansionTile(
                            tilePadding: EdgeInsets.all(0),
                            iconColor: Colors.black,
                            textColor: Colors.black,
                            expandedAlignment: Alignment.topLeft,
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            childrenPadding: EdgeInsets.fromLTRB(5, 0, 5, 15),
                            title: Text(
                              'Fichiers joints (4)',
                              style: sectionStyle,
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
                              style: sectionStyle,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: RichText(
                              text: HTML.toTextSpan(
                                  context, respBody["description"] ?? ''),
                              //...
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Compétences requises',
                            style: sectionStyle,
                          ),
                          Wrap(
                            spacing: 8,
                            children: [
                              for (var i = 0; i < savedSkills.length; i++)
                                Chip(
                                  backgroundColor:
                                      Color.fromRGBO(255, 180, 19, 0.2),
                                  label: Text(
                                    savedSkills[i]['name'],
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 1, 15, 8),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(kPrimaryColor)),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MakeOfferScreen(),
                              ),
                            ),
                            child: Text(
                              'POSTULER',
                              //style: TextStyle(color: kPrimaryColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
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
    );
  }
}
