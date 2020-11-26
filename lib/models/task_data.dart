import 'package:todoit/utils/database_helper.dart';

import '../models/task.dart';

class TaskHelper {
  var db = new DatabaseHelper();
  Future<int> addTask(String name, String date, int taskDone) async {
    int savedTask = await db.saveTask(Task("$name", "$date", taskDone));
    print(savedTask);
    return savedTask;
  }

  Future<List> getAllTask() async {
    List _task;
    _task = await db.getAllTask();
    for (int i = 0; i < _task.length; i++) {
      Task task = Task.map(_task[i]);
      print(task);
    }
    return _task;
  }
}
