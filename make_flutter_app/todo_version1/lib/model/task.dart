// まずはモデルを作るところから
// オブジェクトとして考える

// 今回はタスクを管理するのでTaskクラスを作る

class Task {
  String name;
  String memo;
  bool isDone;
  // 一度初期化すると変わらないのでfinalで宣言
  final DateTime createdAt;
  DateTime updatedAt;

  // コンストラクタ
  Task(
      {this.name,
      this.memo,
      this.isDone = false,
      this.createdAt,
      this.updatedAt});
}
