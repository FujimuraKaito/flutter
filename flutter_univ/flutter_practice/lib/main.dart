// import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/edit_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> main() async {
  // runAppを呼び出す前にFlutter Engineの機能を利用したい場合にコール
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FirstPage());
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login page',
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> _handleSignIn() async {
    GoogleSignInAccount googleCurrentUser = _googleSignIn.currentUser;
    try {
      if (googleCurrentUser == null)
        googleCurrentUser = await _googleSignIn.signInSilently();
      if (googleCurrentUser == null)
        googleCurrentUser = await _googleSignIn.signIn();
      if (googleCurrentUser == null) return null;

      GoogleSignInAuthentication googleAuth =
          await googleCurrentUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final User user = (await _auth.signInWithCredential(credential)).user;
      print("signed in " + user.displayName);

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void transitionNextPage(User user) {
    if (user == null) return;

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MyApp(userData: user)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ログイン'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text('Sign in Google'),
                onPressed: () {
                  _handleSignIn()
                      .then((User user) => transitionNextPage(user))
                      .catchError((e) => print(e));
                },
              ),
            ]),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final User userData;
  MyApp({this.userData});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User List',
      home: MyHomePage(
        userData: this.userData,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title = 'Add name & age';
  final User userData;
  MyHomePage({this.userData});

  @override
  // _はパッケージのスコープを限定する
  // createStateメソッドでStateを返す(状態を管理する)
  // インスタンス化する
  _MyHomePageState createState() => _MyHomePageState(userData);
}

// Stateを参照することでWidgetの再作成を効率的に行う
// State<T>は型を指定することで親クラス(MyHomePage)で定義された変数を使用できる
class _MyHomePageState extends State<MyHomePage> {
  User userData;
  String name = '';
  String email;
  String photoUrl;
  _MyHomePageState(User userData) {
    this.userData = userData;
    this.name = userData.displayName;
    this.email = userData.email;
    this.photoUrl = userData.photoURL;
  }

  // この中で状態の保持と更新を行える
  TextEditingController _nameController;
  TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
  }

  // _MyHomePageState({this.firestore});

  CollectionReference get users =>
      FirebaseFirestore.instance.collection('user');

  // firebaseに追加する関数
  Future<void> _addAccount() async {
    if (_nameController.text.isEmpty || _ageController.text.isEmpty) {
      throw ('Insert both your name and age');
    } else {
      await users.add({
        'name': _nameController.text.toString(),
        'age': _ageController.text.toString(),
        'created_at': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> _deleteAccount(documentId) async {
    print(documentId);
    try {
      await users.doc(documentId).delete();
    } catch (error) {
      throw error;
    }
  }

  // もちろんここはオーバーライド
  @override
  Widget build(BuildContext context) {
    // Stateクラスを継承したクラスはbuildメソッドでWidgetツリーを返す
    return Scaffold(
      // 親クラス(MyHomePage)で定義した変数を参照するときはwidget.XXX
      // MyHomePageの親クラスで定義された変数も参照することができる
      appBar: AppBar(title: Text(widget.title)),
      // 普通にこのbodyにWidgetツリーを構成することもできる
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditPage(),
              fullscreenDialog: true,
            ),
          );
        },
        tooltip: 'Add User',
        child: Icon(Icons.add),
      ),
    );
  }

  // _buildBodyというWidgetを作る
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // これでfirebaseの値をほぼ同期的に読み込む→公式ドキュメント情報
      stream: FirebaseFirestore.instance
          .collection('user')
          .orderBy('created_at')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.docs);
      },
    );
  }

  // DocumentSnapshotはおそらくfirebase独自の型？
  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Column(
      children: [
        // formの部分
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'name',
          ),
          controller: _nameController,
        ),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'age',
          ),
          controller: _ageController,
        ),
        RaisedButton(
          child: Text('Add a user'),
          onPressed: () async {
            try {
              await _addAccount(); // アカウントを登録する関数
              _nameController.text = '';
              _ageController.text = '';
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
        Text(
          name,
          style: (TextStyle(
            color: Colors.red,
          )),
        ),
        SizedBox(
          height: 600, // must
          child: Container(
            child: ListView(
              itemExtent: 100,
              padding: const EdgeInsets.only(top: 20.0),
              children: snapshot
                  .map(
                    (data) => _buildListItem(context, data),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  // create list view
  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ListTile(
              leading: Text(record.age),
              title: Text(record.name),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPage(
                        record: record,
                      ),
                      fullscreenDialog: true,
                    ),
                  );
                },
              ),
              onLongPress: () async {
                await showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('${record.name}を削除しますか？'),
                      actions: <Widget>[
                        TextButton(
                          child: Text(
                            '削除',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          onPressed: () async {
                            try {
                              Navigator.of(context).pop();
                              await _deleteAccount(record.id); // アカウントを登録する関数
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
                        TextButton(
                          child: Text('閉じる'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// To clean code preference
class Record {
  final String name;
  final String age;
  final String id;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      // assert内の処理がfalseの場合，警告が出る
      // →この場合name,ageは必須パラメータ
      : assert(map['name'] != null),
        assert(map['age'] != null),
        // assert(map['id'] != null),
        name = map['name'],
        age = map['age'],
        /**
         * 重要 reference.idがVueでいうdoc.idとなる　
         */
        id = reference.id;

  // method
  // : means to help other method
  Record.fromSnapshot(DocumentSnapshot snapshot)
      // referenceとしてsnapShot.referenceを渡している
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$age>";
}

// ドキュメントにあった「子供の名前を決める」
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Baby Name Votes')),
//       body: _buildBody(context),
//     );
//   }

//   Widget _buildBody(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       // これでfirebaseの値をほぼ同期的に読み込む
//       stream: FirebaseFirestore.instance.collection('baby').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return LinearProgressIndicator();

//         return _buildList(context, snapshot.data.docs);
//       },
//     );
//   }

//   Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
//     return ListView(
//       padding: const EdgeInsets.only(top: 20.0),
//       children: snapshot.map((data) => _buildListItem(context, data)).toList(),
//     );
//   }

//   // 具体的に表示を作成するところ
//   Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
//     final record = Record.fromSnapshot(data);

//     return Padding(
//       key: ValueKey(record.name),
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey),
//             borderRadius: BorderRadius.circular(5.0),
//           ),
//           child: ListTile(
//             title: Text(record.name),
//             trailing: Text(record.votes.toString()),
//             // onTap: () => record.reference.update({'votes': record.votes + 1})),
//             //
//             // もし同時に二人の人が同じところに投票しても良いようにする
//             // transactionという方法もある
//             // https://codelabs.developers.google.com/codelabs/flutter-firebase/index.html?hl=ja#10
//             onTap: () =>
//                 record.reference.update({'votes': FieldValue.increment(1)}),
//           )),
//     );
//   }
// }
