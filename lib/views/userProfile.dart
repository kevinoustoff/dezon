import 'dart:convert';

import 'package:dezon/views/modifyPassword.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import 'editProfile.dart';

List userDetails = [
  'Qualités',
  "Avis",
  "Membre depuis",
];

class UserProfile extends StatefulWidget {
  final int id;
  UserProfile({@required this.id});
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  ValueNotifier<Map> infos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Profil'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.edit_rounded),
            onSelected: (value) {
              switch (value) {
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfile(infos: infos.value),
                    ),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModifyPassword(),
                    ),
                  );
                  break;
                default:
              }
            },
            itemBuilder: (context) => [
              if (infos != null)
                PopupMenuItem(
                  child: Text("Modifier Informations"),
                  value: 1,
                ),
              PopupMenuItem(
                child: Text("Modifier Mot de passe"),
                value: 2,
              )
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: http.get(
          Uri.parse(
              ApiRoutes.host + ApiRoutes.showProfile + widget.id.toString()),
        ),
        builder: (context, snapshot) {
          if ((snapshot.connectionState == ConnectionState.done) &&
              snapshot.hasData) {
            var response = snapshot.data;
            if (response.statusCode.toString().startsWith('20')) {
              print("${response.body}");
              Map respBody =
                  Map.from(jsonDecode(response.body))["body_response"];
              infos = ValueNotifier(
                {
                  'freelance-photo-profile':
                      respBody['freelance-photo-profile'],
                  'user-login': Map.from(
                      Map.from(respBody['user_info'])['data'])['user_login'],
                  'user-nicename': Map.from(
                      Map.from(respBody['user_info'])['data'])['user_nicename'],
                  'display-name': Map.from(
                      Map.from(respBody['user_info'])['data'])['display_name'],
                  'user-email': Map.from(
                      Map.from(respBody['user_info'])['data'])['user_email'],
                  'user-url': Map.from(
                      Map.from(respBody['user_info'])['data'])['user_url'],
                  'sexe': respBody['sexe'],
                  'freelancer-language': respBody['freelancer-language'],
                  'freelancer-locations': respBody['freelancer-locations'],
                  'freelance-type': respBody['freelance-type'],
                  'contact': respBody['contact'],
                },
              );
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: <Widget>[
                        Container(
                          height: 280.0,
                          width: double.infinity,
                        ),
                        Container(
                          height: 100.0,
                          width: double.infinity,
                          color: Colors.grey,
                        ),
                        Positioned(
                          top: 10.0,
                          left: 15,
                          right: 15,
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  //height: 200,
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.grey,
                                          backgroundImage: (respBody[
                                                      'freelance-photo-profile'] !=
                                                  null)
                                              ? NetworkImage(respBody[
                                                  'freelance-photo-profile'])
                                              : AssetImage(
                                                  AppAssets.defaultProfile),
                                        ),
                                        title: Text(
                                          Map.from(
                                              Map.from(respBody['user_info'])[
                                                  'data'])['display_name'],
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      for (var i = 0;
                                          i < userDetails.length;
                                          i++)
                                        Card(
                                          margin: EdgeInsets.all(1),
                                          child: Container(
                                            color: Colors.white60,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  userDetails[i],
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16),
                                                ),
                                                Text(
                                                  [
                                                    "",
                                                    "",
                                                    Map.from(Map.from(respBody[
                                                                'user_info'])[
                                                            'data'])[
                                                        'user_registered'],
                                                  ][i],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            "Réalisations",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              Container(
                                //color: Colors.white70,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "0",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),
                                      ),
                                      Text(
                                        "Projets\nEn cours",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "0",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),
                                      ),
                                      Text(
                                        "Projets\nTerminés",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "0",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.deepOrangeAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),
                                      ),
                                      Text(
                                        "Projects\nAnnulés",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                //color: Colors.white70,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "0.00",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),
                                      ),
                                      Text(
                                        "Total\nGains",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            "Mes compétences",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    Builder(builder: (context) {
                      if ((respBody["freelancer-skills"] == null) ||
                          (respBody["freelancer-skills"].length == 0)) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var i = 0;
                              i < respBody["freelancer-skills"].length;
                              i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Map.from(respBody["freelancer-skills"]
                                            [i])['skill'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 17),
                                      ),
                                      Text(
                                        Map.from(respBody["freelancer-skills"]
                                            [i])['percent'],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  LinearProgressIndicator(
                                    backgroundColor: Colors.black12,
                                    value: double.parse(Map.from(
                                            respBody["freelancer-skills"]
                                                [i])['percent']) /
                                        100,
                                    minHeight: 5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFFfecc4e)),
                                  )
                                ],
                              ),
                            ),
                        ],
                      );
                    }),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            "À propos de moi",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black12,
                              ),
                              child: Icon(Icons.female_outlined),
                            ),
                            title: Text('Sexe'),
                            subtitle: Text(respBody["sexe"]),
                          ),
                          Divider(height: 1),
                          ListTile(
                            leading: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black12,
                              ),
                              child: Icon(
                                Icons.fact_check_outlined,
                              ),
                            ),
                            title: Text('Type de prestation'),
                            subtitle: Text(respBody["freelance-type"]),
                          ),
                          Divider(height: 1),
                          ListTile(
                            leading: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black12,
                              ),
                              child: Icon(Icons.location_on),
                            ),
                            title: Text('Localisation'),
                            subtitle: Text(respBody["freelancer-locations"]),
                          ),
                          Divider(height: 1),
                          ListTile(
                            leading: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black12,
                              ),
                              child: Icon(
                                Icons.language_outlined,
                              ),
                            ),
                            title: Text('Langues'),
                            subtitle: Text(respBody["freelancer-language"]),
                          ),
                          Divider(height: 1),
                        ],
                      ),
                    ),
                    SizedBox(height: 60),
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
