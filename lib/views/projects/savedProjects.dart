import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../constants.dart';

class SavedProjects extends StatefulWidget {
  final String userId;
  SavedProjects({@required this.userId});
  @override
  _SavedProjectsState createState() => _SavedProjectsState();
}

class _SavedProjectsState extends State<SavedProjects> {
  Future<List<Map>> futureProjects;

  Future<List<Map>> fetchProjects() async {
    print(
      ApiRoutes.host + ApiRoutes.savedProjects + widget.userId,
    );
    final response = await http.get(
      Uri.parse(
        ApiRoutes.host + ApiRoutes.savedProjects + widget.userId,
      ),
    );
    print("Status Code: " +
        response.statusCode.toString() +
        '\n' +
        "Body: " +
        "${response.body}");

    if (response.statusCode.toString().startsWith('20')) {
      final List respBodyTemp = jsonDecode(response.body);
      return [
        for (var i = 0; i < respBodyTemp.length; i++) Map.from(respBodyTemp[i])
      ];
    } else {
      throw Exception('Failed to load projects');
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
      appBar: AppBar(
        title: Text("Projets Enregistrés"),
      ),
      body: FutureBuilder<List<Map>>(
        future: futureProjects,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final respBody = snapshot.data;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 30),
              child: Container(
                height: fullHeight(context),
                width: fullWidth(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < respBody.length; i++)
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Card(
                          elevation: 1.5,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        respBody[i]['title'],
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "Niveau : " +
                                            (respBody[i]['level']['name'] ??
                                                ' '),
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        "Catégorie : " +
                                            respBody[i]['category'],
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        respBody[i]['date'],
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.more_vert),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
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
