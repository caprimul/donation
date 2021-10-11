import 'package:donation/service.dart';
import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  final service = Service();

  User? _currentUser;
  User? get currentUser => _currentUser;
  set currentUser(User? val) {
    _currentUser = val;
    notifyListeners();
  }

  init() {
    fetchCurrentUser();
  }

  fetchCurrentUser() async {
    final result = await service.get('/users/me');
    currentUser = User(username: result["username"], email: result["email"]);
  }

  logIn(String email, String password) async {
    final result = await service.post('/auth/local', {
      'identifier': email,
      'password': password,
    });
    service.token = result['jwt'];
    return fetchCurrentUser();
  }

  signUp(String username, String email, String password) async {
    final user = User(username: username, email: email, password: password);
    await user.create();
    return logIn(email, password);
  }
}

enum UserType { shopkeeper, donor }

class User {
  String username;
  String email;
  String? password;

  User({required this.username, required this.email, this.password});

  create() async {
    final result = await Service().post('/auth/local/register', toMap());
    print(result);
  }

  Map<String, String> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password ?? "",
    };
  }
}
