import 'package:donation/app_state.dart';
import 'package:donation/pages/home.dart';
import 'package:donation/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: AccessControl(),
      ),
    );
  }
}

class AccessControl extends StatelessWidget {
  const AccessControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (_, service, __) {
        if (service.currentUser != null) {
          return HomePage();
        }
        return LoginPage();
      },
    );
  }
}
