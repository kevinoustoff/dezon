import 'package:flutter/material.dart';
import 'package:dezon/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'widgets/filterModalContent.dart';
import 'widgets/projectCard.dart';
import 'widgets/serviceCard.dart';
import 'services/serviceDetailsScreen.dart';

/* import 'package:flutter/services.dart';
SystemChannels.textInput.invokeMethod('TextInput.hide'); */

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController;
  ValueNotifier<bool> showSpinner = ValueNotifier(false);
  ValueNotifier<int> chipValue = ValueNotifier(0);
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
  Future<List<Map>> futureServices, futureProjects;

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

  //final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _searchController = TextEditingController();
    //fetchFilters();
    try {
      futureServices = searchStuff(isService: true);
    } catch (e) {}
    //futureProjects = searchStuff(isService: false);
    super.initState();
  }

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

  Future<List<Map>> searchStuff({@required bool isService}) async {
    String url = ApiRoutes.host +
        (isService ? ApiRoutes.searchServices : ApiRoutes.searchProjects) +
        (keyword.value ?? '') +
        ('&price-min=' +
                selectedFilters
                    .value[isService ? 'price-minS' : 'price-minP'] ??
            '0') +
        ('&price-max=' +
            (![null, '', '0'].contains(selectedFilters
                    .value[isService ? 'price-maxS' : 'price-maxP'])
                ? selectedFilters.value[isService ? 'price-maxS' : 'price-maxP']
                : '99999999999999999999999'));
    print("L'url est $url");

    if (isService) {
      for (var i = 0; i < 4; i++) {
        final List tmp0 = selectedFilters.value[[
          'locationsS',
          'delais',
          'english-levels',
          'categoriesS'
        ][i]];
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
    } else {
      for (var i = 0; i < 3; i++) {
        final List tmp0 = selectedFilters
            .value[['locationsP', 'languages', 'categoriesP'][i]];
        for (var j = 0; j < tmp0.length; j++) {
          url += ['&location=', '&language=', '&category='][i] +
              tmp0[j].toString();
        }
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
      if (isService)
        return [
          for (var i = 0; i < jsonDecode(response.body).length; i++)
            Map.from(jsonDecode(response.body)[i])
        ];
      else
        return [
          for (var i = 0; i < jsonDecode(response.body).length; i++)
            Map.from(jsonDecode(response.body)[i])
        ];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: kPrimaryColor),
        title: ValueListenableBuilder(
            valueListenable: showSpinner,
            builder: (context, showSpi, _) {
              return ValueListenableBuilder(
                valueListenable: chipValue,
                builder: (context, dChip, child) => TextField(
                  controller: _searchController,
                  autofocus: true,
                  enabled: !showSpi,
                  onSubmitted: (val) async {
                    if (val != null && val != '') {
                      keyword.value = val ?? '';
                      showSpinner.value = true;
                      await searchStuff(isService: dChip == 0);
                      showSpinner.value = false;
                    }
                  },
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    suffix: GestureDetector(
                      child: Icon(
                        Icons.close,
                      ),
                      onTap: () => _searchController.clear(),
                    ),
                    hintText: "Entrez votre besoin...",
                  ),
                ),
              );
            }),
      ),
      body: ValueListenableBuilder(
        valueListenable: chipValue,
        builder: (context, chipV, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ChoiceChip(
                      label: Text('Services'),
                      selected: chipValue.value == 0,
                      onSelected: (bool selected) =>
                          chipValue.value = selected ? 0 : null,
                    ),
                    ChoiceChip(
                      label: Text('Projets'),
                      selected: chipValue.value == 1,
                      onSelected: (bool selected) =>
                          chipValue.value = selected ? 1 : null,
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
                            isService: chipValue.value == 0,
                            initialValues: (chipValue.value == 0)
                                ? {
                                    for (var i = 0; i < keyzS.length; i++)
                                      keyzS[i]: selectedFilters.value[keyzS[i]]
                                  }
                                : {
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
                          selectedFilters.value =
                              (Map.from(filterMap['isService']
                                  ? {
                                      'price-minS': filterMap['price-minS'],
                                      'price-maxS': filterMap['price-maxS'],
                                    }
                                  : {
                                      'price-minP': filterMap['price-minP'],
                                      'price-maxP': filterMap['price-maxP'],
                                    })
                                ..addAll(selectedFilters.value)
                                ..addAll(
                                  filterMap['isService']
                                      ? {
                                          for (var i = 0; i < keyzS.length; i++)
                                            keyzS[i]: filterMap[keyzS[i]]
                                        }
                                      : {
                                          ///PROJECTS
                                          for (var i = 0; i < keyzP.length; i++)
                                            keyzP[i]: filterMap[keyzP[i]]
                                        },
                                ));
                          await searchStuff(isService: filterMap['isService']);
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
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, BoxConstraints viewportConstraints) =>
                      SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 75),
                    child: chipV == 0
                        ? FutureBuilder<List<Map>>(
                            future: futureServices,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                final respBody = snapshot.data;
                                if (respBody != null) {
                                  return Column(
                                    children: [
                                      for (var i = 0; i < respBody.length; i++)
                                        GestureDetector(
                                          onTap: () =>
                                              Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ServiceDetailsScreen(
                                                id: "1",
                                              ),
                                            ),
                                          ),
                                          child: ServiceCard(
                                            freelancerId: respBody[i]
                                                ['author_id'],
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
                                  );
                                } else {
                                  return ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: viewportConstraints.maxHeight,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "La recherche n'a pas aboutie suite à une erreur. Veuillez réessayer ultérieurement.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ),
                                  );
                                }
                              }
                              return ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: viewportConstraints.maxHeight,
                                ),
                                child: NoDataFound(),
                              );
                            },
                          )
                        : FutureBuilder<List<Map>>(
                            future: futureProjects,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                final respBody = snapshot.data;
                                if (respBody != null) {
                                  return Column(
                                    children: [
                                      for (var i = 0; i < respBody.length; i++)
                                        ProjectCard(
                                          freelancerId: respBody[i]
                                              ['author_id'],
                                          id: respBody[i]["id"],
                                          estimatedHours: respBody[i]
                                              ["estimated_hours"],
                                          hourlyPrice: respBody[i]
                                              ["hourly_price"],
                                          cost: respBody[i]["cost"],
                                          employerName: respBody[i]
                                              ["employer_name"],
                                          duration: respBody[i]["duration"],
                                          level: respBody[i]["level"],
                                          freelancerType: respBody[i]
                                              ["freelancer_type"],
                                          projectExpiry: respBody[i]
                                              ["project_expiry"],
                                          title: respBody[i]["title"],
                                          description: respBody[i]
                                              ["description"],
                                          savedSkills: respBody[i]
                                              ["saved_skills"],
                                          offres:
                                              respBody[i]["offres"].toString(),
                                          location: respBody[i]["location"],
                                        ),
                                    ],
                                  );
                                } else {
                                  return ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: viewportConstraints.maxHeight,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "La recherche n'a pas aboutie suite à une erreur. Veuillez réessayer ultérieurement.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ),
                                  );
                                }
                              }
                              return ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: viewportConstraints.maxHeight,
                                ),
                                child: NoDataFound(),
                              );
                            },
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class NoDataFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Aucun résultat trouvé"),
    );
  }
}
