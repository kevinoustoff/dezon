import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../constants.dart';
import '../widgets/projectCard.dart';

class MyProjects extends StatefulWidget {
  final int userId;
  MyProjects({@required this.userId});
  @override
  _MyProjectsState createState() => _MyProjectsState();
}

class _MyProjectsState extends State<MyProjects> {
  Future<List<Map>> futureMyProjects;

  Future<List<Map>> fetchProjects() async {
    const String whatWeGettin = 'list of my projects';
    printGetStart(whatWeGettin);
    final response = await http.get(
      Uri.parse(
        ApiRoutes.host + ApiRoutes.myProjects + widget.userId.toString(),
      ),
    );
    print("Status Code: " +
        response.statusCode.toString() +
        '\n' +
        "Body: " +
        "${response.body}");

    if (response.statusCode.toString().startsWith('20')) {
      printGetDone(whatWeGettin);
      final List respBodyTemp = jsonDecode(response.body);
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
    futureMyProjects = fetchProjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes projets'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
        child: FutureBuilder<List<Map>>(
          future: futureMyProjects,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              final respBody = snapshot.data;
              return (respBody.isNotEmpty)
                  ? SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(2.5, 0, 2.5, 30),
                      child: Column(
                        children: [
                          for (var i = 0; i < respBody.length; i++)
                            ProjectCard(
                              freelancerId: respBody[i]['author_id'],
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
                            )
                        ],
                      ),
                    )
                  : Center(
                      child: Text(
                        "Vous n'avez pas de projets pour l'instant. Une fois publiés, ils s'afficheront ici.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
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
