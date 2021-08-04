import 'package:flutter/material.dart';

import '../constants.dart';

class ServiceCard extends StatefulWidget {
  final String image,
      title,
      freelancerName,
      freelancerPhoto,
      price,
      queued,
      rates;
  ServiceCard({
    @required this.image,
    @required this.title,
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
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //SizedBox(height: 5),
            (widget.image != null)
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
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage:
                              (![null, ""].contains(widget.freelancerPhoto))
                                  ? NetworkImage(widget.freelancerPhoto)
                                  : AssetImage(AppAssets.defaultProfile),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              widget.freelancerName ?? "",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.title ?? "",
                          //textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 17,
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
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
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
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: (widget.price ?? "") + " F CFA",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if ((widget.queued != null) &&
                      ((widget.queued.toString().split(' ')[0] != '0')))
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        ((widget.queued.toString().split(' ')[0]) +
                            " en attente"),
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
