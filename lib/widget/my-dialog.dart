import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoit/models/task.dart';
import 'package:todoit/utils/database_helper.dart';

class MyDialog extends StatefulWidget {
  final ctx;

  MyDialog({this.ctx});
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  final _titleController = TextEditingController();
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
    bool isPortrait =
        (MediaQuery.of(context).orientation == Orientation.portrait);

    var size = MediaQuery.of(context).size;
    double deviceHeight = size.height;
    double deviceWidth = size.width;
    double borderRadius = size.width * 0.035;
    bool dateSelected = true;

    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        title: isPortrait
            ? Text(
                'Add Task',
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
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: "Enter Task",
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
                          height: deviceHeight * .1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              RichText(
                                  text: _selectedDate == null
                                      ? TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                          children: [
                                              TextSpan(
                                                text: "Please Select Date",
                                                style: TextStyle(
                                                    decoration:
                                                        TextDecoration.none,
                                                    color: dateSelected
                                                        ? Colors.black
                                                        : Colors.red,
                                                    fontWeight: dateSelected
                                                        ? FontWeight.w600
                                                        : FontWeight.w800,
                                                    fontSize:
                                                        dateSelected ? 14 : 16),
                                              ),
                                            ])
                                      : TextSpan(
                                          style: DefaultTextStyle.of(context)
                                              .style,
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
                                child: Text('Add Task'),
                                onPressed: () async {
                                  if (_titleController.text == null ||
                                      _selectedDate == null)
                                    setState(() {
                                      dateSelected = true;
                                    });
                                  Task newTask = Task(
                                      _titleController.text,
                                      DateFormat.MMMEd().format(_selectedDate),
                                      1);
                                  int savedItem = await db.saveTask(newTask);
                                  Task addedTask = await db.getTask(savedItem);
                                  Navigator.pop(context, addedTask);
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: borderRadius),
                          child: Text(
                            "Add Task",
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
                                  padding: EdgeInsets.symmetric(
                                      vertical: borderRadius),
                                  width: deviceWidth * .35,
                                  height: deviceHeight * .4,
                                  child: TextField(
                                    decoration: InputDecoration(
                                        hintText: "enter task",
                                        alignLabelWithHint: true,
                                        //    icon: Icon(Icons.add_box),
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(
                                                  borderRadius),
                                          borderSide: new BorderSide(),
                                        ),
                                        labelText: 'Enter Task',
                                        labelStyle:
                                            TextStyle(color: Colors.green)
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                      height: deviceHeight * .06,
                                      child: RichText(
                                          text: _selectedDate == null
                                              ? TextSpan(
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style,
                                                  children: [
                                                      TextSpan(
                                                        text:
                                                            "Please Select Date",
                                                        style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                            color: dateSelected
                                                                ? Colors.black
                                                                : Colors.red,
                                                            fontWeight:
                                                                dateSelected
                                                                    ? FontWeight
                                                                        .w600
                                                                    : FontWeight
                                                                        .w800,
                                                            fontSize:
                                                                dateSelected
                                                                    ? 14
                                                                    : 16),
                                                      ),
                                                    ])
                                              : TextSpan(
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style,
                                                  children: [
                                                      TextSpan(
                                                        text:
                                                            "Date Selected : ",
                                                        style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 15),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            '${DateFormat.MMMEd().format(_selectedDate)}',
                                                        style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 14,
                                                            color: Colors
                                                                .lightGreen),
                                                      ),
                                                    ]))),
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
                                                    fontWeight:
                                                        FontWeight.w500),
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
                                    child: Text('Add Task'),
                                    onPressed: () async {
                                      if (_titleController.text == null ||
                                          _selectedDate == null) return;
                                      Task newTask = Task(
                                          _titleController.text,
                                          DateFormat.MMMEd()
                                              .format(_selectedDate),
                                          1);
                                      int savedItem =
                                          await db.saveTask(newTask);
                                      Task addedTask =
                                          await db.getTask(savedItem);
                                      Navigator.pop(context, addedTask);
                                    }),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    )))
        ]);
  }
}
