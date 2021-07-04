import 'dart:io';

import 'package:dezon/views/homePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dezon/constants.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'states/AuthState.dart';
import 'package:provider/provider.dart';

import 'views/loginScreen.dart';
import 'views/registerScreen.dart';
import 'package:splashscreen/splashscreen.dart';

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
          // When navigating to the "/" route, build the FirstScreen widget.
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
                      body: Center(
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Platform.isIOS
                                  ? CupertinoActivityIndicator(
                                      radius: 25,
                                    )
                                  : SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                kPrimaryColor),
                                      ),
                                    ),
                              SizedBox(
                                height: 45,
                                width: 45,
                              ),
                            ],
                          ),
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
