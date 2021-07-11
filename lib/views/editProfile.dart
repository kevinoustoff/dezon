import 'package:dezon/constants.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextStyle titleStyle =
      TextStyle(fontSize: 17, fontWeight: FontWeight.w500);
  String identifiant = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
      body: Builder(
        builder: (context) => Form(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: fullHeight(context) * 0.28,
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 8),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppAssets.category2),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey,
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
                                textInputAction: TextInputAction.done,
                                onSaved: (newValue) {},
                                initialValue: "Identifiant",
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
                                      fontWeight: FontWeight.bold),
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
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 25),
                      Text(
                        'Nom',
                        style: titleStyle,
                      ),
                      TextField(),
                      SizedBox(height: 15),
                      Text(
                        'Email',
                        style: titleStyle,
                      ),
                      TextField(),
                      SizedBox(height: 15),
                      Text(
                        'Description',
                        style: titleStyle,
                      ),
                      TextField(),
                      SizedBox(height: 15),
                      Text(
                        'Vos qualités',
                        style: titleStyle,
                      ),
                      TextField(),
                      SizedBox(height: 15),
                      Text(
                        'Téléphone',
                        style: titleStyle,
                      ),
                      TextField(),
                      SizedBox(height: 15),
                      Text(
                        'Pays',
                        style: titleStyle,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Adresse (Latitude, Longitude)',
                        style: titleStyle,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Identifiant Facebook',
                        style: titleStyle,
                      ),
                      TextField(),
                      SizedBox(height: 15),
                      Text(
                        'Identifiant Twitter',
                        style: titleStyle,
                      ),
                      TextField(),
                      SizedBox(height: 15),
                      Text(
                        'Identifiant LinkedIn',
                        style: titleStyle,
                      ),
                      TextField(),
                      SizedBox(height: 15),
                      Text(
                        'Identifiant Instagram',
                        style: titleStyle,
                      ),
                      TextField(),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
