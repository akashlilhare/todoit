import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  final bool isChecked;
  final String taskTitle;
  final String date;
  final Function checkboxCallback;
  final Function onPres;

  TaskItem(
      {this.isChecked,
      this.taskTitle,
      this.date,
      this.checkboxCallback,
      this.onPres});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onPres,
      child: Card(
        elevation: 5,
        child: ListTile(
            leading: CircleAvatar(
              child: Text(taskTitle[0].toUpperCase()),
            ),
            title: Text(
              taskTitle,
              style: TextStyle(
                  decoration: isChecked ? TextDecoration.lineThrough : null),
            ),
            subtitle: Text(date),
            trailing: Checkbox(
              activeColor: Colors.lightGreen,
              value: isChecked,
              onChanged: checkboxCallback,
            )),
      ),
    );
  }
}
