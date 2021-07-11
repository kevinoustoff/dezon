import 'package:dezon/constants.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List chatUserList = [
    for (var i = 0; i < 20; i++) ...[
      "Utilisateur$i",
      "Message entrant de l'utilisateur $i",
    ]
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              children: [
                for (var i = 0; i < chatUserList.length; i += 2)
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(AppAssets.defaultProfile),
                    ),
                    title: Text(chatUserList[i]),
                    subtitle: Text(chatUserList[i + 1]),
                  )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.edit),
        backgroundColor: kPrimaryColor,
      ),
    );
  }
}
