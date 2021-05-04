import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../models/User.dart';
import 'api.dart';
import 'package:flutter/material.dart';

class UserApiProvider extends Api {
  Client client = Client();
  final _apiKey = 'your_api_key';

  Future<User> fetchUsersList() async {
    print("entered");
    final response = await client
        .get(Uri.parse("http://api.themoviedb.org/3/movie/popular?api_key=$_apiKey"));
    print(response.body.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return User.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future login(
    @required String email,
    @required String password,) async{

    var uri =  Uri.parse(this.baseUrl+'login');
    var response = await client.post(uri,headers:this.headers,
    body: json.encode({
          "email":email,
          "password": password
        }));
    /* print(response); */  
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return response.body/* User.fromJson(json.decode(response.body)) */;
    } else if(response.statusCode == 401){
       return new User();
    } else {
      // If that call was not successful, throw an error.
      throw Exception(response.statusCode);
    }
  }
}