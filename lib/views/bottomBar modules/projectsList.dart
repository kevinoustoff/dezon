import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../constants.dart';
import '../drawer.dart';
import 'homePage.dart';
import '../projectCard.dart';
import '../filterProjects.dart';

class ProjectsList extends StatefulWidget {
  @override
  _ProjectsListState createState() => _ProjectsListState();
}

class _ProjectsListState extends State<ProjectsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(menuLabels[2]),
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FilterProjects(),
                    ),
                  ),
                  icon: Icon(Icons.sort),
                  label: Text(
                    'Filtrer',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                  future: http.get(
                    Uri.parse(
                      ApiRoutes.host + ApiRoutes.fetchProjects,
                    ),
                  ),
                  builder: (context, snapshot) {
                    if ((snapshot.connectionState == ConnectionState.done) &&
                        snapshot.hasData) {
                      var response = snapshot.data;
                      print("Status Code: " +
                          response.statusCode.toString() +
                          '\n' +
                          "Body: " +
                          "${response.body}");
                      if (response.statusCode.toString().startsWith('20')) {
                        final List respBodyTemp =
                            (Map.from(jsonDecode(response.body)))['response'];
                        List<Map> respBody = [
                          for (var i = 0; i < respBodyTemp.length; i++)
                            Map.from(respBodyTemp[i])
                        ];

                        return SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(2.5, 0, 2.5, 30),
                          child: Column(
                            children: [
                              for (var i = 0; i < respBody.length; i++)
                                ProjectCard(
                                  estimatedHours: respBody[i]
                                      ["estimated_hours"],
                                  hourlyPrice: respBody[i]["hourly_price"],
                                  cost: respBody[i]["cost"],
                                  id: respBody[i]["id"],
                                  employerName: respBody[i]["employer_name"],
                                  duration: respBody[i]["duration"],
                                  level: respBody[i]["level"],
                                  freelancerType: respBody[i]
                                      ["freelancer_type"],
                                  projectExpiry: respBody[i]["project_expiry"],
                                  title: respBody[i]["title"],
                                  description: respBody[i]["description"],
                                  savedSkills: respBody[i]["saved_skills"],
                                  offres: respBody[i]["offres"].toString(),
                                  location: respBody[i]["location"],
                                ),
                            ],
                          ),
                        );
                      }
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(kPrimaryColor),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
