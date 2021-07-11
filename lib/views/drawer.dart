import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'homePage.dart';
import 'loginScreen.dart';
import 'userProfile.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  ValueNotifier<int> userId = ValueNotifier(-888);

  Widget buildHeader({String url, String nom, String identifiant, int id}) =>
      GestureDetector(
        onTap: () {
          if (![null, -888].contains(id)) {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserProfile(
                  id: id,
                ),
              ),
            );
          }
        },
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(AppAssets.defaultProfile),
            //NetworkImage(url ?? "https://via.placeholder.com/150"),
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
  }) {
    final color = Colors.black;
    final hoverColor = Colors.white70;

    return ListTile(
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
                    );
                  }
                  return buildHeader();
                },
              ),
              Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: padding,
                        child: Column(
                          children: [
                            buildMenuItem(
                              text: 'Mon profil',
                              icon: Icons.verified_user,
                              onClicked: () {
                                if (![null, -888].contains(userId.value)) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => UserProfile(
                                        id: userId.value,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            buildMenuItem(
                              text: 'Portefeuille',
                              icon: Icons.credit_card,
                              onClicked: () {},
                            ),
                            buildMenuItem(
                              text: 'Enregistrés',
                              icon: Icons.bookmark,
                              onClicked: () {},
                            ),
                            buildMenuItem(
                              text: 'Paramètres',
                              icon: Icons.settings,
                              onClicked: () {},
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
                      homePageScaffoldKey.currentState.openEndDrawer();
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
