import 'package:dezon/constants.dart';
import 'package:dezon/views/freelancers.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu_rounded),
          onPressed: () {},
        ),
        centerTitle: true,
        title: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.black26,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            padding: MaterialStateProperty.all(
              EdgeInsets.fromLTRB(30, 5, 0, 5),
            ),
          ),
          onPressed: () {},
          child: Row(
            //mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search),
              SizedBox(width: 10),
              Text(
                "Je cherche..",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      body: [
        Center(
          child: Text(
            'Accueil',
            style: optionStyle.copyWith(color: kPrimaryColor.withOpacity(0.8)),
          ),
        ),
        Center(
          child: Text(
            'Emplois',
            style: optionStyle,
          ),
        ),
        Freelancers(),
        Center(
          child: Text(
            'Entreprises',
            style: optionStyle,
          ),
        ),
      ][_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 6,
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryColor,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.black54,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            label: 'Emplois',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline_rounded),
            label: 'Freelancer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'Entreprise',
          ),
        ],
      ),
    );
  }
}
