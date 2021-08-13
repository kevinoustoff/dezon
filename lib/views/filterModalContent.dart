import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class FilterModalContent extends StatefulWidget {
  final bool isService;
  FilterModalContent({@required this.isService});
  @override
  _FilterModalContentState createState() => _FilterModalContentState();
}

class _FilterModalContentState extends State<FilterModalContent> {
  final _formKey = GlobalKey<FormState>();
  ValueNotifier<bool> formError = ValueNotifier(false);
  List<bool> _isExpanded0 = List.generate(4, (_) => false);
  List<bool> _isExpanded1 = List.generate(5, (_) => false);
  TextEditingController _minPriceController, _maxPriceController;
  String priceMin, priceMax;
  List<String> categorieProjectList = [
    "Audio visuel",
    "Clip vidéo",
    "Jardinage",
    "Video & Animation",
    "VideoGrapher",
  ];
  List<String> categorieServiceList = [
    "Aide à la personne",
    "Livraison de matériel",
    "Audio visuel",
    "Clip vidéo",
    "Bricolage",
    "Design et graphisme",
    "Logo",
    "Plan travaux d'architecture",
    "Formation et coaching",
  ];
  List<String> delaisList = [
    "1 mois",
    "1 semaine",
    "6 mois",
    "En 1h",
    "Entre 1 et 3 jours",
    "Entre 2 et 3 mois",
  ];
  List<String> niveauxList = [
    "Débutant",
    "Intermédiaire",
    "Professionnel",
  ];
  List<String> paysServiceList = [
    "Abidjan",
    "Aného",
    "Cotonou",
    "Dakar",
    "Douala",
    "Lomé",
    "USA",
  ];
  List<String> langueList = [
    'Anglais',
    'Arabe',
    'Chinois',
    'Espagnol',
    'Français',
  ];
  List<String> paysProjectList = [
    "Bénin",
    "Mali",
    "Gao",
    "Togo",
    "Lomé",
  ];

  @override
  void initState() {
    super.initState();
    _minPriceController = TextEditingController();
    _maxPriceController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        height: fullHeight(context) - 100,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(
                      context,
                      {
                        'didApply': false,
                      },
                    ),
                    icon: Icon(Icons.arrow_back),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor)),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        Navigator.pop(
                          context,
                          {
                            'didApply': true,
                            'isService': widget.isService,
                            'priceMin': int.tryParse(priceMin ?? '0') ?? 0,
                            'priceMax': int.tryParse(priceMax ?? '0') ?? 0,
                            'languages': [],
                            'categories': [],
                            'locations': [],
                            if (widget.isService) 'delais': [],
                          },
                        );
                      } else {
                        formError.value = true;
                        await Future.delayed(Duration(seconds: 3));
                        formError.value = false;
                      }
                    },
                    child: Text("Appliquer"),
                  ),
                ],
              ),
            ),
            ValueListenableBuilder(
              valueListenable: formError,
              builder: (context, value, _) {
                return value
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          "Veuillez entrer des nombres valides.",
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      )
                    : Container();
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.fromLTRB(15, 8, 15, fullHeight(context) / 2),
                child: Column(
                  children: [
                    ExpansionPanelList(
                      expandedHeaderPadding: EdgeInsets.symmetric(vertical: 5),
                      expansionCallback: (index, isExpanded) => setState(() {
                        if (widget.isService)
                          _isExpanded1[index] = !isExpanded;
                        else
                          _isExpanded0[index] = !isExpanded;
                      }),
                      children: [
                        if (!widget.isService)
                          for (int i = 0; i < 4; i++)
                            ExpansionPanel(
                              canTapOnHeader: true,
                              body: Column(
                                children: [
                                  if (i == 1)
                                    Row(
                                      children: [
                                        for (var k = 0; k < 2; k++)
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 0, 15, 15),
                                              child: TextFormField(
                                                controller: k == 0
                                                    ? _minPriceController
                                                    : _maxPriceController,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r'[0-9]')),
                                                ],
                                                validator: numberValidator,
                                                decoration: new InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          5, 0, 0, 0),
                                                  hintText:
                                                      k == 0 ? "Min" : "Max",
                                                ),
                                                onSaved: (newValue) => setState(
                                                  () {
                                                    if (k == 0)
                                                      priceMin = newValue;
                                                    else
                                                      priceMax = newValue;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  if ([0, 2, 3].contains(i))
                                    Builder(
                                      builder: (context) {
                                        List tmp = (i == 0
                                            ? categorieProjectList
                                            : (i == 2
                                                ? langueList
                                                : paysProjectList));
                                        return Column(
                                          children: [
                                            for (var j = 0; j < tmp.length; j++)
                                              CheckboxListTile(
                                                title: Text(tmp[j]),
                                                onChanged: (bool value) {},
                                                value: false,
                                                isThreeLine: false,
                                                dense: true,
                                              ),
                                          ],
                                        );
                                      },
                                    ),
                                ],
                              ),
                              headerBuilder: (_, isExpanded) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text([
                                        "Catégorie",
                                        "Prix",
                                        "Langue(s)",
                                        "Localisation(s)"
                                      ][i]),
                                    ],
                                  ),
                                );
                              },
                              isExpanded: _isExpanded0[i],
                            )
                        else
                          for (int i = 0; i < 5; i++)
                            ExpansionPanel(
                              canTapOnHeader: true,
                              body: Column(
                                children: [
                                  if (i == 2)
                                    Row(
                                      children: [
                                        for (var k = 0; k < 2; k++)
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      15, 0, 15, 15),
                                              child: TextFormField(
                                                controller: k == 0
                                                    ? _minPriceController
                                                    : _maxPriceController,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r'[0-9]')),
                                                ],
                                                validator: numberValidator,
                                                decoration: new InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          5, 0, 0, 0),
                                                  hintText:
                                                      k == 0 ? "Min" : "Max",
                                                ),
                                                onSaved: (newValue) => setState(
                                                  () {
                                                    if (k == 0)
                                                      priceMin = newValue;
                                                    else
                                                      priceMax = newValue;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  if ([0, 1, 3, 4].contains(i))
                                    Builder(
                                      builder: (context) {
                                        List tmp = (i == 0
                                            ? categorieServiceList
                                            : i == 1
                                                ? delaisList
                                                : (i == 3
                                                    ? niveauxList
                                                    : paysServiceList));
                                        return Column(
                                          children: [
                                            for (var j = 0; j < tmp.length; j++)
                                              CheckboxListTile(
                                                title: Text(tmp[j]),
                                                onChanged: (bool value) {},
                                                value: false,
                                                isThreeLine: false,
                                                dense: true,
                                              ),
                                          ],
                                        );
                                      },
                                    ),
                                ],
                              ),
                              headerBuilder: (_, isExpanded) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text([
                                        "Catégorie",
                                        "Délai de livraison",
                                        "Prix",
                                        "Niveau de langue",
                                        "Localisation"
                                      ][i]),
                                    ],
                                  ),
                                );
                              },
                              isExpanded: _isExpanded1[i],
                            )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
