import 'package:flutter/material.dart';

import 'package:foodappsales/model/item_model.dart';
import 'package:foodappsales/widgets/app_app_bar.dart';

class ItemDetailsScreen extends StatelessWidget {
  final ItemModel itemModel;
  const ItemDetailsScreen({super.key, required this.itemModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: itemModel.itemTitle),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(itemModel.itemImageURL,
                height: 220,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover),
            const SizedBox(height: 10),
            Text(itemModel.itemTitle,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 22),
            Text("Price    ${itemModel.itemPrice} \$",
                textAlign: TextAlign.right,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 18),
            Text(itemModel.itemDescription,
                style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
