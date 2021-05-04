import 'package:flutter/material.dart';
import 'package:dezon/views/Login/login_screen.dart';
import 'package:dezon/views/Signup/signup_screen.dart';
import 'package:dezon/constants.dart';
import 'states/AuthState.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /* return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: LoginScreen(),
    ); */
     return MultiProvider(
      providers: [
        
        ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
        
        
      ],
      child: MaterialApp(
        
        locale: Locale('fr', 'FR'),
        /* title: 'TarzanExpress', */
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
          //scaffoldBackgroundColor: Colors.white,
        initialRoute: '/',
        routes:  {
          
    // When navigating to the "/" route, build the FirstScreen widget.
    '/': (context) => LoginScreen(),
    // When navigating to the "/second" route, build the SecondScreen widget.
    '/register': (context) => SignUpScreen(),
  },
        
      ),
    );


  }
}