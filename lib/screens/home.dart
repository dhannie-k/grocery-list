import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';

import '../screens/add_item_form.dart';
import '../screens/favorite_items.dart';
import '../screens/grocery_list.dart';

final selectedIndex = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {
  final int initialPage;
  HomeScreen({Key key, this.initialPage = 0}) : super(key: key);
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final pageTitle = ['Grocery List', 'Regularly Bought'];
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final indexState = watch(selectedIndex).state;
    final pageViewItems = [GroceryList(), FavoriteItems()];
    final _pageController = PageController(initialPage: initialPage);
    final _scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'TIME TO SHOP',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Container(
        width: width,
        height: height,
        child: Column(
          children: [
            Container(
              color: Colors.amber,
              height: 40,
              width: width,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: pageTitle.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      context.read(selectedIndex).state = index;
                      _pageController.animateToPage(
                        index,
                        duration: Duration(milliseconds: 250),
                        curve: Curves.linear,
                      );
                    },
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Container(
                          width: width * 0.5,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  pageTitle[index],
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.8),
                                  maxLines: 2,
                                ),
                              ),
                              Container(
                                height: 4.0,
                                width: width,
                                decoration: BoxDecoration(
                                  color: indexState == index
                                      ? Colors.purple[800]
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                children: pageViewItems,
<<<<<<< HEAD
                onPageChanged: (int index) =>
                    context.read(selectedIndex).state = index,
=======
>>>>>>> de7038ea30dab370c28f1fb9cdd790ac3e6a8173
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddItemForm(indexState),
          ),
        ),
        child: Icon(
          Icons.add,
          size: 35.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
