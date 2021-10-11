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
    currentUser = User.fromMap(result);
  }

  logIn(String email, String password) async {
    final result = await service.post('/auth/local', {
      'identifier': email,
      'password': password,
    });
    service.token = result['jwt'];
    return fetchCurrentUser();
  }

  signUp(
    UserType type,
    String username,
    String email,
    String password, {
    String? shopName,
    String? shopLocation,
  }) async {
    final user = User(
      type: type,
      username: username,
      email: email,
      password: password,
      shopName: shopName,
      shopLocation: shopLocation,
    );
    await user.create();
    return logIn(email, password);
  }
}

enum UserType { shopkeeper, donor }

class User {
  String username;
  String email;
  String? password;

  UserType type;

  String? shopName;
  String? shopLocation;

  User({
    required this.type,
    required this.username,
    required this.email,
    this.password,
    this.shopName,
    this.shopLocation,
  });

  User.fromMap(Map<String, dynamic> data)
      : type = UserType.values.firstWhere(
            (element) => element.toString().split(".").last == data["type"]),
        username = data["username"],
        email = data["email"],
        shopName = data["shop_name"],
        shopLocation = data["shop_location"];

  create() async {
    final result = await Service().post('/auth/local/register', toMap());
  }

  Map<String, String?> toMap() {
    return {
      'type': type.toString().split(".").last,
      'username': username,
      'email': email,
      'password': password,
      'shop_name': shopName,
      'shop_location': shopLocation,
    };
  }
}
