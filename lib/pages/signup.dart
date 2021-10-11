import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final shopNameController = TextEditingController();
  final shopLocationController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  UserType selectedType = UserType.donor;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, service, _) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Donation'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create a new account'),
              TextField(
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email Address'),
              ),
              TextField(
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Text('Account Type: '),
                    DropdownButton<UserType>(
                      value: selectedType,
                      items: UserType.values
                          .map((e) => DropdownMenuItem(
                                child: Text(e.toString().split('.').last),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (type) {
                        if (type == null) return;
                        setState(() {
                          selectedType = type;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Builder(builder: (_) {
                if (selectedType == UserType.shopkeeper) {
                  return Column(
                    children: [
                      TextField(
                        controller: shopNameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(labelText: 'Shop Name'),
                      ),
                      TextField(
                        controller: shopLocationController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(labelText: 'Shop Address'),
                      ),
                    ],
                  );
                }
                return Container();
              }),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 8),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final email = emailController.text;
                        final password = passwordController.text;
                        final name = nameController.text;
                        final shopName = shopNameController.text;
                        final shopLocation = shopLocationController.text;

                        try {
                          await service.signUp(
                            selectedType,
                            name,
                            email,
                            password,
                            shopName: shopName,
                            shopLocation: shopLocation,
                          );
                          Navigator.of(context).pop();
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              content: Text(e.toString().split(":").last),
                            ),
                          );
                        }
                      },
                      child: Text('Sign Up'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('or'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Return to login'),
                    )
                  ],
                ),
              ),
              Text(
                'By logging in you agree to the application terms and conditions and privacy policy.',
                style: TextStyle(
                  color: Colors.black38,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
