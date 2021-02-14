import 'package:flutter/material.dart';

import '../../model/task.dart';

// 実際に一つひとつのタスクを表示する部分
class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final Function(bool) toggleDone;

  // イニシャライズ
  const TaskItem(
      {Key key,
      @required this.onTap,
      @required this.task,
      @required this.toggleDone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      // onTapは引数でGestureDetectorを使って関数にする感じ？
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8).copyWith(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.name,
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  (task.memo.isEmpty)
                      ? Container()
                      : Column(
                          children: [
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              task.memo,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                ],
              ),
            ),
            Checkbox(
              value: task.isDone,
              onChanged: (value) {
                print(value);
                toggleDone(value);
              },
              activeColor: Colors.lightGreen,
            )
          ],
        ),
      ),
    );
  }
}
