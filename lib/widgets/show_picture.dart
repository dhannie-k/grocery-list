import 'package:flutter/material.dart';

class DisplayPicture extends StatelessWidget {
  final String imgUrl;

  const DisplayPicture({Key key, @required this.imgUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.network(imgUrl),
      ),
    );
  }
}
