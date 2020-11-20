import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/task_data.dart';
import '../widget/TaskItem.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(builder: (context, taskData, child) {
      return ListView.builder(
          itemCount: taskData.taskCount,
          itemBuilder: (context, index) {
            final task = taskData.tasks[index];
            return TaskItem(
                date: task.date,
                isChecked: task.isDone,
                taskTitle: task.name,
                onPres: () {
                  taskData.deleteTask(task);
                },
                checkboxCallback: (checkboxState) {
                  taskData.updateTask(task);
                });
          });
    });
  }
}
