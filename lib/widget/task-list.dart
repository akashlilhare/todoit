import 'package:flutter/cupertino.dart';
import 'package:todoit/models/task-model.dart';

import 'TaskData.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Task> tasks = [
    Task(date: DateTime.now().toString(), name: 'buy milk'),
    Task(date: DateTime.now().toString(), name: 'buy book'),
    Task(date: DateTime.now().toString(), name: 'buy pen')
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskData(
            date: tasks[index].date,
            isChecked: tasks[index].isDone,
            taskTitle: tasks[index].name,
            checkboxCallback: (checkboxState) {
              setState(() {
                tasks[index].toggleDone();
              });
            },
          );
        });
  }
}
