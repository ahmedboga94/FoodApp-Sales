import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:foodappsales/global/global.dart';
import 'package:foodappsales/mainscreen/items_screen.dart';
import 'package:foodappsales/model/menu_model.dart';

class InfoDesign extends StatelessWidget {
  final MenuModel menuModel;
  const InfoDesign({super.key, required this.menuModel});

  @override
  Widget build(BuildContext context) {
    deleteMenu() {
      showDialog(
        context: context,
        builder: (context) => WillPopScope(
          onWillPop: () async => true,
          child: AlertDialog(
            title: const Text("Are you sure to delete this Menu?"),
            content: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("sellers")
                          .doc(sharedPreferences!.getString("uid"))
                          .collection("menus")
                          .doc(menuModel.menuID)
                          .delete()
                          .then((value) => showToast("Deleted Successfully"));
                      Navigator.pop(context);
                    },
                    child: const Text("OK")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.cyan)))
              ],
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ItemsScreen(menuModel: menuModel))),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(height: 4, thickness: 2, color: Colors.grey[300]),
              Image.network(menuModel.menuImageURL,
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 12),
                  Text(menuModel.menuTitle,
                      style: const TextStyle(
                          color: Colors.cyan,
                          fontSize: 20,
                          fontFamily: "TrainOne")),
                  const Spacer(flex: 7),
                  IconButton(
                      onPressed: () => deleteMenu(),
                      icon: const Icon(Icons.delete_sweep)),
                  const Spacer(flex: 1),
                ],
              ),
              Text(menuModel.menuInfo,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Divider(height: 4, thickness: 2, color: Colors.grey[300]),
            ],
          ),
        ),
      ),
    );
  }
}
