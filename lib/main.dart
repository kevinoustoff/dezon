import 'package:flutter/material.dart';
import 'package:dezon/constants.dart';
import 'package:flutter/services.dart';
import 'states/AuthState.dart';
import 'package:provider/provider.dart';

import 'views/loginScreen.dart';
import 'views/registerScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xFF087D9B), // status bar color
      ),
    );
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
          '/': (context) => LoginScreen(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/register': (context) => RegisterScreen(),
        },
      ),
    );
  }
}
