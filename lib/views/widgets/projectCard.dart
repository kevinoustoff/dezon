import 'package:dezon/constants.dart';
import 'package:dezon/views/profile/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_html_css/simple_html_css.dart';

import '../projects/makeOfferScreen.dart';
import '../projects/projectDetailsScreen.dart';
import 'package:http/http.dart' as http;

class ProjectCard extends StatefulWidget {
  final int id, freelancerId;
  final String estimatedHours,
      hourlyPrice,
      cost,
      employerName,
      duration,
      level,
      freelancerType,
      projectExpiry,
      title,
      description,
      offres,
      location;
  final List savedSkills;
  ProjectCard({
    @required this.id,
    @required this.estimatedHours,
    @required this.hourlyPrice,
    @required this.cost,
    @required this.employerName,
    @required this.duration,
    @required this.level,
    @required this.freelancerId,
    @required this.freelancerType,
    @required this.projectExpiry,
    @required this.title,
    @required this.description,
    @required this.savedSkills,
    @required this.offres,
    @required this.location,
  });

  ///WHAT A SKILL LOOKS LIKE
  /*{
          "name": "Graphiste",
          "term_id": 126,
          "term_taxonomy_id": 126,
          "taxonomy": "skills"
        },
  */
  @override
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool hasLike = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProjectDetailsScreen(
            id: widget.id.toString(),
          ),
        ),
      ),
      child: Card(
        elevation: 1,
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UserProfile(
                        id: widget.freelancerId,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          widget.employerName ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: RichText(
                      text: HTML.toTextSpan(
                        context,
                        widget.title ?? '',
                        defaultTextStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 15),
                  (widget.cost != null)
                      ? Text(
                          widget.cost,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : Text(
                          (widget.hourlyPrice ?? '0') +
                              '/h' +
                              '\n~ ' +
                              (widget.estimatedHours ?? '0') +
                              ' h',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ],
              ),
              if (widget.savedSkills != null)
                Wrap(
                  spacing: 0,
                  runSpacing: 0,
                  children: [
                    for (var i = 0; i < widget.savedSkills.length; i++)
                      Chip(
                        backgroundColor: Color.fromRGBO(255, 180, 19, 0.2),
                        label: Text(
                          widget.savedSkills[i]['name'],
                        ),
                        padding: EdgeInsets.all(2),
                      ),
                  ],
                ),
              if (![null, ' ', ''].contains(widget.description))
                Builder(builder: (context) {
                  String finalValue = widget.description;
                  while (finalValue.startsWith("<p><\/p>")) {
                    finalValue = finalValue.replaceFirst("<p><\/p>", '');
                  }
                  return RichText(
                    text: HTML.toTextSpan(
                      context,
                      finalValue ?? '',
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  );
                }),
              Divider(thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          (widget.projectExpiry ?? ''),
                          textAlign: TextAlign.center,
                          //style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          (widget.offres ?? '0') + ' offres reçues',
                          textAlign: TextAlign.center,
                          //style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                  if (widget.location != null)
                    Flexible(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Position:'),
                              Text(
                                widget.location,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                //style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Divider(thickness: 1),
              SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.share_outlined),
                  ),
                  GestureDetector(
                    onTap: () async {
                      try {
                        final response = await http.post(
                          Uri.parse(ApiRoutes.host + ApiRoutes.toSaveProjects),
                          body: {
                            "user_id": ((await SharedPreferences.getInstance())
                                    .getInt('ID'))
                                .toString(),
                            "project_id": widget.id.toString()
                          },
                        );
                        print("Status Code: " +
                            response.statusCode.toString() +
                            '\n' +
                            "Body: " +
                            "${response.body.toString()}");

                        if (response.statusCode.toString().startsWith('20')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Projet enregistré.",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                          setState(() => hasLike = !hasLike);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Enregistrement échoué.",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                          throw Exception('Failed to save project');
                        }
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "L'application a rencontré une erreur. Veuillez réessayer plus tard !",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                    },
                    child: Icon(
                      hasLike ? Icons.favorite : Icons.favorite_outline,
                      color: Colors.red,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MakeOfferScreen(),
                      ),
                    ),
                    child: Icon(
                      Icons.work_outline,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
