import 'package:flutter/material.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String id;
  ServiceDetailsScreen({@required this.id});
  @override
  _ServiceDetailsScreenState createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    TextStyle aStyle = const TextStyle(color: Colors.black54);
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du service'),
        actions: [
          TextButton(
            onPressed:
                /* () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MakeOfferScreen(),
              ),
            ), */
                () {},
            child: Text(
              'PAYER',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Délai de livraison",
                        style: aStyle,
                      ),
                      Text("Entre 1 et 3 jours"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Temps de réponse",
                        style: aStyle,
                      ),
                      Text("5 H"),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Niveau",
                      style: aStyle,
                    ),
                    Text("Professionnel"),
                  ],
                ),
                /* Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Languages",
                      style: aStyle,
                    ),
                    Text("Anglais Arabe Espagnol"),
                  ],
                ), */
              ],
            ),
            Divider(
              thickness: 1,
            ),
            Text(
              "Création de Logo Impressionnantes et modernes",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            Wrap(
              spacing: 15,
              children: [
                Text(
                  'À partir de',
                ),
                Text(
                  "5 000 FCFA",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      'Jason',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              "Créer un logo est un service qui prend du temps. Ainsi, afin de vous garantir une qualité de conception que j’estime correcte, je vous propose de prendre le Pack Smart à 20 €. La création de votre logo sera ainsi plus complète que celle offerte par le service à 5,00 €.\n\n►►Pour le moindre coût de 5000 F CFA je vous propose la conception de 2 propositions modernes, et cela à partir d'une image prise sur le web ou sur gabarit. Vous devrez vous-même me fournir cette image(s).\n\n►►► Mon Service de base comprend :\n2 Propositions de logo en format JPEG uniquement\n2 modifications (changement de couleur, police ou d'emplacement...)\nFormat (700x700 px), Résolution Standard 72 dpi\nFormat PNG transparente n'est pas incluse.\n►►► Pour un résultat plus affiné, je vous propose d'explorer mes autres Pack ci-dessous :\n",
            ),
            SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}
