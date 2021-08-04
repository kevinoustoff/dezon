import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../constants.dart';
import 'drawer.dart';
import 'homePage.dart';
import 'paginationBubble.dart';
import 'projectCard.dart';
import 'filterProjects.dart';

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
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        color: kPrimaryColor,
                      ),
                    ),
                    for (var i = 0; i < 4; i++)
                      PaginationBubble(
                        isActive: i == 0,
                        number: i + 1,
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
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
                          padding: EdgeInsets.fromLTRB(2.5, 2.5, 2.5, 30),
                          child: Column(
                            children: [
                              for (var i = 0; i < respBody.length; i++)
                                ProjectCard(
                                  estimatedHours: respBody[i]
                                      ["estimated_hours"],
                                  hourlyPrice: respBody[i]["hourly_price"],
                                  cost: respBody[i]["cost"],
                                  id: respBody[i]["id"].toString(),
                                  employerName: respBody[i]["employer_name"],
                                  duration: respBody[i]["duration"],
                                  level: respBody[i]["level"],
                                  freelancerType: respBody[i]
                                      ["freelancer_type"],
                                  projectExpiry: respBody[i]["project_expiry"],
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
