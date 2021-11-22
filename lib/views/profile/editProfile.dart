import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:dezon/components/dataConnectionChecker.dart';
import 'package:dezon/constants.dart';

import 'package:http/http.dart' as http;

class Item {
  Item({
    @required this.expandedValue,
    @required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}

class EditProfile extends StatefulWidget {
  final Map infos;
  final bool part2;
  EditProfile({
    this.infos,
    this.part2 = false,
  });
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextStyle titleStyle =
      TextStyle(fontSize: 17, fontWeight: FontWeight.w500);
  String identifiant = "";

  final List<Item> _data = <Item>[
    Item(
        isExpanded: true,
        headerValue: 'Compétences',
        expandedValue: "Graphic Designer"),
    Item(
        headerValue: 'Récompenses ou prix gagnés',
        expandedValue: "Graphic Designer"),
    Item(headerValue: 'Projets réalisés', expandedValue: "Graphic Designer"),
    Item(headerValue: "Expériences", expandedValue: "Graphic Designer"),
    Item(headerValue: "Education", expandedValue: "Graphic Designer"),
  ];

  List<String> sectionsUrls = [
    ApiRoutes.sectionEnglishLevels,
    ApiRoutes.sectionLanguesPrestataires,
    ApiRoutes.sectionLocations,
    ApiRoutes.sectionSexes,
    ApiRoutes.sectionTypesPrestataires,
  ];
  List<String> sectionsTitles = [
    'english-levels',
    'langues-prestataires',
    'locations',
    'sexes',
    'types-prestataires',
  ];
  ValueNotifier<Map> changes;

  Future<Map> fetchSections() async {
    Map response = {
      'hasConnection': false,
      'ok': 0,
    };
    if (await DataConnectionChecker().hasConnection) {
      response['hasConnection'] = true;
      for (var i = 0; i < sectionsUrls.length; i++) {
        var resp = await http.get(
          Uri.parse(ApiRoutes.host + sectionsUrls[i]),
        );
        /* print("Response Status code: ${resp.statusCode}");
        print("Response body: ${resp.body}"); */
        if (resp.statusCode.toString().startsWith('20')) {
          response['ok'] += 1;
          response[sectionsTitles[i]] = jsonDecode(resp.body);
        }
      }
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modification Profil'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfile(),
                ),
              );
            },
            icon: Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 35,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: widget.part2
          ? SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      setState(() {
                        _data[index].isExpanded = !isExpanded;
                      });
                    },
                    expandedHeaderPadding: EdgeInsets.all(0),
                    children: _data.map<ExpansionPanel>(
                      (Item item) {
                        return ExpansionPanel(
                          canTapOnHeader: true,
                          isExpanded: item.isExpanded,
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                            return ListTile(
                              title: Text(item.headerValue),
                            );
                          },
                          body: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.add_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    label: Text('Ajouter'),
                                  ),
                                ),
                                ListTile(
                                  title: Text(item.expandedValue),
                                  subtitle: const Text('60%'),
                                  isThreeLine: false,
                                  onTap: () {
                                    setState(() {
                                      _data.removeWhere((Item currentItem) =>
                                          item == currentItem);
                                    });
                                  },
                                  trailing: Container(
                                    padding: EdgeInsets.all(1.5),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close_rounded,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
            )
          : FutureBuilder(
              future: fetchSections(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.done) {
                  Map snapD = snap.data;
                  if (snapD['hasConnection']) {
                    if (snapD['ok'] == 4) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Nous n'avons pas pu récupérer toutes les informations. Veuillez réessayer s'il vous plaît.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              onPressed: () => setState(() {}),
                              child: Text('Réessayer'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      ///LEVELS
                      final List<String> levelsList = [
                        for (var i = 0; i < snapD['english-levels'].length; i++)
                          snapD['english-levels'][i]['name'],
                      ];
                      final ValueNotifier<String> levelChoosed =
                          ValueNotifier<String>(
                              snapD['english-levels'][0]['name']);

                      ///LANGUAGES
                      final List<String> languagesList = [
                        for (var i = 0;
                            i < snapD['langues-prestataires'].length;
                            i++)
                          snapD['langues-prestataires'][i]['name'],
                      ];
                      final ValueNotifier<
                          String> languageChoosed = ValueNotifier<String>(widget
                              .infos[
                          'freelancer-language'] /* snapD['langues-prestataires'][0]['name'] */);

                      ///LOCATIONS
                      final List<String> locationsList = [
                        for (var i = 0; i < snapD['locations'].length; i++)
                          snapD['locations'][i]['name'],
                      ];
                      final ValueNotifier<
                          String> locationChoosed = ValueNotifier<String>(widget
                              .infos[
                          'freelancer-locations'] /* snapD['locations'][0]['name'] */);

                      ///SEXES
                      final List<String> sexesList = [
                        for (var i = 0; i < snapD['sexes'].length; i++)
                          snapD['sexes'][i]['libelle'],
                      ];
                      final ValueNotifier<String> sexChoosed =
                          ValueNotifier<String>(widget.infos[
                              'sexe'] /* snapD['sexes'][0]['libelle'] */);

                      ///TYPES
                      final List<String> typesList = [
                        for (var i = 0;
                            i < snapD['types-prestataires'].length;
                            i++)
                          snapD['types-prestataires'][i]['name'],
                      ];
                      final ValueNotifier<String> typeChoosed =
                          ValueNotifier<String>(snapD['types-prestataires']
                              [(snapD['types-prestataires'].indexWhere(
                        (elt) =>
                            elt['id'].toString() ==
                            widget.infos['freelance-type'],
                      ))]['name'] /* snapD['types-prestataires'][0]['name'] */);

                      ///THE VIEW
                      return Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: fullHeight(context) * 0.25,
                                padding:
                                    const EdgeInsets.fromLTRB(15, 20, 15, 8),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(AppAssets.category2),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.grey,
                                          backgroundImage: (widget.infos[
                                                      'freelance-photo-profile'] !=
                                                  null)
                                              ? NetworkImage(widget.infos[
                                                  'freelance-photo-profile'])
                                              : AssetImage(
                                                  AppAssets.defaultProfile),
                                          child: Icon(
                                            Icons.edit_outlined,
                                            color: Colors.white,
                                            size: 50,
                                          ),
                                        ),
                                        SizedBox(width: 25),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.all(15),
                                            color: Colors.white,
                                            child: TextFormField(
                                              validator: (value) {
                                                return;
                                              },
                                              textInputAction:
                                                  TextInputAction.done,
                                              onSaved: (newValue) {},
                                              initialValue:
                                                  widget.infos['display-name'],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 25),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {},
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.edit,
                                              ),
                                              Text(
                                                'Changer',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 25),
                                    Text(
                                      'Nom',
                                      style: titleStyle,
                                    ),
                                    TextFormField(
                                      initialValue:
                                          widget.infos['user-nicename'],
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Email',
                                      style: titleStyle,
                                    ),
                                    TextFormField(
                                      initialValue: widget.infos['user-email'],
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Vos qualités',
                                      style: titleStyle,
                                    ),
                                    TextFormField(
                                      initialValue: "",
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Téléphone',
                                      style: titleStyle,
                                    ),
                                    TextFormField(
                                      initialValue: widget.infos['contact'],
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Sexe',
                                      style: titleStyle,
                                    ),
                                    ValueListenableBuilder<String>(
                                      valueListenable: sexChoosed,
                                      builder: (BuildContext context,
                                          String value, Widget child) {
                                        return DropdownButton(
                                          value: value,
                                          isExpanded: true,
                                          items: sexesList.map((String items) {
                                            return DropdownMenuItem(
                                                value: items,
                                                child: Text(
                                                  items,
                                                  textAlign: TextAlign.center,
                                                ));
                                          }).toList(),
                                          onChanged: (String newValue) {
                                            sexChoosed.value = newValue;
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Type de Jobeur',
                                      style: titleStyle,
                                    ),
                                    ValueListenableBuilder<String>(
                                      valueListenable: typeChoosed,
                                      builder: (BuildContext context,
                                          String value, Widget child) {
                                        return DropdownButton(
                                          value: value,
                                          isExpanded: true,
                                          items: typesList.map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(
                                                items,
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String newValue) {
                                            typeChoosed.value = newValue;
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Langue du prestataire',
                                      style: titleStyle,
                                    ),
                                    ValueListenableBuilder<String>(
                                      valueListenable: languageChoosed,
                                      builder: (BuildContext context,
                                          String value, Widget child) {
                                        return DropdownButton(
                                          value: value,
                                          isExpanded: true,
                                          items:
                                              languagesList.map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(
                                                items,
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String newValue) {
                                            languageChoosed.value = newValue;
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Niveau de Langue',
                                      style: titleStyle,
                                    ),
                                    ValueListenableBuilder<String>(
                                      valueListenable: levelChoosed,
                                      builder: (BuildContext context,
                                          String value, Widget child) {
                                        return DropdownButton(
                                          value: value,
                                          isExpanded: true,
                                          items: levelsList.map((String items) {
                                            return DropdownMenuItem(
                                                value: items,
                                                child: Text(
                                                  items,
                                                  textAlign: TextAlign.center,
                                                ));
                                          }).toList(),
                                          onChanged: (String newValue) {
                                            levelChoosed.value = newValue;
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Localisation',
                                      style: titleStyle,
                                    ),
                                    ValueListenableBuilder<String>(
                                      valueListenable: locationChoosed,
                                      builder: (BuildContext context,
                                          String value, Widget child) {
                                        return DropdownButton(
                                          value: value,
                                          isExpanded: true,
                                          items:
                                              locationsList.map((String items) {
                                            return DropdownMenuItem(
                                                value: items,
                                                child: Text(
                                                  items,
                                                  textAlign: TextAlign.center,
                                                ));
                                          }).toList(),
                                          onChanged: (String newValue) {
                                            locationChoosed.value = newValue;
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Description',
                                      style: titleStyle,
                                    ),
                                    TextFormField(
                                      initialValue: '',
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Adresse (Latitude, Longitude)',
                                      style: titleStyle,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(child: TextFormField()),
                                        SizedBox(width: 30),
                                        Expanded(child: TextFormField()),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Identifiant Facebook',
                                      style: titleStyle,
                                    ),
                                    TextFormField(
                                      initialValue: '',
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Identifiant Twitter',
                                      style: titleStyle,
                                    ),
                                    TextFormField(
                                      initialValue: '',
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Identifiant LinkedIn',
                                      style: titleStyle,
                                    ),
                                    TextFormField(
                                      initialValue: '',
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Identifiant Instagram',
                                      style: titleStyle,
                                    ),
                                    TextFormField(
                                      initialValue: '',
                                    ),
                                    SizedBox(height: 15),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }
                  if (!snapD['hasConnection']) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            noConnectionText,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: () => setState(() {}),
                            child: Text('Réessayer'),
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
    );
  }
}
