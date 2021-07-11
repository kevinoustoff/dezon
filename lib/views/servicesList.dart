import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class ServicesList extends StatefulWidget {
  @override
  _ServicesListState createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: kPrimaryColor),
                      Text(
                        'Publier un service',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.filter_alt_outlined, color: kPrimaryColor),
                      Text(
                        'Filtrer',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: FutureBuilder(
                  future: http.get(
                    Uri.parse(
                      host + "/index.php/wp-json/api/services/last",
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
                        List<Map> respBody = [
                          for (var i = 0;
                              i < jsonDecode(response.body).length;
                              i++)
                            Map.from(jsonDecode(response.body)[i])
                        ];
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              for (var i = 0; i < respBody.length; i++)
                                Container(
                                  //height: fullHeight(context) * 0.5,
                                  //width: fullWidth(context) * 0.8,
                                  child: Card(
                                    elevation: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 5),
                                          (respBody[i]['image'] != null)
                                              ? Image.network(
                                                  respBody[i]['image'],
                                                  height: fullHeight(context) *
                                                      0.13,
                                                  width: double.infinity,
                                                  fit: BoxFit.fitWidth,
                                                )
                                              : Image.asset(
                                                  AppAssets.category1,
                                                  height: fullHeight(context) *
                                                      0.13,
                                                  width: double.infinity,
                                                  fit: BoxFit.fitWidth,
                                                ),
                                          SizedBox(height: 5),
                                          Text(
                                            respBody[i]['title'] ?? "",
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Row(
                                            //mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                                size: 20,
                                              ),
                                              Flexible(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4.0),
                                                  child: Text(
                                                    respBody[i][
                                                            'freelancer-name'] ??
                                                        "",
                                                    textAlign: TextAlign.center,
                                                    /* style: TextStyle(
                                                fontSize: 15,
                                              ), */
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Table(
                                              defaultVerticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .middle,
                                              children: [
                                                TableRow(
                                                  children: [
                                                    Text(
                                                      "Budget Min.",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      "Commandes",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      "Note",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                                TableRow(
                                                  children: [
                                                    Text(
                                                      respBody[i]['price'] ??
                                                          "",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      (respBody[i]['queued'] !=
                                                              null)
                                                          ? (respBody[i]
                                                                  ['queued']
                                                              .toString()
                                                              .split(' ')[0])
                                                          : "",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      "0",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
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
