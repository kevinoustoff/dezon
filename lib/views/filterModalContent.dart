import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class FilterModalContent extends StatefulWidget {
  final bool isService;
  final Map initialValues;
  final List locationsS,
      delais,
      englishLevels,
      categoriesS,
      locationsP,
      languages,
      categoriesP;

  FilterModalContent({
    @required this.isService,
    @required this.initialValues,

    ///SERVICE
    @required this.locationsS,
    @required this.delais,
    @required this.englishLevels,
    @required this.categoriesS,

    ///PROJECT
    @required this.locationsP,
    @required this.languages,
    @required this.categoriesP,
  });
  @override
  _FilterModalContentState createState() => _FilterModalContentState();
}

class _FilterModalContentState extends State<FilterModalContent> {
  final _formKey = GlobalKey<FormState>();
  ValueNotifier<bool> formError = ValueNotifier(false);
  List<bool> _isExpanded0 = List.generate(4, (_) => false);
  List<bool> _isExpanded1 = List.generate(5, (_) => false);
  String priceMin, priceMax;
  List locationsS = [],
      delais = [],
      englishLevels = [],
      categoriesS = [],
      locationsP = [],
      languages = [],
      categoriesP = [];

  @override
  void initState() {
    if (mounted) {
      setState(() {
        if (widget.isService) {
          priceMin = widget.initialValues['price-minS'] ?? '';
          priceMax = widget.initialValues['price-maxS'] ?? '';
          locationsS = widget.initialValues['locationsS'] ?? [];
          delais = widget.initialValues['delais'] ?? [];
          englishLevels = widget.initialValues['english-levels'] ?? [];
          categoriesS = widget.initialValues['categoriesS'] ?? [];
        } else {
          priceMin = widget.initialValues['price-minP'] ?? '';
          priceMax = widget.initialValues['price-maxP'] ?? '';
          locationsP = widget.initialValues['locationsP'] ?? [];
          languages = widget.initialValues['languages'] ?? [];
          categoriesP = widget.initialValues['categoriesP'] ?? [];
        }
      });
    } else {
      if (widget.isService) {
        priceMin = widget.initialValues['price-minS'] ?? '';
        priceMax = widget.initialValues['price-maxS'] ?? '';
        locationsS = widget.locationsS ?? [];
        delais = widget.delais ?? [];
        englishLevels = widget.englishLevels ?? [];
        categoriesS = widget.categoriesS ?? [];
      } else {
        priceMin = widget.initialValues['price-minP'] ?? '';
        priceMax = widget.initialValues['price-maxP'] ?? '';
        locationsP = widget.locationsP ?? [];
        languages = widget.languages ?? [];
        categoriesP = widget.categoriesP ?? [];
      }
    }
    super.initState();
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
                          Map.from({})
                            ..addAll(<String, dynamic>{
                              'didApply': true,
                              'isService': widget.isService,
                            })
                            ..addAll(
                              widget.isService
                                  ? {
                                      'price-minS':
                                          [null, ''].contains(priceMin)
                                              ? '0'
                                              : priceMin,
                                      'price-maxS':
                                          [null, ''].contains(priceMax)
                                              ? '0'
                                              : priceMax,
                                      'locationsS': locationsS,
                                      'delais': delais,
                                      'english-levels': englishLevels,
                                      'categoriesS': categoriesS,
                                    }
                                  : {
                                      'price-minP':
                                          [null, ''].contains(priceMin)
                                              ? '0'
                                              : priceMin,
                                      'price-maxP':
                                          [null, ''].contains(priceMax)
                                              ? '0'
                                              : priceMax,
                                      'locationsP': locationsP,
                                      'languages': languages,
                                      'categoriesP': categoriesP,
                                    },
                            ),
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
                        if (widget.isService)
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
                                                initialValue: k == 0
                                                    ? widget.initialValues[
                                                        'price-minS']
                                                    : widget.initialValues[
                                                        'price-maxS'],
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
                                            ? widget.categoriesS
                                            : i == 1
                                                ? widget.delais
                                                : (i == 3
                                                    ? widget.englishLevels
                                                    : widget.locationsS));
                                        return Column(
                                          children: [
                                            for (var j = 0; j < tmp.length; j++)
                                              CheckboxListTile(
                                                title: Text(tmp[j]['name']),
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    if (i == 0) {
                                                      if (!value) {
                                                        categoriesS.remove(
                                                            tmp[j]['term_id']);
                                                      } else
                                                        categoriesS = [
                                                          ...[
                                                            tmp[j]['term_id']
                                                          ],
                                                          ...categoriesS
                                                        ].toSet().toList();
                                                    } else if (i == 1) {
                                                      if (!value) {
                                                        delais.remove(
                                                            tmp[j]['term_id']);
                                                      } else
                                                        delais = [
                                                          ...[
                                                            tmp[j]['term_id']
                                                          ],
                                                          ...delais
                                                        ].toSet().toList();
                                                    } else if (i == 3) {
                                                      if (!value) {
                                                        englishLevels.remove(
                                                            tmp[j]['term_id']);
                                                      } else
                                                        englishLevels = [
                                                          ...[
                                                            tmp[j]['term_id']
                                                          ],
                                                          ...englishLevels
                                                        ].toSet().toList();
                                                    } else {
                                                      if (!value) {
                                                        locationsS.remove(
                                                            tmp[j]['term_id']);
                                                      } else
                                                        locationsS = [
                                                          ...[
                                                            tmp[j]['term_id']
                                                          ],
                                                          ...locationsS
                                                        ].toSet().toList();
                                                    }
                                                  });
                                                },
                                                value: (i == 0
                                                        ? categoriesS
                                                        : i == 1
                                                            ? delais
                                                            : (i == 3
                                                                ? englishLevels
                                                                : locationsS))
                                                    .contains(
                                                        tmp[j]['term_id']),
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
                        else
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
                                                initialValue: k == 0
                                                    ? widget.initialValues[
                                                        'price-minP']
                                                    : widget.initialValues[
                                                        'price-maxP'],
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
                                            ? widget.categoriesP
                                            : (i == 2
                                                ? widget.languages
                                                : widget.locationsP));
                                        return Column(
                                          children: [
                                            for (var j = 0; j < tmp.length; j++)
                                              CheckboxListTile(
                                                title: Text(tmp[j]['name']),
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    if (i == 0) {
                                                      if (!value) {
                                                        categoriesP.remove(
                                                            tmp[j]['term_id']);
                                                      } else
                                                        categoriesP = [
                                                          ...[
                                                            tmp[j]['term_id']
                                                          ],
                                                          ...categoriesP
                                                        ].toSet().toList();
                                                    } else if (i == 2) {
                                                      if (!value) {
                                                        languages.remove(
                                                            tmp[j]['term_id']);
                                                      } else
                                                        languages = [
                                                          ...[
                                                            tmp[j]['term_id']
                                                          ],
                                                          ...languages
                                                        ].toSet().toList();
                                                    } else {
                                                      if (!value) {
                                                        locationsP.remove(
                                                            tmp[j]['term_id']);
                                                      } else
                                                        locationsP = [
                                                          ...[
                                                            tmp[j]['term_id']
                                                          ],
                                                          ...locationsP
                                                        ].toSet().toList();
                                                    }
                                                  });
                                                },
                                                value: (i == 0
                                                        ? categoriesP
                                                        : (i == 2
                                                            ? languages
                                                            : locationsP))
                                                    .contains(
                                                        tmp[j]['term_id']),
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
