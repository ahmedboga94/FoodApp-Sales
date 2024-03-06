import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../global/global.dart';
import '../model/item_model.dart';
import '../model/menu_model.dart';
import '../uploadscreens/items_upload_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/item_design.dart';

class ItemsScreen extends StatefulWidget {
  static const String id = "itemsScreen";
  final MenuModel? menuModel;
  const ItemsScreen({super.key, this.menuModel});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
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
              style: const TextStyle(fontFamily: "Lobster", fontSize: 35)),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ItemsUploadScreen(menuModel: widget.menuModel))),
                icon: const Icon(Icons.library_add, color: Colors.cyan))
          ]),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          ListTile(
              title: Text("${widget.menuModel!.menuTitle}'s Items",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
                  .doc(widget.menuModel!.menuID)
                  .collection("items")
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
                                    "No Items was added, Please enter new one.",
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
                              final itemModel = ItemModel.fromJson(
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>);
                              return ItemDesign(itemModel: itemModel);
                            });
              },
            ),
          ),
        ],
      ),
    );
  }
}
