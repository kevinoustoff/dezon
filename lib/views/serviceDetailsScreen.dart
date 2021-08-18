import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simple_html_css/simple_html_css.dart';
import 'dart:convert';

import '../constants.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String id;
  ServiceDetailsScreen({@required this.id});
  @override
  _ServiceDetailsScreenState createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  Future<Map> futureServiceData;

  @override
  void initState() {
    futureServiceData = fetchData();
    super.initState();
  }

  Future<Map> fetchData() async {
    final response = await http.get(
      Uri.parse(
        ApiRoutes.host + ApiRoutes.fetchServiceById + widget.id,
      ),
    );
    print("Status Code: " +
        response.statusCode.toString() +
        '\n' +
        "Body: " +
        "${response.body}");

    if (response.statusCode.toString().startsWith('20')) {
      return Map.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle aStyle = const TextStyle(color: Colors.black54);
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du service'),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'PAYER',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Map>(
          future: futureServiceData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              final Map serviceMap = snapshot.data;
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 0.1),
                    ),
                    child: (serviceMap['image'] != null)
                        ? Image.network(
                            serviceMap['image'],
                            height: fullHeight(context) * 0.19,
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                          )
                        : Container(
                            height: fullHeight(context) * 0.13,
                            width: double.infinity,
                            color: Colors.black54,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var i = 0; i < 3; i++)
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.5),
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: [
                                            "Livraison",
                                            "Disponibilité",
                                            "Niveau"
                                          ][i] +
                                          '\n',
                                      style: aStyle,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: serviceMap[[
                                                "delivery-time",
                                                "response-time",
                                                "english_level",
                                              ][i]] ??
                                              '',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Divider(thickness: 0.8),
                        Text(
                          serviceMap['title'] ?? '',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Wrap(
                          spacing: 15,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              'À partir de',
                            ),
                            Builder(
                              builder: (context) {
                                String dPrice = '';
                                if (serviceMap["price"] != null) {
                                  dPrice = serviceMap["price"];
                                } else {
                                  dPrice = (serviceMap["hourly_price"] ?? '0') +
                                      '/h' +
                                      '\n~ ' +
                                      (serviceMap["estimated_hours"] ?? '0') +
                                      ' h';
                                }
                                return Text(
                                  dPrice,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 15,
                              backgroundImage: Image.network(
                                serviceMap["freelance-photo-profile"],
                                height: fullHeight(context) * 0.13,
                                width: double.infinity,
                                fit: BoxFit.fitWidth,
                              ).image,
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Text(
                                  serviceMap['freelancer-name'] ?? '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: RichText(
                            text: HTML.toTextSpan(
                                context, serviceMap["description"] ?? ''),
                          ),
                        ),
                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return Center(child: const CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
