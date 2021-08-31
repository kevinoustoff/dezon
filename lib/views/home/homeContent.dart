import 'package:dezon/views/profile/userProfile.dart';
import 'package:dezon/views/widgets/userCard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../constants.dart';
import '../widgets/serviceCard.dart';

import 'package:card_swiper/card_swiper.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  TextStyle titleStyle = TextStyle(fontSize: 15);
  Future<List<Map>> futureTopUsers;
  Future<List<Map>> futureTopServices;
  ValueNotifier<List<Map>> topServicesData = ValueNotifier([]);
  final List images = [
    AppAssets.category1,
    AppAssets.category2,
    AppAssets.category3,
    AppAssets.category4,
  ];

  Future<List<Map>> fetchTopServices() async {
    const String whatWeGettin = "top services";
    printGetStart(whatWeGettin);
    final response = await http.get(
      Uri.parse(
        ApiRoutes.host + ApiRoutes.topServices,
      ),
    );

    if (response.statusCode.toString().startsWith('20')) {
      printGetDone(whatWeGettin);
      return [
        for (var i = 0; i < jsonDecode(response.body).length; i++)
          Map.from(jsonDecode(response.body)[i])
      ];
    } else {
      printGetFailed(whatWeGettin);
      throw Exception('Failed to load $whatWeGettin');
    }
  }

  Future<List<Map>> fetchTopUsers() async {
    const String whatWeGettin = 'top users';
    printGetStart(whatWeGettin);
    final response = await http.get(
      Uri.parse(
        ApiRoutes.host + ApiRoutes.topUsers,
      ),
    );

    if (response.statusCode.toString().startsWith('20')) {
      printGetDone(whatWeGettin);
      return [
        for (var i = 0; i < jsonDecode(response.body).length; i++)
          Map.from(jsonDecode(response.body)[i])
      ];
    } else {
      printGetFailed(whatWeGettin);
      throw Exception('Failed to load $whatWeGettin');
    }
  }

  @override
  void initState() {
    futureTopServices = fetchTopServices();
    futureTopUsers = fetchTopUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: fullWidth(context),
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    images[index],
                    fit: BoxFit.fill,
                  );
                },
                autoplay: true,
                autoplayDelay: 5000,
                itemCount: images.length,
                pagination: SwiperPagination(builder: SwiperPagination.dots),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 25, 0, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Services à la une",
                    style: titleStyle,
                  ),
                  SizedBox(height: 15),
                  FutureBuilder<List<Map>>(
                    future: futureTopServices,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        final List<Map> listTopServices = snapshot.data;
                        double dWidth = fullWidth(context) * 0.81;
                        if (listTopServices.length == 1) {
                          dWidth = fullWidth(context) * 0.92;
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (var i = 0;
                                  i <
                                      ((listTopServices.length > 6)
                                          ? 6
                                          : listTopServices.length);
                                  i++)
                                Container(
                                  width: dWidth,
                                  child: ServiceCard(
                                    id: listTopServices[i]['id'],
                                    image: listTopServices[i]['image'],
                                    title: listTopServices[i]['title'],
                                    freelancerName: listTopServices[i]
                                        ['freelancer-name'],
                                    freelancerPhoto: listTopServices[i]
                                        ['freelancer-photo-profile'],
                                    price: listTopServices[i]['price'],
                                    queued: listTopServices[i]['queued'],
                                    rates: "0",
                                  ),
                                )
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
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
                  SizedBox(height: 15),
                  Text(
                    "Top Prestataires",
                    style: titleStyle,
                  ),
                  FutureBuilder<List<Map>>(
                    future: futureTopUsers,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        final listTopUsers = snapshot.data;
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (var i = 0; i < listTopUsers.length; i++)
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => UserProfile(
                                          id: listTopUsers[i]['id'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: fullHeight(context) * 0.3,
                                    width: fullWidth(context) * 0.52,
                                    child: UserCard(
                                      userPhoto: listTopUsers[i]
                                          ['freelance-photo-profile'],
                                      userName: listTopUsers[i]
                                          ['freelancer-name'],
                                      userTagLine: listTopUsers[i]['tagline'],
                                      userDescription: listTopUsers[i]
                                          ['description'],
                                      userReview: listTopUsers[i]['reviews'],
                                      userRegistrationDate: listTopUsers[i]
                                          ['member-since'],
                                      userSkills: listTopUsers[i]['skills'],
                                    ),
                                  ),
                                )
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
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
                  SizedBox(height: 35),
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
          ],
        ),
      ),
    );
  }
}
