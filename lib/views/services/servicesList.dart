import 'dart:convert';

import 'package:dezon/views/widgets/filterModalContent.dart';
import 'package:dezon/views/widgets/pagination_bubble.dart';
import 'package:dezon/views/widgets/serviceCard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../constants.dart';

class ServicesList extends StatefulWidget {
  @override
  _ServicesListState createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  ValueNotifier<bool> showSpinner = ValueNotifier(false);
  Future<List<Map>> futureServices;
  ValueNotifier<Map<String, dynamic>> selectedFilters = ValueNotifier(
    {
      ///SERVICES
      'price-minS': '0',
      'price-maxS': '',
      'locationsS': [],
      'delais': [],
      'english-levels': [],
      'categoriesS': [],

      ///PROJECTS
      'price-minP': '0',
      'price-maxP': '',
      'locationsP': [],
      'languages': [],
      'categoriesP': [],
    },
  );
  ValueNotifier<String> keyword = ValueNotifier("");
  ValueNotifier<List<Map>> servicesData = ValueNotifier([]),
      projectsData = ValueNotifier([]);

  ///SERVICE FILTERS
  ValueNotifier<Map<String, List>> filters = ValueNotifier(
    {
      ///SERVICES
      'locationsS': [],
      'delais': [],
      'english-levels': [],
      'categoriesS': [],

      ///PROJECTS
      'locationsP': [],
      'languages': [],
      'categoriesP': [],
    },
  );

  Future<void> fetchFilters() async {
    try {
      final http.Response response = await http.get(
        Uri.parse(ApiRoutes.host + ApiRoutes.fetchSearchFilters),
      );
      /* print("Status Code: " +
          response.statusCode.toString() +
          '\n' +
          "Body: " +
          "${response.body}"); */
      if (response.statusCode.toString().startsWith('20')) {
        ///SERVICE
        final Map bodyMap = Map.from(jsonDecode(response.body));
        for (var j = 0; j < 4; j++) {
          final String filterCase = [
            'locations',
            'livraison',
            'english-level',
            'servicesCategories'
          ][j];
          filters.value[[
            'locationsS',
            'delais',
            'english-levels',
            'categoriesS'
          ][j]] = [
            for (var i = 0; i < bodyMap[filterCase].length; i++)
              Map.from(bodyMap[filterCase][i])
          ];
        }

        ///PROJECT
        final Map projectMap = Map.from(bodyMap['projects']);
        for (var j = 0; j < 3; j++) {
          final String filterCase = ['locations', 'languages', 'categories'][j];
          filters.value[['locationsP', 'languages', 'categoriesP'][j]] = [
            for (var i = 0; i < projectMap[filterCase].length; i++)
              Map.from(projectMap[filterCase][i])
          ];
        }
      }
    } catch (e) {
      //print("$e");
    }
  }

  Future<List<Map>> fetchServices() async {
    String url = ApiRoutes.host +
        ApiRoutes.searchServices +
        (keyword.value ?? '') +
        ('&price-min=' + selectedFilters.value['price-minS'] ?? '0') +
        ('&price-max=' +
            (![null, '', '0'].contains(selectedFilters.value['price-maxS'])
                ? selectedFilters.value['price-maxS']
                : '99999999999999999999999'));
    for (var i = 0; i < 4; i++) {
      final List tmp0 = selectedFilters
          .value[['locationsS', 'delais', 'english-levels', 'categoriesS'][i]];
      for (var j = 0; j < tmp0.length; j++) {
        url += [
              '&location=',
              '&delivery-time=',
              '&english-level=',
              '&categories='
            ][i] +
            tmp0[j].toString();
      }
    }

    print("L'URL EST : $url\n");
    final http.Response response = await http.get(
      Uri.parse(url),
    );
    print("Status Code: " +
        response.statusCode.toString() +
        '\n' +
        "Body: " +
        "${response.body}");

    if (response.statusCode.toString().startsWith('20')) {
      print(jsonDecode(response.body).toString());
      return [
        for (var i = 0; i < jsonDecode(response.body).length; i++)
          Map.from(jsonDecode(response.body)[i])
      ];
    } else {
      throw Exception('Failed to load services');
    }
  }

  @override
  void initState() {
    fetchFilters();
    showSpinner.value = true;
    try {
      futureServices = fetchServices();
    } catch (e) {
      showSpinner.value = false;
    }
    showSpinner.value = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: showSpinner,
          builder: (context, showSpi, _) {
            return ModalProgressHUD(
              inAsyncCall: showSpi,
              color: Colors.brown,
              dismissible: true,
              progressIndicator: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
              child: Padding(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: kPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            final filterMap = await showModalBottomSheet<Map>(
                              context: context,
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25),
                                ),
                              ),
                              backgroundColor: Colors.white,
                              builder: (BuildContext context) =>
                                  FilterModalContent(
                                isService: true,
                                initialValues: {
                                  for (var i = 0; i < keyzS.length; i++)
                                    keyzS[i]: selectedFilters.value[keyzS[i]]
                                },

                                ///FILTRES
                                //////
                                //////SERVICES
                                locationsS: filters.value['locationsS'],
                                delais: filters.value['delais'],
                                englishLevels: filters.value['english-levels'],
                                categoriesS: filters.value['categoriesS'],
                                //////PROJECTS
                                locationsP: filters.value['locationsP'],
                                languages: filters.value['languages'],
                                categoriesP: filters.value['categoriesP'],
                              ),
                            );

                            print('filter MAP: ' + filterMap.toString());
                            if (filterMap['didApply']) {
                              selectedFilters.value = (Map.from({
                                'price-minS': filterMap['price-minS'],
                                'price-maxS': filterMap['price-maxS'],
                              })
                                ..addAll(selectedFilters.value)
                                ..addAll(
                                  {
                                    for (var i = 0; i < keyzS.length; i++)
                                      keyzS[i]: filterMap[keyzS[i]]
                                  },
                                ));

                              setState(() {
                                futureServices = fetchServices();
                              });
                            }
                          },
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
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            final respBody = snapshot.data;
                            return SingleChildScrollView(
                              padding: EdgeInsets.fromLTRB(2.5, 0, 2.5, 30),
                              child: Column(
                                children: [
                                  for (var i = 0; i < respBody.length; i++)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.5),
                                      child: ServiceCard(
                                        freelancerId: respBody[i]['author_id'],
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
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(kPrimaryColor),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
