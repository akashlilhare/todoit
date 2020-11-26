import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoit/utils/database_helper.dart';

import '../models/task.dart';

class MyDialog extends StatefulWidget {
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
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 7)),
      lastDate: DateTime.now(),
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
    return Center(
      //   child: Center(
      child: SingleChildScrollView(
        //   elevation: 5,
        child: Card(
          // padding: EdgeInsets.only(
          //     top: 10,
          //     left: 10,
          //     right: 10,
          //     bottom: MediaQuery.of(context).viewInsets.bottom + 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                // height: 10,
                child: TextField(
                  decoration: InputDecoration(
                      alignLabelWithHint: true,
                      //    icon: Icon(Icons.add_box),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      labelText: 'Enter Task',
                      hintText: 'Task Title'),
                  controller: _titleController,
                  keyboardType: TextInputType.text,
                  focusNode: FocusNode(canRequestFocus: true),
                  onChanged: (newValue) {
                    enteredTask = newValue;
                  },
                ),
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Chosen!'
                            : 'Date Selecte : ${DateFormat.MMMEd().format(_selectedDate)}',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Column(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.calendar_today,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: _presentDatePicker,
                            enableFeedback: true,
                            disabledColor: Theme.of(context).primaryColor,
                            focusColor: Colors.lightGreen,
                          ),
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
                        Task newTask = Task(_titleController.text,
                            DateFormat.MMMEd().format(_selectedDate), 1);
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
          ),
        ),
      ),
      // ),
    );
  }
}
