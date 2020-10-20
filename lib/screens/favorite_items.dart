import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';

import '../states/riverpod_state_mgmt.dart';
import '../widgets/favorite_item_card.dart';
import '../screens/edit_update_item.dart';

class FavoriteItems extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final regularlyBoughtItems = watch(favoriteItemsStream);
    final favItemCollectionProvider = watch(favoriteItemsRepoProvider);
    final groceryCollectionProvider = watch(groceriesRepoProvider);
    final storageRefProvider = watch(firebaseStorageProvider);
    return regularlyBoughtItems.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (o, s) => Text('error: $o'),
      data: (items) => ListView(
        children: [
          SizedBox(height: 10.0),
          ...items.map(
            (item) => FavoriteItemCard(
                item: item,
                addItemToList: () {
                  groceryCollectionProvider.addItem(item).whenComplete(
                        () => Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('${item.name} added to list'),
                        )),
                      );
                },
                editItem: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditUpdateItem(item))),
                deleteItem: () async {
                  await storageRefProvider.deleteImage(item.imageUrl);
                  favItemCollectionProvider
                      .deleteItem(item.id)
                      .whenComplete(() => Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('${item.name} deleted')),
                          ));
                }),
          ),
        ],
      ),
    );
  }
}
