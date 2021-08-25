import 'package:dezon/views/home/homePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dezon/constants.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'states/AuthState.dart';
import 'package:provider/provider.dart';

import 'views/auth/loginScreen.dart';
import 'views/auth/registerScreen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xFF087D9B), // status bar color
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
      ],
      child: MaterialApp(
        locale: Locale('fr', 'FR'),
        title: 'Dezon',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: Colors.white,
            fontFamily: "Poppins"),
        initialRoute: '/',
        routes: {
          '/': (context) => FutureBuilder(
                future: SharedPreferences.getInstance(),
                builder: (context, snapshot) {
                  if ((snapshot.connectionState == ConnectionState.done) &&
                      snapshot.hasData) {
                    if (snapshot.data.containsKey('ID')) {
                      return HomePage();
                    } else {
                      return LoginScreen();
                    }
                  }
                  return SafeArea(
                    child: Scaffold(
                      backgroundColor: Colors.black,
                      body: Container(
                        height: fullHeight(context),
                        width: fullWidth(context),
                        decoration: BoxDecoration(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/register': (context) => RegisterScreen(),
        },
      ),
    );
  }
}
