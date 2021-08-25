import 'package:flutter/material.dart';

import '../../constants.dart';

class MakeOfferScreen extends StatefulWidget {
  @override
  _MakeOfferScreenState createState() => _MakeOfferScreenState();
}

class _MakeOfferScreenState extends State<MakeOfferScreen> {
  TextStyle _titleStyle = TextStyle(fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faire une offre'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Montant de l'offre (en FCFA)",
              style: _titleStyle,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Text(
              "Ce projet sera livré dans (en Jours)",
              style: _titleStyle,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ),
            Text(
              "Décrivez votre proposition",
              style: _titleStyle,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                maxLines: 4,
              ),
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('PUBLIER'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
