import 'package:dezon/constants.dart';
import 'package:dezon/views/userProfile.dart';
import 'package:dezon/views/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final padding = EdgeInsets.symmetric(horizontal: 20);
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
                  backgroundImage:
                      NetworkImage(url ?? "https://via.placeholder.com/150")),
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
      appBar: AppBar(
        centerTitle: true,
        title: ElevatedButton(
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
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Container(
            color: Colors.black12,
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
                                onClicked: () {
                                   

                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Déconnexion"),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginScreen(),
                                        ),
                                      );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: [
        Center(
          child: Text(
            'Accueil',
            style: optionStyle.copyWith(color: kPrimaryColor.withOpacity(0.8)),
          ),
        ),
        Center(
          child: Text(
            'Emplois',
            style: optionStyle,
          ),
        ),
        Center(
          child: Text(
            'Freelancers',
            style: optionStyle,
          ),
        ),
        //Freelancers(),
        Center(
          child: Text(
            'Entreprises',
            style: optionStyle,
          ),
        ),
      ][_selectedIndex],
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
            icon: Icon(Icons.library_books_outlined),
            label: 'Emplois',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline_rounded),
            label: 'Freelancer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'Entreprise',
          ),
        ],
      ),
    );
  }
}
