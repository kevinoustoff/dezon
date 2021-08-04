import 'package:dezon/constants.dart';
import 'package:flutter/material.dart';

import 'chatScreen.dart';
import 'drawer.dart';
import 'homePage.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List chatUserList = [
    AppAssets.category1,
    'Jason',
    'Le lien du diagramme se trouve dans le dossier prédent',
    AppAssets.category2,
    'FlashDrop',
    'Est ce possible de changer la couleur du haut ?',
    AppAssets.category3,
    'Essen Mike',
    'Fixons le délai à 4 jours',
    AppAssets.category4,
    'Bernice',
    "J'ai remarqué des erreurs dans le document",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(menuLabels[3]),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search_rounded)),
        ],
      ),
      drawer: CustomDrawer(),
      body: ((chatUserList == null) || chatUserList.isEmpty)
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                height: fullHeight(context) - 135,
                color: kPrimaryColor,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Aucun message disponible',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Vos messages s'afficheront ici \n  Utilisez le bouton du bas pour envoyer un message.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              children: [
                for (var i = 0; i < chatUserList.length; i += 3)
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(),
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: AssetImage(chatUserList[i]),
                      ),
                      title: Text(chatUserList[i + 1]),
                      subtitle: Text(chatUserList[i + 2]),
                    ),
                  )
              ],
            ),
    );
  }
}
