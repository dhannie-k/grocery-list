import 'package:flutter/material.dart';

void showImageDialog(String imgUrl, BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierColor: Colors.black12.withOpacity(0.6),
    barrierDismissible: false,
    barrierLabel: "Dialog",
    transitionDuration: Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) {
      return SizedBox.expand(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 10,
              child: SizedBox.expand(child: Image.network(imgUrl)),
            ),
            Expanded(
              flex: 1,
              child: SizedBox.expand(
                child: RaisedButton(
                  color: Colors.grey.withOpacity(0.1),
                  child: Icon(
                    Icons.close,
                    size: 30.0,
                    color: Colors.white,
                  ),
                  textColor: Colors.white,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
