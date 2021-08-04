import 'package:dezon/constants.dart';
import 'package:flutter/material.dart';

class FilterServices extends StatefulWidget {
  @override
  _FilterServicesState createState() => _FilterServicesState();
}

class _FilterServicesState extends State<FilterServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: kPrimaryColor),
        title: Text(
          'Filtres',
          style: TextStyle(color: kPrimaryColor),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {},
              child: Text("Appliquer >"),
            ),
          ),
          SizedBox(width: 15),
        ],
      ),
    );
  }
}
