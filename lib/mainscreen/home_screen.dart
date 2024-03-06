import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:foodappsales/authentication/auth_screen.dart';
import 'package:foodappsales/global/global.dart';
import 'package:foodappsales/model/seller_model.dart';
import 'package:foodappsales/uploadscreens/menus_upload_screen.dart';
import 'package:foodappsales/widgets/app_drawer.dart';
import 'package:foodappsales/widgets/error_dialog.dart';

import '../model/menu_model.dart';
import '../widgets/info_design.dart';

class HomeScreen extends StatefulWidget {
  static String id = "homeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  kikOutBlockedUsers() async {
    final navigator = Navigator.of(context);
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        final sellerModel =
            SellerModel.fromJson(snapshot.data() as Map<String, dynamic>);
        if (sellerModel.status == "not approved") {
          FirebaseAuth.instance.signOut();
          navigator.pushNamedAndRemoveUntil(AuthScreen.id, (route) => false);
          showDialog(
              context: context,
              builder: (c) => const ErrorDialog(
                  message:
                      "You are blocked from Admin \n Contact on: admin@gmail.com"));
        }
      }
    });
  }

  @override
  void initState() {
    kikOutBlockedUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
          colors: [
            Colors.cyan,
            Colors.amber,
          ],
        ))),
        title: Text("${sharedPreferences!.getString("name")}",
            style: const TextStyle(fontFamily: "Lobster", fontSize: 40)),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(MenusUploadScreen.id),
              icon: const Icon(Icons.post_add, color: Colors.cyan))
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          const ListTile(
              title: Text("My Menus",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Signatra",
                      fontSize: 40,
                      color: Colors.cyan,
                      letterSpacing: 3))),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("sellers")
                  .doc(sharedPreferences!.getString("uid"))
                  .collection("menus")
                  .orderBy("publishedData", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? const Center(child: CircularProgressIndicator())
                    : snapshot.data!.docs.isEmpty
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Icon(Icons.block,
                                    size: 150, color: Colors.cyan),
                                Text(
                                    "No Menus was added, Please enter new one.",
                                    style: TextStyle(
                                        color: Colors.cyan,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))
                              ])
                        : MasonryGridView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            gridDelegate:
                                const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1),
                            itemBuilder: (context, index) {
                              MenuModel menuModel = MenuModel.fromJson(
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>);
                              return InfoDesign(menuModel: menuModel);
                            });
              },
            ),
          ),
        ],
      ),
    );
  }
}
