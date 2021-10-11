import 'package:donation/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, _) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Donation"),
            bottom: TabBar(
              tabs: [
                Tab(
                    text: state.currentUser!.type == UserType.donor
                        ? "My Donations"
                        : "Bills"),
                Tab(text: "Transactions"),
              ],
            ),
          ),
          floatingActionButton: state.currentUser!.type == UserType.donor
              ? FloatingActionButton.extended(
                  onPressed: () {},
                  label: Text("New Donation"),
                  icon: Icon(Icons.money),
                )
              : FloatingActionButton.extended(
                  onPressed: () {},
                  label: Text("New Bill"),
                  icon: Icon(Icons.receipt_long),
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      );
    });
  }
}
