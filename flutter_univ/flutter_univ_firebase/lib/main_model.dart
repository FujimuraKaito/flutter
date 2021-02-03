import 'package:flutter/material.dart';

class MainModel extends ChangeNotifier {
  String myText = 'Stateless';

  void changeText() {
    myText = '変更したよ';
    notifyListeners();
  }
}
