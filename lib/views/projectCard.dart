import 'package:flutter/material.dart';

import 'makeOfferScreen.dart';
import 'projectDetailsScreen.dart';

class ProjectCard extends StatefulWidget {
  final String id,
      estimatedHours,
      hourlyPrice,
      cost,
      employerName,
      duration,
      level,
      freelancerType,
      projectExpiry,
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
    @required this.freelancerType,
    @required this.projectExpiry,
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
            id: widget.id,
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.description ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
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
                  spacing: 10,
                  runSpacing: 0,
                  children: [
                    for (var i = 0; i < widget.savedSkills.length; i++)
                      Chip(
                        backgroundColor: Color.fromRGBO(255, 180, 19, 0.2),
                        label: Text(
                          widget.savedSkills[i]['name'],
                        ),
                      ),
                  ],
                ),
              Text(
                widget.description ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
              Divider(thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        (widget.projectExpiry ?? ''),
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        (widget.offres ?? '0') + ' offres reçues',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  if (widget.location != null)
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Position:'),
                            Text(
                              widget.location,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              Divider(thickness: 1),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.share_outlined,
                    color: Colors.green.shade800,
                  ),
                  GestureDetector(
                    onTap: () => setState(() => hasLike = !hasLike),
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
