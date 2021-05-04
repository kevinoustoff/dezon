import 'dart:async';
import 'user_api_provider.dart';
import '../models/User.dart';

class Repository {
  final usersApiProvider = UserApiProvider();

  Future<User> fetchAllUsers() => usersApiProvider.fetchUsersList();
}