import 'package:flutter/material.dart';

class IdentityCheckScreen extends StatefulWidget {
  @override
  _IdentityCheckScreenState createState() => _IdentityCheckScreenState();
}

class _IdentityCheckScreenState extends State<IdentityCheckScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vérification de l'identité"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Détails de la vérification",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Vous avez déjà envoyé le document de vérification. Veuillez annuler la vérification pour renvoyer.",
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
              child: Text(
                "Annuler la vérification",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
