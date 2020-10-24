import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';

import '../states/riverpod_state_mgmt.dart';
import '../screens/home.dart';
import '../models/grocery.dart';
import '../utils/image_picker.dart';
import '../utils/form_field_validator.dart';

class AddItemForm extends HookWidget {
  AddItemForm(this.pageIndex);

  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _nameFocusNode = useFocusNode();
    final imageFile = useState(File(''));
    final imageUrl = useState('');
    final isChecked = useState(false);
    final _scrollController = useScrollController();
    final nameTxtController = useTextEditingController();
    final quantityTxtController = useTextEditingController();
    final unitTxtController = useTextEditingController();
    final priceTxtController = useTextEditingController();
    final groceryCollectionProvider = useProvider(groceriesRepoProvider);
    final favCollectionProvider = useProvider(favoriteItemsRepoProvider);
    final firebaseStorageService = useProvider(firebaseStorageProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
        title: Text(
          pageIndex == 0 ? 'Add Grocery' : 'Add Favorite',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            children: [
              TextFormField(
                key: Key('name'),
                autofocus: true,
                focusNode: _nameFocusNode,
                controller: nameTxtController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) => formFieldValidator(value),
              ),
              TextFormField(
                key: Key('qty'),
                controller: quantityTxtController,
                decoration: InputDecoration(labelText: 'quantity'),
                keyboardType: TextInputType.number,
                validator: (value) => validateQuantity(value),
              ),
              TextFormField(
                key: Key('unit'),
                controller: unitTxtController,
                decoration: InputDecoration(labelText: 'unit - ex: 200gr/pack'),
              ),
              TextFormField(
                key: Key('price'),
                controller: priceTxtController,
                decoration: InputDecoration(labelText: 'price'),
                validator: (value) => formFieldValidator(value),
                keyboardType: TextInputType.number,
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
              Row(
                children: [
                  Checkbox(
                      activeColor: Colors.blueGrey,
                      value: isChecked.value,
                      onChanged: (value) {
                        isChecked.value = value;
                      }),
                  Text(pageIndex == 0
                      ? 'Add Item to Favorite?'
                      : 'Add Item to Grocery List?'),
                ],
              ),
              MaterialButton(
                  color: Colors.amberAccent,
                  child: Text(
                    'Add Item',
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
                    if (_formKey.currentState.validate()) {
                      if (pageIndex == 0) {
                        await groceryCollectionProvider.addItem(item);
                        if (isChecked.value == true) {
                          await favCollectionProvider.addItem(item);
                        }
                      } else if (pageIndex == 1) {
                        await favCollectionProvider.addItem(item);
                        if (isChecked.value == true) {
                          await groceryCollectionProvider.addItem(item);
                        }
                      }
                      _formKey.currentState.reset();
                      imageUrl.value = '';
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                elevation: 18.0,
                                title: Text('${item.name} Added'),
                                content: Text('Add New Item?'),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () =>
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen(
                                                      initialPage: pageIndex,
                                                    )),
                                          ),
                                      child: Text('No')),
                                  FlatButton(
                                      onPressed: () async {
                                        FocusScope.of(context)
                                            .requestFocus(_nameFocusNode);
                                        Navigator.pop(context);
                                      },
                                      child: Text('Yes')),
                                ],
                              ));
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
