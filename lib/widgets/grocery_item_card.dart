import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';

import '../models/grocery.dart';
import '../utils/show_picture_dialog.dart';

class GroceryItemCard extends ConsumerWidget {
  final Grocery item;
  final Function swipeRight;
  final Function swipeleft;
  const GroceryItemCard(
      {Key key,
      @required this.item,
      @required this.swipeRight,
      @required this.swipeleft})
      : super(key: key);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Dismissible(
        key: Key(item.id),
        secondaryBackground: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Icon(Icons.edit),
            )),
        background: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Icon(Icons.check_box_rounded),
            )),
        direction: DismissDirection.horizontal,
        confirmDismiss: (DismissDirection direction) async {
          if (direction == DismissDirection.endToStart) {
            swipeleft();
          } else if (direction == DismissDirection.startToEnd) {
            return true;
          }
          return false;
        },
        onDismissed: (DismissDirection direction) => {
          if (direction == DismissDirection.endToStart)
            {
              swipeleft(),
            }
          else if (direction == DismissDirection.startToEnd)
            {
              swipeRight(),
            }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(3.0, 3.0),
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10.0,
              ),
            ],
          ),
          height: 70.0,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => showImageDialog(item.imageUrl, context),
                  child: Container(
                    width: 70.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: item.imageUrl == null || item.imageUrl == ''
                            ? AssetImage(
                                'assets/images/picture_placeholder.png')
                            : NetworkImage(
                                item.imageUrl,
                              ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w400),
                    ),
                    Text(
                      item.unit,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      item.price.toString(),
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ],
                ),
                Spacer(),
                Text(item.quantity.toString()),
                SizedBox(width: 16.0)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
