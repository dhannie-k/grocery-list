import 'package:flutter/material.dart';
import 'package:grocery_list/models/grocery.dart';

class PurchasedItem extends StatelessWidget {
  final Grocery item;

  const PurchasedItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        children: [
          Icon(
            Icons.check_box,
            color: Colors.purple,
            size: 18.0,
          ),
          SizedBox(width: 12.0),
          Text(
            item.name,
            style: TextStyle(fontSize: 18.0),
          ),
          Spacer(),
          Text(
            item.quantity.toString(),
            style: TextStyle(fontSize: 14.0),
          ),
          SizedBox(width: 16.0)
        ],
      ),
    );
  }
}
