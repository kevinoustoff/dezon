import 'dart:convert';

import 'package:dezon/views/serviceCard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';
import '../drawer.dart';
import '../filterServices.dart';
import 'homePage.dart';

class ServicesList extends StatefulWidget {
  @override
  _ServicesListState createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(menuLabels[1]),
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.end /* MainAxisAlignment.spaceBetween */,
              children: [
                /* Row(
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
                ), */
                TextButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FilterServices(),
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
                    ApiRoutes.host + ApiRoutes.topServices,
                  ),
                ),
                builder: (context, snapshot) {
                  if ((snapshot.connectionState == ConnectionState.done) &&
                      snapshot.hasData) {
                    var response = snapshot.data;
                    /* print("Status Code: " +
                        response.statusCode.toString() +
                        '\n' +
                        "Body: " +
                        "${response.body}"); */
                    if (response.statusCode.toString().startsWith('20')) {
                      List<Map> respBody = [
                        for (var i = 0;
                            i < jsonDecode(response.body).length;
                            i++)
                          Map.from(jsonDecode(response.body)[i])
                      ];
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
                                  freelancerName: respBody[i]
                                      ['freelancer-name'],
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
                    }
                  }
                  return Center(
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
