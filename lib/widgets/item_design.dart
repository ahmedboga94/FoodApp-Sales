import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:foodappsales/global/global.dart';
import 'package:foodappsales/mainscreen/item_details_screen.dart';
import '../model/item_model.dart';

class ItemDesign extends StatelessWidget {
  final ItemModel itemModel;
  const ItemDesign({super.key, required this.itemModel});

  @override
  Widget build(BuildContext context) {
    deleteItem() {
      showDialog(
        context: context,
        builder: (context) => WillPopScope(
          onWillPop: () async => true,
          child: AlertDialog(
            title: const Text("Are you sure to delete this Item?"),
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
                          .doc(itemModel.menuID)
                          .collection("items")
                          .doc(itemModel.itemID)
                          .delete()
                          .then((value) {
                        FirebaseFirestore.instance
                            .collection("items")
                            .doc(itemModel.itemID)
                            .delete();
                      }).then((value) {
                        showToast("Deleted Successfully", context: context);
                      });
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
              builder: (context) => ItemDetailsScreen(itemModel: itemModel))),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(height: 4, thickness: 2, color: Colors.grey[300]),
              Image.network(itemModel.itemImageURL,
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Spacer(flex: 12),
                  Text(itemModel.itemTitle,
                      style: const TextStyle(
                          color: Colors.cyan,
                          fontSize: 20,
                          fontFamily: "TrainOne")),
                  const Spacer(flex: 7),
                  IconButton(
                      onPressed: () => deleteItem(),
                      icon: const Icon(Icons.delete_sweep)),
                  const Spacer(flex: 1),
                ],
              ),
              Text(itemModel.itemInfo,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Divider(height: 4, thickness: 2, color: Colors.grey[300]),
            ],
          ),
        ),
      ),
    );
  }
}
