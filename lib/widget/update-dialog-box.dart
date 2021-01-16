import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:todoit/utils/database_helper.dart';

import '../models/task.dart';

class UpdatedDialogBox extends StatefulWidget {
  final String title;
  final String date;
  UpdatedDialogBox({this.title, this.date});
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<UpdatedDialogBox> {
  DateTime _selectedDate;
  String enteredTask;

  var db = DatabaseHelper();

  void _presentDatePicker() {
    showDatePicker(
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
      context: context,
      initialDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController =
        TextEditingController(text: widget.title);

    bool isPortrait =
        (MediaQuery.of(context).orientation == Orientation.portrait);

    var size = MediaQuery.of(context).size;
    double deviceHeight = size.height;
    double deviceWidth = size.width;
    double borderRadius = size.width * 0.035;
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
      backgroundColor: Colors.white,
      title: (isPortrait)
          ? Text(
              'Update Task',
              style: TextStyle(
                  color: Colors.lightGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            )
          : null,
      titlePadding: EdgeInsets.only(
          top: borderRadius, left: borderRadius, bottom: borderRadius * .5),
      actions: [
        Container(
          color: Colors.white,
          height: isPortrait ? deviceHeight * .3 : deviceHeight * .4,
          width: isPortrait ? deviceWidth : deviceWidth * .9,
          child: isPortrait
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: borderRadius * .5),
                      // height: 10,
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: widget.title,
                            alignLabelWithHint: true,
                            //    icon: Icon(Icons.add_box),
                            border: new OutlineInputBorder(
                              borderRadius:
                                  new BorderRadius.circular(borderRadius),
                              borderSide: new BorderSide(),
                            ),
                            labelText: 'Enter Task',
                            labelStyle: TextStyle(color: Colors.green)
                            //   hintText: 'Task Title'
                            ),
                        controller: _titleController,
                        cursorColor: Colors.lightGreen,
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 15),
                        keyboardType: TextInputType.text,
                        focusNode: FocusNode(canRequestFocus: true),
                        onChanged: (newValue) {
                          enteredTask = newValue;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 0),
                      height: deviceHeight * .1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: RichText(
                                text: _selectedDate == null
                                    ? TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: [
                                            TextSpan(
                                              text: "Date Selected :\n",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 15),
                                            ),
                                            TextSpan(
                                              text: "${widget.date}",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  color: Colors.lightGreen),
                                            ),
                                          ])
                                    : TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: [
                                            TextSpan(
                                              text: "Date Selected :\n",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 15),
                                            ),
                                            TextSpan(
                                              text:
                                                  '${DateFormat.MMMEd().format(_selectedDate)}',
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  color: Colors.lightGreen),
                                            ),
                                          ])),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 0,
                            ),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: [
                                    RawMaterialButton(
                                      child: Icon(
                                        Icons.calendar_today,
                                        color: Colors.black,
                                      ),
                                      fillColor: Colors.lightGreen,
                                      elevation: 5,
                                      splashColor: Colors.green,
                                      shape: CircleBorder(),
                                      padding:
                                          EdgeInsets.all(borderRadius * .5),
                                      onPressed: () {
                                        _presentDatePicker();
                                      },
                                    ),
                                    Text(
                                      "Select Date",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        RaisedButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        SizedBox(
                          width: 5,
                        ),
                        RaisedButton(
                            color: Theme.of(context).primaryColor,
                            child: Text('Update Task'),
                            onPressed: () async {
                              String selectedTask;
                              String selectedDate;
                              enteredTask == null
                                  ? selectedTask = widget.title
                                  : selectedTask = enteredTask;
                              _selectedDate == null
                                  ? selectedDate = widget.date
                                  : selectedDate =
                                      DateFormat.MMMEd().format(_selectedDate);

                              //         if (enteredTask == null) return;
                              print(selectedDate);
                              Task newTask =
                                  Task(selectedTask, selectedDate, 1);

                              await db.updateTask(newTask);
                              Navigator.pop(context, newTask);
                            }),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    )
                  ],
                )
              : SingleChildScrollView(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: borderRadius * .4),
                      child: Text(
                        "Update Task",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.lightGreen),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              padding:
                                  EdgeInsets.symmetric(vertical: borderRadius),
                              width: deviceWidth * .35,
                              height: deviceHeight * .4,
                              child: TextField(
                                decoration: InputDecoration(
                                    hintText: widget.title,
                                    alignLabelWithHint: true,
                                    //    icon: Icon(Icons.add_box),
                                    border: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.circular(
                                          borderRadius),
                                      borderSide: new BorderSide(),
                                    ),
                                    labelText: 'Enter Task',
                                    labelStyle: TextStyle(color: Colors.green)
                                    //   hintText: 'Task Title'
                                    ),
                                controller: _titleController,
                                keyboardType: TextInputType.text,
                                focusNode: FocusNode(canRequestFocus: true),
                                onChanged: (newValue) {
                                  enteredTask = newValue;
                                },
                              ),
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                        Container(
                          height: deviceHeight * .3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                height: deviceHeight * .06,
                                child: RichText(
                                    text: _selectedDate == null
                                        ? TextSpan(
                                            style: DefaultTextStyle.of(context)
                                                .style,
                                            children: [
                                                TextSpan(
                                                  text: "Date Selected : ",
                                                  style: TextStyle(
                                                      decoration:
                                                          TextDecoration.none,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 15),
                                                ),
                                                TextSpan(
                                                  text: "${widget.date}",
                                                  style: TextStyle(
                                                      decoration:
                                                          TextDecoration.none,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14,
                                                      color: Colors.lightGreen),
                                                ),
                                              ])
                                        : TextSpan(
                                            style: DefaultTextStyle.of(context)
                                                .style,
                                            children: [
                                                TextSpan(
                                                  text: "Date Selected : ",
                                                  style: TextStyle(
                                                      decoration:
                                                          TextDecoration.none,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 15),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${DateFormat.MMMEd().format(_selectedDate)}',
                                                  style: TextStyle(
                                                      decoration:
                                                          TextDecoration.none,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14,
                                                      color: Colors.lightGreen),
                                                ),
                                              ])),
                              ),
                              Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 0,
                                  ),
                                  child: RaisedButton(
                                      onPressed: () {
                                        _presentDatePicker();
                                      },
                                      color: Colors.lightGreen,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                            color: Colors.black,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Select Date",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      )))
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            RaisedButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                            SizedBox(
                              width: 5,
                            ),
                            RaisedButton(
                                color: Theme.of(context).primaryColor,
                                child: Text('Update Task'),
                                onPressed: () async {
                                  String selectedTask;
                                  String selectedDate;
                                  enteredTask == null
                                      ? selectedTask = widget.title
                                      : selectedTask = enteredTask;
                                  _selectedDate == null
                                      ? selectedDate = widget.date
                                      : selectedDate = DateFormat.MMMEd()
                                          .format(_selectedDate);

                                  //         if (enteredTask == null) return;
                                  print(selectedDate);
                                  Task newTask =
                                      Task(selectedTask, selectedDate, 1);
                                  await db.updateTask(newTask);
                                  Navigator.pop(context, newTask);
                                }),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                )),
        )
      ],
    );
  }
}
