import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodappsales/mainscreen/order_details_screen.dart';
import 'package:foodappsales/model/item_model.dart';

class OrderCard extends StatelessWidget {
  final int itemCount;
  final String orderID;
  final List<DocumentSnapshot> data;
  final List<String> sepratedQtyList;

  const OrderCard({
    super.key,
    required this.sepratedQtyList,
    required this.itemCount,
    required this.orderID,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OrderScreenDetails(orderID: orderID))),
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(colors: [
              Colors.black12,
              Colors.black38,
            ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.all(4),
        height: itemCount * 133,
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            final itemModel =
                ItemModel.fromJson(data[index].data()! as Map<String, dynamic>);
            return PlacedOrder(
              itemModel: itemModel,
              sepratedQtyList: sepratedQtyList[index],
              orderID: orderID,
            );
          },
        ),
      ),
    );
  }
}

class PlacedOrder extends StatelessWidget {
  final ItemModel itemModel;
  final String sepratedQtyList, orderID;
  const PlacedOrder(
      {super.key,
      required this.itemModel,
      required this.sepratedQtyList,
      required this.orderID});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 120,
        color: Colors.grey[200],
        child: Row(
          children: [
            Image.network(
              itemModel.itemImageURL,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.35,
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Text(itemModel.itemTitle,
                          style: const TextStyle(
                              fontSize: 18, fontFamily: "Acme")),
                    ),
                    const SizedBox(width: 10),
                    Text("${itemModel.itemPrice} \$",
                        style:
                            const TextStyle(fontSize: 18, color: Colors.blue)),
                    const SizedBox(width: 10),
                  ],
                ),
                Text("x $sepratedQtyList",
                    style: const TextStyle(fontSize: 22, fontFamily: "Acme"))
              ],
            ))
          ],
        ),
      ),
    );
  }
}
