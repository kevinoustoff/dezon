import 'dart:convert';

import 'package:dezon/views/widgets/serviceCard.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../constants.dart';

class SavedServices extends StatefulWidget {
  final String userId;
  SavedServices({@required this.userId});
  @override
  _SavedServicesState createState() => _SavedServicesState();
}

class _SavedServicesState extends State<SavedServices> {
  Future<List<Map>> futureProjects;

  Future<List<Map>> fetchProjects() async {
    print(
      ApiRoutes.host + ApiRoutes.savedServices + widget.userId,
    );
    final response = await http.get(
      Uri.parse(
        ApiRoutes.host + ApiRoutes.savedServices + widget.userId,
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
      throw Exception('Failed to load services');
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
        title: Text("Jobs Enregistrés"),
      ),
      body: FutureBuilder<List<Map>>(
        future: futureProjects,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final respBody = snapshot.data;
            return Container(
              height: fullHeight(context),
              width: fullWidth(context),
              child: (respBody.isNotEmpty)
                  ? SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = 0; i < respBody.length; i++)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.5),
                              child: ServiceCard(
                                freelancerId: respBody[i]['author_id'],
                                id: respBody[i]['id'],
                                image: respBody[i]['image'],
                                title: respBody[i]['title'],
                                freelancerName: respBody[i]['freelancer-name'],
                                freelancerPhoto: respBody[i]
                                    ['freelancer-photo-profile'],
                                price: respBody[i]['price'],
                                queued: respBody[i]['queued'],
                                rates: "0",
                              ),
                            ),
                        ],
                      ),
                    )
                  : Center(
                      child: Text(
                        "Vous n'avez pas enregistré de jobs pour l'instant. Une fois enregistrés, ils s'afficheront ici.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
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
