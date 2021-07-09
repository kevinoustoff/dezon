import 'package:dezon/constants.dart';
import 'package:dezon/views/userProfile.dart';
import 'package:dezon/views/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  bool showSpinner = false;
  final padding = EdgeInsets.symmetric(horizontal: 20);
  final List<String> menuLabels = [
    'Accueil',
    'Services',
    'Projets',
    'Messagerie',
  ];
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildHeader({String url, String nom, String identifiant, int id}) =>
      GestureDetector(
        onTap: () {
          if (id != null) {
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
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 15)),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(AppAssets.defaultProfile),
                //NetworkImage(url ?? "https://via.placeholder.com/150"),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nom ?? "..",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    identifiant ?? "..",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: _selectedIndex == 0
            ? ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.black26,
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.fromLTRB(30, 5, 0, 5),
                  ),
                ),
                onPressed: () {},
                child: Row(
                  //mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 10),
                    Text(
                      "Je cherche..",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              )
            : Text(menuLabels[_selectedIndex]),
      ),
      drawer: Drawer(
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
                                text: 'Portefeuille',
                                icon: Icons.credit_card,
                                onClicked: () {},
                              ),
                              buildMenuItem(
                                text: 'Mon profil',
                                icon: Icons.verified_user,
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
                      setState(() => showSpinner = true);
                      try {
                        _scaffoldKey.currentState.openEndDrawer();
                        bool dataCleared =
                            await (await SharedPreferences.getInstance())
                                .clear();
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
                      setState(() => showSpinner = false);
                    },
                  ),
                ),
              ],
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
        child: Builder(
          builder: (context) => Center(
            child: Text(
              menuLabels[_selectedIndex],
              style: optionStyle,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 6,
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryColor,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.black54,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            label: 'Projets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            label: 'Messagerie',
          ),
        ],
      ),
    );
  }
}
