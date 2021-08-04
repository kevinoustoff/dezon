import 'package:flutter/material.dart';

class PageInProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Page T'),
      ),
      body: Center(
        child: Text('Page en cours de développement..'),
      ),
    );
  }
}
