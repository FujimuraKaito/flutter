import 'package:flutter/material.dart';
import 'package:flutter_univ_firebase/main_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // 定数なのでホットリロードでは更新されない
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: ChangeNotifierProvider<MainModel>(
        create: (_) => MainModel(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Flutter実践'),
          ),
          // modelが変化したらこれ以下が走る
          body: Consumer<MainModel>(builder: (context, model, child) {
            return Center(
              child: Column(
                children: [
                  Text(
                    // modelに作成したMainModelが入っている
                    model.myText,
                    style: TextStyle(
                      fontSize: 32,
                    ),
                  ),
                  RaisedButton(
                    child: Text(
                      'ボタン',
                    ),
                    onPressed: () {
                      // ボタンを押した時にMainModelの関数が呼ばれる
                      model.changeText();
                    },
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
