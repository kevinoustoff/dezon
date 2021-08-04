import 'package:dezon/constants.dart';
import 'package:flutter/material.dart';

class FilterProjects extends StatefulWidget {
  @override
  _FilterProjectsState createState() => _FilterProjectsState();
}

class _FilterProjectsState extends State<FilterProjects> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: kPrimaryColor),
        title: Text(
          'Filtres',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
