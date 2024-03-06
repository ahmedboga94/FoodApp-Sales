import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodappsales/mainscreen/earnings_screen.dart';
import 'package:foodappsales/mainscreen/history_screen.dart';
import 'package:foodappsales/mainscreen/home_screen.dart';
import 'package:foodappsales/mainscreen/new_order_screen.dart';

import '../authentication/auth_screen.dart';
import '../global/global.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        Container(
          padding: const EdgeInsets.only(top: 25, bottom: 10),
          child: Column(children: [
            Material(
              borderRadius: const BorderRadius.all(Radius.circular(80)),
              elevation: 10,
              child: SizedBox(
                  width: 160,
                  height: 160,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "${sharedPreferences!.getString("photoURL")}"),
                  )),
            ),
            const SizedBox(height: 10),
            Text("${sharedPreferences!.getString("name")}",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("${sharedPreferences!.getString("email")}"),
          ]),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Divider(height: 10, color: Colors.grey, thickness: 2),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              ListTile(
                  leading: const Icon(Icons.home, color: Colors.black),
                  title: const Text("Home",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                      HomeScreen.id, (route) => false)),
              ListTile(
                  leading:
                      const Icon(Icons.monetization_on, color: Colors.black),
                  title: const Text("My Earnings",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  onTap: () => Navigator.pushNamed(context, EarningsScreen.id)),
              ListTile(
                  leading: const Icon(Icons.reorder, color: Colors.black),
                  title: const Text("New Orders",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  onTap: () => Navigator.pushNamed(context, NewOrderScreen.id)),
              ListTile(
                  leading:
                      const Icon(Icons.local_shipping, color: Colors.black),
                  title: const Text("History - Orders",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  onTap: () => Navigator.pushNamed(context, HistoryScreen.id)),
              ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.black),
                  title: const Text("Sign Out",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  onTap: () {
                    FirebaseAuth.instance.signOut().then((value) =>
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            AuthScreen.id, (route) => false));
                  })
            ],
          ),
        )
      ]),
    );
  }
}
