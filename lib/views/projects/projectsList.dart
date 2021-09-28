import 'dart:convert';

import 'package:dezon/views/widgets/pagination_bubble.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../constants.dart';
import '../widgets/projectCard.dart';

class ProjectsList extends StatefulWidget {
  @override
  _ProjectsListState createState() => _ProjectsListState();
}

class _ProjectsListState extends State<ProjectsList> {
  Future<List<Map>> futureProjects;

  Future<List<Map>> fetchProjects() async {
    const String whatWeGettin = 'list of projects';
    printGetStart(whatWeGettin);
    final response = await http.get(
      Uri.parse(
        ApiRoutes.host + ApiRoutes.fetchProjects,
      ),
    );
    print("Status Code: " +
        response.statusCode.toString() +
        '\n' +
        "Body: " +
        "${response.body}");

    if (response.statusCode.toString().startsWith('20')) {
      printGetDone(whatWeGettin);
      final List respBodyTemp =
          (Map.from(jsonDecode(response.body)))['response'];
      return [
        for (var i = 0; i < respBodyTemp.length; i++) Map.from(respBodyTemp[i])
      ];
    } else {
      printGetFailed(whatWeGettin);
      throw Exception('Failed to load $whatWeGettin');
    }
  }

  @override
  void initState() {
    futureProjects = fetchProjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
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
                  onPressed: () {},
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
                child: FutureBuilder<List<Map>>(
              future: futureProjects,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final respBody = snapshot.data;
                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(2.5, 0, 2.5, 30),
                    child: Column(
                      children: [
                        for (var i = 0; i < respBody.length; i++)
                          ProjectCard(
                            estimatedHours: respBody[i]["estimated_hours"],
                            hourlyPrice: respBody[i]["hourly_price"],
                            cost: respBody[i]["cost"],
                            id: respBody[i]["id"],
                            employerName: respBody[i]["employer_name"],
                            duration: respBody[i]["duration"],
                            level: respBody[i]["level"],
                            freelancerType: respBody[i]["freelancer_type"],
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
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                  ),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
