import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoit/models/task.dart';
import 'package:todoit/utils/database_helper.dart';
import 'package:todoit/widget/my-dialog.dart';
import 'package:todoit/widget/task-list.dart';
import 'package:todoit/widget/update-dialog-box.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

final List<Task> _taskList = <Task>[];

class _TaskScreenState extends State<TaskScreen> {
  var db = new DatabaseHelper();

  _readTaskList() async {
    List items = await db.getAllTask();
    items.forEach((item) {
      setState(() {
        _taskList.add(Task.map(item));
      });
    });
  }

  _deleteTask(int id) async {
    setState(() {
      _taskList.removeWhere((element) => element.id == id);
    });
    db.deleteTask(id);
    print(id);
  }

  _updateTask(int id, Task toUpdate, int pos) async {
    final Task newTask = await showDialog(
        context: context,
        builder: (context) => UpdatedDialogBox(
            title: toUpdate.taskName, date: toUpdate.taskData));
    if (newTask.taskName == null || newTask.taskData == null) return;
    setState(() {
      _taskList.removeAt(pos);
      _taskList.insert(pos, newTask);
    });
  }

  _updateCheckbox(int id, bool value, int pos, Task toUpdate) async {
    int va;
    print("id : $id");
    if (value == true) {
      va = 0;
      await db.update(va, toUpdate);
    } else if (value == false) {
      va = 1;
      await db.update(va, toUpdate);
    }

    setState(() {
      // _taskList.remove(toUpdate);
      // _taskList.insert(pos, Task(toUpdate.taskName, toUpdate.taskData, va));
      _readTaskList();
    });
    _taskList.removeRange(0, _taskList.length);
  }

  @override
  void initState() {
    setState(() {
      _readTaskList();
    });
    super.initState();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: "Add New Task",
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Colors.green,
        onPressed: () async {
          final newTask = await showDialog(
              context: context, builder: (context) => MyDialog());
          if (newTask.taskData == null || newTask.taskName == null) return;
          setState(() {
            _taskList.insert(0, newTask);
          });
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.only(
                top: 30.0,
                left: 30.0,
                bottom: 20.0,
                right: 30.0,
              ),
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CircleAvatar(
                    //   backgroundColor: Colors.white,
                    //   child: Icon(
                    //     Icons.list,
                    //     size: 25,
                    //     color: Colors.lightGreen,
                    //   ),
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Todo-It',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${_taskList.length.toString()} Task',
                      style: TextStyle(
                        color: Colors.lightGreen,
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              )),
          (_taskList.length == 0)
              ? Expanded(
                  child: Container(
                  //  color: Colors.white,
                  child: Image.asset(
                    'assets/man.gif',
                    fit: BoxFit.fill,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                ))
              : Expanded(
                  child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  child: TaskList(
                    tasks: _taskList,
                    onLongPress: _deleteTask,
                    onPress: _updateTask,
                    checkboxCallback: _updateCheckbox,
                    currentCtx: _scaffoldKey,
                  ),
                )),
        ],
      ),
    );
  }
}
