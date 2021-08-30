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

String numberValidator(String value, {bool required = false}) {
  if (value == null || value.isEmpty) {
    return required ? "Entrez une valeur" : null;
  }
  final n = num.tryParse(value);
  if (n == null) {
    return 'Ce nombre est invalide';
  }
  return null;
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
    return "Entrez un mot de passe!";
  }
  if (s.length < 8) {
    return "Au moins 8 caractères requis";
  }
  return null;
}

String validateResetKey(String s) {
  if (s == null || s.isEmpty) {
    return "Entrez le code!";
  }
  return null;
}

const String noConnectionText =
    "Connexion internet faible ou inexistante. Assurez vous d'avoir une bonne liaison internet et réessayez !";
printGetStart(String whatWeGettin) =>
    print("->GET " + whatWeGettin + " in progress");
printGetDone(String whatWeGettin) =>
    print("->GET " + whatWeGettin + " done ! 💪");
printGetFailed(String whatWeGettin) =>
    print("->GET " + whatWeGettin + " failed ! ❌❌");
fullHeight(BuildContext context) => MediaQuery.of(context).size.height;
fullWidth(BuildContext context) => MediaQuery.of(context).size.width;

class ApiRoutes {
  static const String host = "https://dezon.app/";
  static const String termsAndConditions = "index.php/terms-and-conditions/";
  static const forgotPassword = "index.php/wp-json/api/forgot-password";
  static const forgotPasswordSetNew =
      "index.php/wp-json/api/forgot-password/set-new";
  static const modifyPass = "index.php/wp-json/api/recover-password";
  static const login = "index.php/wp-json/api/login";
  static const register = "index.php/wp-json/api/register";
  static const showProfile = "index.php/wp-json/api/profile?uid=";
  static const searchServices = "index.php/wp-json/api/services/search/?title=";
  static const searchProjects = "index.php/wp-json/api/projets/search/?title=";
  static const fetchProjects = "index.php/wp-json/api/projets";
  static const fetchProjectById = "index.php/wp-json/api/projet/?id=";
  static const fetchServiceById = "index.php/wp-json/api/service/?id=";
  static const fetchSearchFilters =
      "index.php/wp-json/api/services/search/filters";
  static const topServices = "index.php/wp-json/api/services/last";
  static const topUsers = "index.php/wp-json/api/freelancers/top";
  static const sectionLanguesPrestataires =
      "index.php/wp-json/api/langues-prestataires";
  static const sectionSexes = "index.php/wp-json/api/sexes";
  static const sectionEnglishLevels = "index.php/wp-json/api/english-levels";
  static const sectionLocations = "index.php/wp-json/api/locations";
  static const sectionTypesPrestataires =
      "index.php/wp-json/api/types-prestataires";
}

class AppAssets {
  static const logo = "assets/images/logo.png";
  static const appIcon = "assets/images/appicon.png";
  static const defaultProfile = "assets/images/defaultProfile.jpg";
  static const category1 = "assets/images/category1.jpeg";
  static const category2 = "assets/images/category2.jpeg";
  static const category3 = "assets/images/category3.jpeg";
  static const category4 = "assets/images/category4.jpeg";
  static const worker1 = "assets/images/worker1.jpg";
  static const worker2 = "assets/images/worker2.jpg";
  static const worker3 = "assets/images/worker3.jpg";
  static const worker4 = "assets/images/worker4.jpg";
}

const List keyzS = [
  'price-minS',
  'price-maxS',
  'locationsS',
  'delais',
  'english-levels',
  'categoriesS',
];
const List keyzP = [
  'price-minP',
  'price-maxP',
  'locationsP',
  'languages',
  'categoriesP',
];
