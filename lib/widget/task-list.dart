import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoit/models/task.dart';
import 'package:todoit/utils/database_helper.dart';

class TaskList extends StatefulWidget {
  final List<Task> tasks;
  final Function onLongPress;
  final Function onPress;
  final Function checkboxCallback;
  final GlobalKey<ScaffoldState> currentCtx;

  TaskList({
    this.tasks,
    this.onPress,
    this.checkboxCallback,
    this.onLongPress,
    this.currentCtx,
  });
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  var db = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        (MediaQuery.of(context).orientation == Orientation.portrait);
    var size = MediaQuery.of(context).size;
    double deviceHeight = size.height;

    return !isPortrait
        ? GridView.builder(
            padding: EdgeInsets.symmetric(
              vertical: deviceHeight * .05,
              horizontal: deviceHeight * .06,
            ),
            itemCount: widget.tasks.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: deviceHeight * .03,
                mainAxisSpacing: deviceHeight * .03,
                childAspectRatio: 4,
                crossAxisCount: 2),
            itemBuilder: (BuildContext c, int i) {
              int va = widget.tasks[i].isDone;
              bool isChecked;
              if (va == 0) {
                isChecked = true;
              } else {
                isChecked = false;
              }
              int id = widget.tasks[i].id;
              int pos = widget.tasks.indexOf(widget.tasks[i]);
              Task toUpdate = widget.tasks[i];
              return Container(
                decoration: (BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                        Radius.circular(deviceHeight * .04)),
                    border: Border.all(width: 2, color: Colors.green))),
                child: ListTile(

                    title: Text(
                      widget.tasks[i].taskName,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: isChecked ? Colors.red : Colors.black,
                          decoration: isChecked
                              ? TextDecoration.lineThrough
                              : null),
                    ),
                    subtitle: Text(
                      widget.tasks[i].taskData,
                      style: TextStyle(
                        color: Colors.blueGrey,
                      ),
                    ),
                    onLongPress: () {
                      widget.onLongPress(id);
                    },
                    onTap: () {
                      widget.onPress(id, toUpdate, pos);
                    },
                    trailing: Checkbox(
                        activeColor: Colors.red,
                        value: isChecked,
                        onChanged: (bool value) {
                          widget.currentCtx.currentState
                              .hideCurrentSnackBar();
                          if (value == true)
                            widget.currentCtx.currentState
                                .showSnackBar(SnackBar(
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Long press to delete task',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                            ));
                          widget.checkboxCallback(id, value, pos, toUpdate);
                        })),
              );
            })
        : ListView.builder(
          shrinkWrap: true,
            itemCount: widget.tasks.length,
            itemExtent: 85,
            padding: EdgeInsets.all(15),
            itemBuilder: (c, i) {
              int va = widget.tasks[i].isDone;
              bool isChecked;
              if (va == 0) {
                isChecked = true;
              } else {
                isChecked = false;
              }
              int id = widget.tasks[i].id;
              int pos = widget.tasks.indexOf(widget.tasks[i]);
              Task toUpdate = widget.tasks[i];
              return Column(
                children: [
                  Container(
                    //elevation: 5,
                    decoration: (BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.all(Radius.circular(12)),
                        border:
                            Border.all(width: 2, color: Colors.green))),
                    //color: isChecked == true ? Colors.amber : Colors.white,
                    child: ListTile(
                        title: Text(
                          widget.tasks[i].taskName,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color:
                                  isChecked ? Colors.red : Colors.black,
                              decoration: isChecked
                                  ? TextDecoration.lineThrough
                                  : null),
                        ),
                        subtitle: Text(
                          widget.tasks[i].taskData,
                          style: TextStyle(
                            color: Colors.blueGrey,
                          ),
                        ),
                        onLongPress: () {
                          widget.onLongPress(id);
                        },
                        onTap: () {
                          widget.onPress(id, toUpdate, pos);
                        },
                        trailing: Checkbox(
                            activeColor: Colors.red,
                            value: isChecked,
                            onChanged: (bool value) {
                              widget.currentCtx.currentState
                                  .hideCurrentSnackBar();
                              if (value == true)
                                widget.currentCtx.currentState
                                    .showSnackBar(SnackBar(
                                  backgroundColor: Colors.lightGreen,
                                  behavior: SnackBarBehavior.floating,
                                  content: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Long press to delete task',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                ));
                              widget.checkboxCallback(
                                  id, value, pos, toUpdate);
                            })),
                  ),
                ],
              );
            });
  }
}
