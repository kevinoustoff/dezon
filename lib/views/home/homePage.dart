import 'package:dezon/constants.dart';
import 'package:dezon/views/chat/chatListScreen.dart';
import 'package:dezon/views/projects/projectsList.dart';
import 'package:dezon/views/services/servicesList.dart';
import 'package:flutter/material.dart';

import '../drawer.dart';
import '../searchPage.dart';
import 'homeContent.dart';

const List<String> menuLabels = [
  'Accueil',
  'Services',
  'Projets',
  'Messagerie',
];
const List<IconData> menuIcons = [
  Icons.home_outlined,
  Icons.work_outline,
  Icons.library_books_outlined,
  Icons.chat_bubble_outline_rounded,
];

List<Widget> _widgetOptions = <Widget>[
  HomeContent(),
  ServicesList(),
  ProjectsList(),
  ChatListScreen(),
];

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _selectedIndex == 0
            ? Image.asset(
                AppAssets.appIcon,
                width: 40,
              )
            : Text(menuLabels[_selectedIndex]),
        actions: [
          if (_selectedIndex == 0)
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
      body: _widgetOptions.elementAt(_selectedIndex),
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
          for (var i = 0; i < 4; i++)
            BottomNavigationBarItem(
              icon: Icon(menuIcons[i]),
              activeIcon: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Text(
                  menuLabels[i],
                  style: TextStyle(color: Colors.white),
                ),
              ),
              label: '',
            ),
        ],
      ),
    );
  }
}
