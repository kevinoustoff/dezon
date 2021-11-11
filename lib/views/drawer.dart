import 'package:dezon/views/profile/identityCheckScreen.dart';
import 'package:dezon/views/pageInProgress.dart';
import 'package:dezon/views/profile/reportsScreen.dart';
import 'package:dezon/views/profile/settingsScreen.dart';
import 'package:dezon/views/projects/post_project.dart';
import 'package:dezon/views/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'auth/loginScreen.dart';
import 'profile/userProfile.dart';
import 'projects/my_projects.dart';
import 'projects/savedProjects.dart';
import 'services/my_services.dart';
import 'services/saved_services.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  ValueNotifier<int> userId = ValueNotifier(-888);

  Widget buildHeader({
    String url,
    String nom,
    String identifiant,
    int id,
    String photo,
  }) =>
      GestureDetector(
        onTap: () {
          if (![null, -888].contains(id)) {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserProfile(
                  id: id,
                  canEdit: true,
                ),
              ),
            );
          }
        },
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
            backgroundImage: (![null, ""].contains(photo))
                ? NetworkImage(photo)
                : AssetImage(AppAssets.defaultProfile),
          ),
          title: Text(
            nom ?? "..",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Text(
            identifiant ?? "..",
            style: TextStyle(fontSize: 14),
          ),
        ),
      );

  Widget buildMenuItem({
    @required String text,
    @required IconData icon,
    @required Function onClicked,
    bool division = false,
  }) {
    final color = Colors.black;
    final hoverColor = Colors.white70;

    return ListTile(
      isThreeLine: false,
      dense: division,
      contentPadding: EdgeInsets.all(0),
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 8),
          color: Colors.white,
          child: Column(
            children: [
              FutureBuilder(
                future: SharedPreferences.getInstance(),
                builder: (context, snapshot) {
                  if ((snapshot.connectionState == ConnectionState.done) &&
                      snapshot.hasData) {
                    userId.value = snapshot.data.getInt('ID');
                    return buildHeader(
                      id: snapshot.data.getInt('ID'),
                      identifiant: "Mon profil",
                      nom: snapshot.data.getString('user_nicename'),
                      photo: snapshot.data.getString('freelance-photo-profile'),
                    );
                  }
                  return buildHeader();
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: padding,
                        child: Column(
                          children: [
                            buildMenuItem(
                              text: 'Mon profil',
                              icon: Icons.account_circle_outlined,
                              onClicked: () {
                                if (![null, -888].contains(userId.value)) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => UserProfile(
                                        id: userId.value,
                                        canEdit: true,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            buildMenuItem(
                              text: 'Portefeuille',
                              icon: Icons.credit_card_outlined,
                              onClicked: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PageInProgress(),
                                  ),
                                );
                              },
                            ),
                            ExpansionTile(
                              leading: Icon(
                                Icons.library_books_outlined,
                                color: Colors.black,
                              ),
                              tilePadding: EdgeInsets.all(0),
                              title: Text(
                                'Mes Projets',
                                style: TextStyle(
                                  //fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 25.0),
                                  child: Column(
                                    children: [
                                      buildMenuItem(
                                        text: 'Afficher',
                                        icon: Icons.visibility_outlined,
                                        onClicked: () async {
                                          final mUserId =
                                              (await SharedPreferences
                                                      .getInstance())
                                                  .getInt('ID');
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => MyProjects(
                                                userId: mUserId,
                                              ),
                                            ),
                                          );
                                        },
                                        division: true,
                                      ),
                                      buildMenuItem(
                                        text: 'Publier',
                                        icon: Icons.add,
                                        onClicked: () async {
                                          final mUserId =
                                              (await SharedPreferences
                                                      .getInstance())
                                                  .getInt('ID');
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => PostProject(
                                                userId: mUserId,
                                              ),
                                            ),
                                          );
                                        },
                                        division: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            ExpansionTile(
                              leading: Icon(
                                Icons.work_outline,
                                color: Colors.black,
                              ),
                              tilePadding: EdgeInsets.all(0),
                              title: Text(
                                'Mes Services',
                                style: TextStyle(
                                  //fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 25.0),
                                  child: Column(
                                    children: [
                                      buildMenuItem(
                                        text: 'Afficher',
                                        icon: Icons.visibility_outlined,
                                        onClicked: () async {
                                          final mUserId =
                                              (await SharedPreferences
                                                      .getInstance())
                                                  .getInt('ID');
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => MyServices(
                                                userId: mUserId,
                                              ),
                                            ),
                                          );
                                        },
                                        division: true,
                                      ),
                                      buildMenuItem(
                                        text: 'Publier',
                                        icon: Icons.add,
                                        onClicked: () async {
                                          final mUserId =
                                              (await SharedPreferences
                                                      .getInstance())
                                                  .getInt('ID');
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PostService(userId: mUserId),
                                            ),
                                          );
                                        },
                                        division: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            ExpansionTile(
                              leading: Icon(
                                Icons.bookmark_outline,
                                color: Colors.black,
                              ),
                              tilePadding: EdgeInsets.all(0),
                              title: Text(
                                'Enregistrés',
                                style: TextStyle(
                                  //fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 25.0),
                                  child: Column(
                                    children: [
                                      buildMenuItem(
                                        text: 'Projets',
                                        icon: Icons.library_books_outlined,
                                        onClicked: () async {
                                          final mUserId =
                                              (await SharedPreferences
                                                      .getInstance())
                                                  .getInt('ID');
                                          if (mUserId != null) {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SavedProjects(
                                                  userId: mUserId.toString(),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      buildMenuItem(
                                        text: 'Services',
                                        icon: Icons.work_outline,
                                        onClicked: () async {
                                          final mUserId =
                                              (await SharedPreferences
                                                      .getInstance())
                                                  .getInt('ID');
                                          if (mUserId != null) {
                                            Navigator.of(context).pop();
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SavedServices(
                                                  userId: mUserId.toString(),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            buildMenuItem(
                              text: "Litiges",
                              icon: Icons.report_outlined,
                              onClicked: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ReportsScreen(),
                                  ),
                                );
                              },
                            ),
                            buildMenuItem(
                              text: "Vérification de l'identité",
                              icon: Icons.check_circle_outline,
                              onClicked: () async {
                                final mUserId =
                                    (await SharedPreferences.getInstance())
                                        .getInt('ID');
                                if (mUserId != null) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => IdentityCheckScreen(
                                        id: mUserId.toString(),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            buildMenuItem(
                              text: 'Réglages',
                              icon: Icons.settings_outlined,
                              onClicked: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SettingsScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(thickness: 2),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        color: Colors.red,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Déconnexion",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  onTap: () async {
                    //setState(() => showSpinner = true);
                    try {
                      Navigator.of(context).pop();
                      bool dataCleared =
                          await (await SharedPreferences.getInstance()).clear();
                      if (dataCleared) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "La déconnexion a échouée. Veuillez fermer l'application et réessayer.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    //setState(() => showSpinner = false);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
