// A. マテリアルコンポーネントをimportしてこのファイル内で利用可能にする
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/main.dart';

// B. main関数→通常のfulutter runではmain.dartのmain関数が呼ばれる
// void main() {
//   // C. runApp関数
// runApp(EditPage(record: ,));
// }

class EditPage extends StatelessWidget {
  EditPage({this.record});
  final Record record;
  CollectionReference get users =>
      FirebaseFirestore.instance.collection('user');

  @override
  Widget build(BuildContext context) {
    final bool isUpdate = record != null;
    final nameEditingController = TextEditingController();
    final ageEditingController = TextEditingController();

    if (isUpdate) {
      // updateのときは値をもらう
      nameEditingController.text = record.name;
      ageEditingController.text = record.age;
    }

    Future<void> _updateAccount(documentId) async {
      if (nameEditingController.text.isEmpty ||
          ageEditingController.text.isEmpty) {
        throw ('Insert both your name and age');
      } else {
        print(documentId);
        await users.doc(documentId).update({
          'name': nameEditingController.text.toString(),
          'age': ageEditingController.text.toString(),
          'created_at': FieldValue.serverTimestamp(),
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdate ? 'Edit Page' : 'Add User'),
      ),
      body: SizedBox(
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nameEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'name',
                ),
              ),
              TextField(
                controller: ageEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'age',
                ),
              ),
              RaisedButton(
                child: Icon(Icons.done),
                onPressed: () async {
                  try {
                    await _updateAccount(record.id); // アカウントを登録する関数
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Done'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } catch (err) {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(err.toString()),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
              RaisedButton(
                child: Icon(Icons.backspace),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
