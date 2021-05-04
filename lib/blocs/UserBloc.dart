import 'package:rxdart/rxdart.dart';

import '../models/User.dart';
import '../resources/user_repository.dart';

class UserBloc {
  final _repository = Repository();
  final _usersFetcher = PublishSubject<User>();

  Stream<User> get allMovies => _usersFetcher.stream;

  fetchAllMovies() async {
    User itemModel = await _repository.fetchAllUsers();
    _usersFetcher.sink.add(itemModel);
  }

  dispose() {
    _usersFetcher.close();
  }
}

final bloc = UserBloc();