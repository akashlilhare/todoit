import 'package:flutter/cupertino.dart';

import 'TaskData.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TaskData(),
        TaskData(),
        TaskData(),
      ],
    );
  }
}
