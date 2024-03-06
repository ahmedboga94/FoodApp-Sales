import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodappsales/global/global.dart';
import 'package:foodappsales/global/order_functions.dart';
import 'package:foodappsales/model/order_model.dart';
import 'package:foodappsales/widgets/app_app_bar.dart';
import 'package:foodappsales/widgets/order_card.dart';

class NewOrderScreen extends StatefulWidget {
  static String id = "orderScreen";
  const NewOrderScreen({super.key});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: "New Orders"),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where("status", isEqualTo: "normal")
            .where("sellerUID", isEqualTo: sharedPreferences!.getString("uid"))
            .snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? const Center(child: CircularProgressIndicator())
              : snapshot.data!.docs.isEmpty
                  ? const Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.remove_shopping_cart_outlined,
                                size: 150, color: Colors.cyan),
                            Text("No Orders are Requested.",
                                style: TextStyle(
                                    color: Colors.cyan,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold))
                          ]),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, indexO) {
                        final orderModel = OrderModel.fromJson(
                            snapshot.data!.docs[indexO].data()
                                as Map<String, dynamic>);

                        return FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection("items")
                                .where("itemID",
                                    whereIn: OrderFunctions.separateItemIDs(
                                        orderModel.productsIDs))
                                .orderBy("publishedData", descending: true)
                                .get(),
                            builder: (context, snap) {
                              return !snap.hasData
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        Text(
                                            "   Order No. #${orderModel.orderID}",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontFamily: "Acme")),
                                        OrderCard(
                                          itemCount: snap.data!.docs.length,
                                          data: snap.data!.docs,
                                          orderID: orderModel.orderID,
                                          sepratedQtyList:
                                              OrderFunctions.separateItemQtys(
                                                  orderModel.productsIDs),
                                        ),
                                      ],
                                    );
                            });
                      });
        },
      ),
    );
  }
}
