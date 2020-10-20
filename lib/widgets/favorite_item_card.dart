import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/grocery.dart';
import '../utils/show_picture_dialog.dart';

class FavoriteItemCard extends ConsumerWidget {
  final Grocery item;
  final Function addItemToList;
  final Function editItem;
  final Function deleteItem;
  const FavoriteItemCard({
    Key key,
    this.item,
    @required this.addItemToList,
    @required this.editItem,
    @required this.deleteItem,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    //final groceryCollectionProvider = watch(groceriesRepoProvider);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Slidable(
        key: Key(item.id),
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        actions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.purple[600],
            icon: Icons.delete,
            onTap: () => deleteItem(),
          ),
        ],
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Edit',
            color: Colors.purple[300],
            icon: Icons.edit,
            onTap: () => editItem(),
          ),
          IconSlideAction(
            caption: 'Add to List',
            color: Colors.purple[600],
            icon: Icons.playlist_add_check,
            onTap: () => addItemToList(),
          ),
        ],
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
