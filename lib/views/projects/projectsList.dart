import 'dart:convert';

import 'package:dezon/views/widgets/filterModalContent.dart';
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
  ValueNotifier<bool> showSpinner = ValueNotifier(false);
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

  Future<List<Map>> fetchProjects() async {
    String url = ApiRoutes.host +
        (ApiRoutes.searchProjects) +
        (keyword.value ?? '') +
        ('&price-min=' + selectedFilters.value['price-minP'] ?? '0') +
        ('&price-max=' +
            (![null, '', '0'].contains(selectedFilters.value['price-maxP'])
                ? selectedFilters.value['price-maxP']
                : '99999999999999999999999'));
    print("L'url est $url");

    for (var i = 0; i < 3; i++) {
      final List tmp0 =
          selectedFilters.value[['locationsP', 'languages', 'categoriesP'][i]];
      for (var j = 0; j < tmp0.length; j++) {
        url +=
            ['&location=', '&language=', '&category='][i] + tmp0[j].toString();
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
      return [
        for (var i = 0; i < jsonDecode(response.body).length; i++)
          Map.from(jsonDecode(response.body)[i])
      ];
    }
    return null;
  }

  /* Future<List<Map>> fetchProjects() async {
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
  } */

  @override
  void initState() {
    fetchFilters();
    showSpinner.value = true;
    try {
      futureProjects = fetchProjects();
    } catch (e) {
      showSpinner.value = false;
    }
    showSpinner.value = false;
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
                      builder: (BuildContext context) => FilterModalContent(
                        isService: false,
                        initialValues: {
                          for (var i = 0; i < keyzP.length; i++)
                            keyzP[i]: selectedFilters.value[keyzP[i]]
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

                    //print('filter MAP: ' + filterMap.toString());
                    if (filterMap['didApply']) {
                      selectedFilters.value = (Map.from({
                        'price-minP': filterMap['price-minP'],
                        'price-maxP': filterMap['price-maxP'],
                      })
                        ..addAll(selectedFilters.value)
                        ..addAll(
                          {
                            ///PROJECTS
                            for (var i = 0; i < keyzP.length; i++)
                              keyzP[i]: filterMap[keyzP[i]]
                          },
                        ));
                      setState(() {
                        futureProjects = fetchProjects();
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
