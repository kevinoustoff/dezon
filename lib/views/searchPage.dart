import 'package:flutter/material.dart';
import 'package:dezon/constants.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert';

import 'filterModalContent.dart';
import 'projectCard.dart';
import 'serviceCard.dart';
import 'serviceDetailsScreen.dart';

/* import 'package:flutter/services.dart';
SystemChannels.textInput.invokeMethod('TextInput.hide'); */

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool showSpinner = false;
  TextEditingController _searchController;
  ValueNotifier<int> chipValue = ValueNotifier(0);
  ValueNotifier<String> keyword = ValueNotifier("");
  ValueNotifier<String> priceMinFilter = ValueNotifier("");
  ValueNotifier<String> priceMaxFilter = ValueNotifier("");
  ValueNotifier<String> projectRequest = ValueNotifier("");
  ValueNotifier<List<Map>> servicesData = ValueNotifier([]);
  ValueNotifier<List<Map>> projectsData = ValueNotifier([]);
  //final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  showErrorMessage() => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "La recherche n'a pas aboutie en raison d'une erreur. Veuillez réessayer ultérieurement."),
        ),
      );

  Future<void> searchStuff({@required bool isService}) async {
    final String url = ApiRoutes.host +
        (isService ? ApiRoutes.searchServices : ApiRoutes.searchProjects) +
        (keyword.value ?? '') +
        ('&price-min=' + priceMinFilter.value ?? '0') +
        ('&price-max=' + priceMaxFilter.value ?? '');
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
        servicesData.value = [
          for (var i = 0; i < jsonDecode(response.body).length; i++)
            Map.from(jsonDecode(response.body)[i])
        ];
      else
        projectsData.value = [
          for (var i = 0; i < jsonDecode(response.body).length; i++)
            Map.from(jsonDecode(response.body)[i])
        ];
      return;
    }
    if (isService) {
      servicesData.value = null;
    } else {
      projectsData.value = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: kPrimaryColor),
        title: ValueListenableBuilder(
          valueListenable: chipValue,
          builder: (context, dChip, child) => TextField(
            controller: _searchController,
            autofocus: true,
            onSubmitted: (val) async {
              if (val != null && val != '') {
                keyword.value = val ?? '';
                setState(() => showSpinner = true);
                await searchStuff(isService: dChip == 0);
                setState(() => showSpinner = false);
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
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        color: Colors.brown,
        dismissible: true,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
        ),
        child: ValueListenableBuilder(
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
                            builder: (BuildContext context) =>
                                FilterModalContent(
                              isService: chipValue.value == 0,
                            ),
                          );
                          if (filterMap['didApply']) {
                            if (filterMap['priceMin'] != 0) {
                              priceMinFilter.value =
                                  filterMap['priceMin'].toString();
                            }
                            if (filterMap['priceMax'] != 0) {
                              priceMaxFilter.value =
                                  filterMap['priceMax'].toString();
                            }
                            setState(() => showSpinner = true);
                            await searchStuff(
                                isService: filterMap['isService']);
                            setState(() => showSpinner = false);
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
                          ? ValueListenableBuilder(
                              valueListenable: servicesData,
                              builder: (context, respBody, _) {
                                if (respBody != null && respBody.isNotEmpty) {
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
                                }
                                if (respBody == null) showErrorMessage();
                                return ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: viewportConstraints.maxHeight,
                                  ),
                                  child: NoDataFound(),
                                );
                              },
                            )
                          : ValueListenableBuilder(
                              valueListenable: projectsData,
                              builder: (context, respBody, _) {
                                if (respBody != null && respBody.isNotEmpty) {
                                  return Column(
                                    children: [
                                      for (var i = 0; i < respBody.length; i++)
                                        ProjectCard(
                                          estimatedHours: respBody[i]
                                              ["estimated_hours"],
                                          hourlyPrice: respBody[i]
                                              ["hourly_price"],
                                          cost: respBody[i]["cost"],
                                          id: respBody[i]["id"],
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
                                }
                                if (respBody == null) showErrorMessage();
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
