import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';

import '../states/riverpod_state_mgmt.dart';
import '../models/grocery.dart';
import '../utils/image_picker.dart';
import '../utils/form_field_validator.dart';

class EditUpdateItem extends HookWidget {
  final Grocery itemToEdit;

  EditUpdateItem(this.itemToEdit);

  final _formEditKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print(itemToEdit.reference.parent ?? 'no parent');
    final imageFile = useState(File(''));
    final imageUrl = useState(itemToEdit.imageUrl ?? '');
    final _scrollController = useScrollController();
    final nameTxtController = useTextEditingController(text: itemToEdit.name);
    final quantityTxtController =
        useTextEditingController(text: itemToEdit.quantity.toString());
    final unitTxtController = useTextEditingController(text: itemToEdit.unit);
    final priceTxtController =
        useTextEditingController(text: itemToEdit.price.toString());
    final groceryCollectionProvider = useProvider(groceriesRepoProvider);
    final favCollectionProvider = useProvider(favoriteItemsRepoProvider);
    final firebaseStorageService = useProvider(firebaseStorageProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
        title: Text(
          'Edit Item',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formEditKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            children: [
              TextFormField(
                controller: nameTxtController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) => formFieldValidator(value),
              ),
              TextFormField(
                controller: quantityTxtController,
                decoration: InputDecoration(labelText: 'quantity'),
                validator: (value) => formFieldValidator(value),
              ),
              TextFormField(
                controller: unitTxtController,
                decoration: InputDecoration(labelText: 'unit - ex: 200gr/pack'),
                validator: (value) => formFieldValidator(value),
              ),
              TextFormField(
                controller: priceTxtController,
                decoration: InputDecoration(labelText: 'price'),
                validator: (value) => formFieldValidator(value),
              ),
              SizedBox(height: 10.0),
              imageUrl.value.isEmpty
                  ? InkWell(
                      onTap: () async {
                        imageFile.value = await getImage();
                        imageUrl.value = await firebaseStorageService
                            .uploadImage(imageFile.value);
                      },
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            width: 120.0,
                            height: 120.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                image: AssetImage(
                                    'assets/images/picture_placeholder.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20.0,
                            child: Text(
                              'tap \nto add picture',
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black.withOpacity(0.8)),
                            ),
                          ),
                        ],
                      ))
                  : InkWell(
                      onTap: () async {
                        imageFile.value = await getImage();
                        imageUrl.value = await firebaseStorageService
                            .uploadImage(imageFile.value);
                      },
                      child: Image.network(
                        imageUrl.value,
                      ),
                    ),
              MaterialButton(
                color: Colors.amberAccent,
                child: Text(
                  'Update Item',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1),
                ),
                onPressed: () async {
                  Grocery item = Grocery(
                    name: nameTxtController.text,
                    quantity: int.parse(quantityTxtController.text.trim()),
                    unit: unitTxtController.text,
                    price: double.parse(priceTxtController.text.trim()),
                    imageUrl: imageUrl.value,
                  );
                  if (_formEditKey.currentState.validate()) {
                    if (itemToEdit.reference.parent.id == 'groceries') {
                      await groceryCollectionProvider.updateItem(
                          itemToEdit.id, item);
                      Navigator.pop(context, false);
                    } else {
                      await favCollectionProvider.updateItem(
                          itemToEdit.id, item);
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
