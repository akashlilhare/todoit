import 'package:flutter/material.dart';

class TaskData extends StatelessWidget {
  final bool isChecked;
  final String taskTitle;
  final String date;
  final Function checkboxCallback;

  TaskData({this.isChecked, this.taskTitle, this.date, this.checkboxCallback});

  void checkBoxCallBack(bool newValue) {}

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          'This is a task',
          style: TextStyle(
              decoration: isChecked ? TextDecoration.lineThrough : null),
        ),
        trailing: Checkbox(
          activeColor: Colors.lightGreen,
          value: isChecked,
          onChanged: checkboxCallback,
        ));
  }
}
