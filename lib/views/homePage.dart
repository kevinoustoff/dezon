import 'package:card_swiper/card_swiper.dart';
import 'package:dezon/constants.dart';
import 'package:dezon/views/chatListScreen.dart';
import 'package:dezon/views/drawer.dart';
import 'package:dezon/views/projectsList.dart';
import 'package:dezon/views/searchPage.dart';
import 'package:dezon/views/servicesList.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'serviceCard.dart';

final List<String> menuLabels = [
  'Dezon',
  'Services',
  'Projets',
  'Messagerie',
];

final TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool showSpinner = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          color: Colors.brown,
          dismissible: true,
          progressIndicator: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
          ),
          child: Builder(
            builder: (context) {
              return [
                HomeContent(),
                ServicesList(),
                ProjectsList(),
                ChatListScreen(),
              ][_selectedIndex];
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 6,
          currentIndex: _selectedIndex,
          selectedItemColor: kPrimaryColor,
          onTap: _onItemTapped,
          unselectedItemColor: Colors.black54,
          selectedFontSize: 4,
          unselectedFontSize: 4,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Text(
                  'Accueil',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline),
              activeIcon: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Text(
                  'Services',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books_outlined),
              activeIcon: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Text(
                  'Projets',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              activeIcon: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Text(
                  'Messagerie',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final List images = [
    AppAssets.category1,
    AppAssets.category2,
    AppAssets.category3,
    AppAssets.category4,
  ];
  List topWorkers = [
    AppAssets.worker1,
    'Mina Walker',
    'Comptable',
    '4.4',
    AppAssets.worker2,
    'Léon Fan',
    'Architecte',
    '4.3',
    AppAssets.worker3,
    'Dave Ruis',
    'Photographe',
    '4.2',
    AppAssets.worker4,
    'Christian Koda',
    "Développement d'Application Mobile",
    '4.1',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        /*  title: Image.asset(
          AppAssets.logo,
          //fit: BoxFit.contain,
          width: 130,
          color: kPrimaryColor,
          colorBlendMode: BlendMode.screen,
        ), */
        title: Image.asset(
          AppAssets.appIcon,
          width: 40,
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SearchPage(),
              ),
            ),
            icon: Icon(Icons.search),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nouveautés",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
            SizedBox(height: 7),
            Container(
              height: 170,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    images[index],
                    fit: BoxFit.fill,
                  );
                },
                autoplay: true,
                itemCount: images.length,
                pagination: SwiperPagination(builder: SwiperPagination.dots),
                control: SwiperControl(color: Colors.brown, size: 40),
              ),
            ),
            SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Services à la une",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
                SizedBox(height: 5),
                FutureBuilder(
                  future: http.get(
                    Uri.parse(
                      ApiRoutes.host + ApiRoutes.lastServices,
                    ),
                  ),
                  builder: (context, snapshot) {
                    if ((snapshot.connectionState == ConnectionState.done) &&
                        snapshot.hasData) {
                      var response = snapshot.data;
                      print("Status Code: " +
                          response.statusCode.toString() +
                          '\n' +
                          "Body: " +
                          "${response.body}");
                      if (response.statusCode.toString().startsWith('20')) {
                        List<Map> respBody = [
                          for (var i = 0;
                              i < jsonDecode(response.body).length;
                              i++)
                            Map.from(jsonDecode(response.body)[i])
                        ];
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              for (var i = 0;
                                  i <
                                      ((respBody.length > 6)
                                          ? 6
                                          : respBody.length);
                                  i++)
                                Container(
                                  //height: fullHeight(context) * 0.5,
                                  width: fullWidth(context) * 0.89,
                                  child: ServiceCard(
                                    image: respBody[i]['image'],
                                    title: respBody[i]['title'],
                                    freelancerName: respBody[i]
                                        ['freelancer-name'],
                                    freelancerPhoto: respBody[i]
                                        ['freelancer-photo-profile'],
                                    price: respBody[i]['price'],
                                    queued: respBody[i]['queued'],
                                    rates: "0",
                                  ),
                                )
                            ],
                          ),
                        );
                      }
                    }
                    return Container(
                      height: fullHeight(context) * 0.3,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(kPrimaryColor),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 7),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Top Prestataires",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var i = 0; i < topWorkers.length; i += 4)
                        Container(
                          //height: fullHeight(context) * 0.3,
                          width: fullWidth(context) * 0.45,
                          child: Card(
                            elevation: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 35,
                                    backgroundImage: AssetImage(
                                      topWorkers[i],
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 4.0,
                                          ),
                                          child: Text(
                                            topWorkers[i + 1],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    topWorkers[i + 2],
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        topWorkers[i + 3],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow.shade800,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              "Comment ça marche?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "1- Choisissez un prestataire",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Image.network(
                      "https://dezon.app/wp-content/uploads/2021/07/service1.png",
                      height: 120,
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    "2- Echangez via notre messagerie",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Image.network(
                      "https://dezon.app/wp-content/uploads/2021/07/service2.png",
                      height: 120,
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Text(
                    "3- Payez à la fin de la prestration",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Image.network(
                      "https://dezon.app/wp-content/uploads/2021/07/service3.png",
                      height: 120,
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Commencez maintenant",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Pour exercer dans le secteur des services, il n’est pas toujours obligatoire d’avoir un diplôme. Les aides à domicile comme le ménage, le repassage ou le lavage de vitres, le montage de meubles, le déplacement de l’électroménager ou le déménagement ne nécessitent aucune formation particulière. Inscrivez vous sur Dezon, pour proposer vos services à nos clients.",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
