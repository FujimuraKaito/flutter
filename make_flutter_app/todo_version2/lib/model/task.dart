// まずはモデルを作るところから
// オブジェクトとして考える

// 今回はタスクを管理するのでTaskクラスを作る

import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String name;
  String memo;
  bool isDone;
  final String id;
  final DocumentReference reference;
  // 一度初期化すると変わらないのでfinalで宣言
  final DateTime createdAt;
  DateTime updatedAt;

  Task.fromMap(Map<String, dynamic> map, {this.reference})
      // assert内の処理がfalseの場合，警告が出る
      // →この場合name,ageは必須パラメータ
      : assert(map['name'] != null),
        assert(map['memo'] != null),
        // assert(map['id'] != null),
        name = map['name'],
        memo = map['memo'],
        // TODO: ここはよくわからん
        createdAt = DateTime.now(),
        /**
         * 重要 reference.idがVueでいうdoc.idとなる　
         */
        id = reference.id;

  // method
  // : means to help other method
  Task.fromSnapshot(DocumentSnapshot snapshot)
      // referenceとしてsnapShot.referenceを渡している
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  // コンストラクタ
  Task(
      {this.name,
      this.memo,
      this.isDone = false,
      this.id,
      this.reference,
      this.createdAt,
      this.updatedAt});
}
