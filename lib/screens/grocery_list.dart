import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

import '../states/riverpod_state_mgmt.dart';
import '../widgets/grocery_item_card.dart';
import '../widgets/purchased_item.dart';
import '../screens/edit_update_item.dart';

class GroceryList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final groceryList = watch(groceryListStream);
    final groceryCollectionProvider = watch(groceriesRepoProvider);
    return groceryList.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (o, s) => Center(child: Text('error: $o')),
      data: (items) => ListView(
        scrollDirection: Axis.vertical,
        children: [
          SizedBox(height: 10.0),
          ...items.map(
            (i) => i.purchased == false
                ? GroceryItemCard(
                    item: i,
                    swipeRight: () => groceryCollectionProvider.updateItem(
                      i.id,
                      i.copyWith(purchased: true),
                    ),
                    swipeleft: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditUpdateItem(i)));
                    },
                  )
                : SizedBox.shrink(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Estimated Total: ',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
                ),
                Text(
                  items
                      .map((e) => e.price * e.quantity)
                      .fold(0, (prev, next) => prev + next)
                      .toString(),
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'Purchased',
                  style: TextStyle(fontSize: 18.0),
                ),
                Spacer(),
                FlatButton(
                  splashColor: Colors.amber,
                  color: Colors.amberAccent,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              elevation: 18.0,
                              title: Text('Clear List'),
                              content: Text('Clear all item in the list?'),
                              actions: [
                                FlatButton(
                                    onPressed: () async {
                                      await context
                                          .read(groceriesRepoProvider)
                                          .batchDelete();
                                      Navigator.pop(context);
                                    },
                                    child: Text('Yes')),
                                FlatButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('No')),
                              ],
                            ));
                  },
                  child: Text(
                    'Clear',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                SizedBox(width: 10.0),
              ],
            ),
          ),
          ...items.map((i) =>
              i.purchased == true ? PurchasedItem(item: i) : SizedBox.shrink()),
        ],
      ),
    );
  }
}
