import 'dart:convert';

import 'package:donation/service.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  final service = Service();

  User? _currentUser;
  User? get currentUser => _currentUser;
  set currentUser(User? val) {
    _currentUser = val;
    notifyListeners();
  }

  AppState() {
    init();
  }

  init() async {
    await fetchToken();
    fetchCurrentUser();
    fetchBills();
  }

  fetchToken() async {
    final prefs = await SharedPreferences.getInstance();
    service.token = prefs.getString("token");
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
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", result['jwt']);
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

  saveBill(Bill bill) {
    return bill.save(service);
  }

  final List<Bill> _bills = [];
  List<Bill> get bills => _bills;
  fetchBills() async {
    final List result = await service.get('/bills');
    final parsed = result.map((e) => Bill.fromMap(e));
    _bills.clear();
    _bills.addAll(parsed);
    notifyListeners();
  }
}

enum UserType { shopkeeper, donor }

class User {
  int? id;
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
      : id = data['id'],
        type = UserType.values.firstWhere(
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

class Product {
  String name;
  int quantity;
  double price;

  Product(this.name, this.quantity, this.price);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }
}

class Bill {
  int author;
  String name;
  IDType idType;
  String idNumber;

  List<Product> products;

  Bill({
    required this.author,
    required this.name,
    required this.idType,
    required this.idNumber,
    required this.products,
  });

  Bill.fromMap(Map<String, dynamic> data)
      : author = data['author']['id'],
        name = data['name'],
        idType = IDType.values.firstWhere(
            (element) => element.toString().split('.').last == data['id_type']),
        idNumber = data['id_number'],
        products = [];

  save(Service service) {
    return service.post('/bills', toMap());
  }

  Map<String, String> toMap() {
    return {
      'author': author.toString(),
      'name': name,
      'id_type': idType.toString().split('.').last,
      'id_number': idNumber,
      'products': jsonEncode(products.map((e) => e.toMap()).toList()),
    };
  }
}

enum IDType { ration, aadhar, driving }
