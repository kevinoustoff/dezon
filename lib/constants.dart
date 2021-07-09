import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF0A9CC2);
const kSecondaryColor = Color(0xFFD6DDE5);
const kTertiaryColor = Color(0xFF000403);
const kPrimaryLightColor = Color(0xFFF1E6FF);
const gradientFirstColor = Color(0xFF2193B0);
const gradientSecondColor = Color(0xFF6DD5ED);

Color lightGreen = Color(0xFF95E08E);
Color lightBlueIsh = Color(0xFF33BBB5);
Color darkGreen = Color(0xFF00AA12);
Color backgroundColor = Color(0xFFEFEEF5);

TextStyle titleStyleWhite = new TextStyle(
    fontFamily: 'Helvetica',
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 25);
TextStyle jobCardTitileStyleBlue = new TextStyle(
    fontFamily: 'Avenir',
    color: lightBlueIsh,
    fontWeight: FontWeight.bold,
    fontSize: 12);
TextStyle jobCardTitileStyleBlack = new TextStyle(
    fontFamily: 'Avenir',
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 12);
TextStyle titileStyleLighterBlack = new TextStyle(
    fontFamily: 'Avenir',
    color: Color(0xFF34475D),
    fontWeight: FontWeight.bold,
    fontSize: 20);

TextStyle titileStyleBlack = new TextStyle(
    fontFamily: 'Helvetica',
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 20);
TextStyle salaryStyle = new TextStyle(
    fontFamily: 'Avenir',
    color: darkGreen,
    fontWeight: FontWeight.bold,
    fontSize: 12);

const String host = "https://dezon.app";

String validateEmail(String s) {
  if (s != null && s.isNotEmpty) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(s)) {
      return "Veuillez entrer un email valide!";
    }
  }
  if (s == null || s.isEmpty) {
    return "N'oubliez pas votre email!";
  }
  return null;
}

bool _containNumeric(String s) {
  for (int i = 0; i < s.length; i++) {
    if (double.tryParse(s[i]) != null) {
      return true;
    }
  }
  return false;
}

String validateNom(String s) {
  if (s == null || s.isEmpty) {
    return "N'oubliez pas votre nom!";
  }
  if (_containNumeric(s)) {
    return 'Nom Invalide!';
  }
  /* if (s.contains(" ")) {
    return "Entrez un nom sans espace";
  } */
  return null;
}

String validatePassword(String s) {
  if (s == null || s.isEmpty) {
    return "Entrer un mot de passe!";
  }
  if (s.length < 8) {
    return "Au moins 8 caractères requis";
  }
  return null;
}

class ApiRoutes {
  static const forgotPassword = "";
  static const login = "/index.php/wp-json/api/login";
}

class AppAssets {
  static const defaultProfile = "assets/images/defaultProfile.jpg";
}
