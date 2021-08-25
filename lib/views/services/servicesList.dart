import 'dart:convert';

import 'package:dezon/views/widgets/serviceCard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

class ServicesList extends StatefulWidget {
  @override
  _ServicesListState createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  Future<List<Map>> futureServices;

  Future<List<Map>> fetchServices() async {
    const String whatWeGettin = 'list of services';
    printGetStart(whatWeGettin);
    final response = await http.get(
      Uri.parse(
        ApiRoutes.host + ApiRoutes.topServices,
      ),
    );

    if (response.statusCode.toString().startsWith('20')) {
      printGetDone(whatWeGettin);
      return [
        for (var i = 0; i < jsonDecode(response.body).length; i++)
          Map.from(jsonDecode(response.body)[i])
      ];
    } else {
      printGetFailed(whatWeGettin);
      throw Exception('Failed to load $whatWeGettin');
    }
  }

  @override
  void initState() {
    futureServices = fetchServices();
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                future: futureServices,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    final respBody = snapshot.data;
                    return SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(2.5, 0, 2.5, 30),
                      child: Column(
                        children: [
                          for (var i = 0; i < respBody.length; i++)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.5),
                              child: ServiceCard(
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
          ],
        ),
      ),
    );
  }
}
