import 'package:dezon/views/profile/userProfile.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../services/serviceDetailsScreen.dart';

class ServiceCard extends StatefulWidget {
  final int id, freelancerId;
  final String image,
      title,
      freelancerName,
      freelancerPhoto,
      price,
      queued,
      rates;
  ServiceCard({
    @required this.id,
    @required this.image,
    @required this.title,
    @required this.freelancerId,
    @required this.freelancerName,
    @required this.freelancerPhoto,
    @required this.price,
    @required this.queued,
    @required this.rates,
  });
  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ServiceDetailsScreen(
            id: widget.id.toString(),
          ),
        ),
      ),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54, width: 0.1),
              ),
              child: (widget.image != null)
                  ? Image.network(
                      widget.image,
                      height: fullHeight(context) * 0.13,
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    )
                  : Image.asset(
                      AppAssets.category1,
                      height: fullHeight(context) * 0.13,
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UserProfile(
                              id: widget.freelancerId,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 15,
                            backgroundImage:
                                (![null, ""].contains(widget.freelancerPhoto))
                                    ? NetworkImage(widget.freelancerPhoto)
                                    : AssetImage(AppAssets.defaultProfile),
                          ),
                          SizedBox(width: 8),
                          Row(
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
                                  widget.freelancerName ?? "",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  /* Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 10),
                        
                      ],
                    ),
                  ), */
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.title ?? "",
                          //textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow.shade800,
                            ),
                            SizedBox(width: 5),
                            Text(
                              (widget.rates != null)
                                  ? (widget.rates.toString().split(' ')[0])
                                  : "",
                              /* style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ), */
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 7),
                  RichText(
                    //textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "À partir de ",
                      style: TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: (widget.price ?? "") + " F CFA",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      (((widget.queued != null) &&
                              ((widget.queued.toString().split(' ')[0] != '0')))
                          ? ((widget.queued.toString().split(' ')[0]) +
                              " en attente")
                          : ''),
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
