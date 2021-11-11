import 'dart:convert';
import 'package:dezon/views/widgets/serviceCard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class MyServices extends StatefulWidget {
  final int userId;
  MyServices({@required this.userId});
  @override
  _MyServicesState createState() => _MyServicesState();
}

class _MyServicesState extends State<MyServices> {
  Future<List<Map>> futureMyServices;
  Future<List<Map>> fetchServices() async {
    const String whatWeGettin = 'list of my services';
    printGetStart(whatWeGettin);
    final response = await http.get(
      Uri.parse(
        ApiRoutes.host + ApiRoutes.myServices + widget.userId.toString(),
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
    futureMyServices = fetchServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes services'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
        child: FutureBuilder<List<Map>>(
          future: futureMyServices,
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
                        "Vous n'avez pas de services pour l'instant. Une fois publiés, ils s'afficheront ici.",
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
