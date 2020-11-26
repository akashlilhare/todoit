import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    TextEditingController _titleController =
        TextEditingController(text: widget.title);
    return AlertDialog(
      title: Text('Update Task'),
      actions: [
        Container(
          height: 200,
          width: 600,
          child: SingleChildScrollView(
            //   elevation: 5,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    // height: 10,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: widget.title,
                        alignLabelWithHint: true,
                        //    icon: Icon(Icons.add_box),
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          borderSide: new BorderSide(),
                        ),
                        labelText: 'Enter Task',
                        //   hintText: 'Task Title'
                      ),
                      controller: _titleController,
                      keyboardType: TextInputType.text,
                      obscuringCharacter: 'w',
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
                                ? 'Date Selected : ${widget.date}'
                                : 'Date Selected : ${DateFormat.MMMEd().format(_selectedDate)}',
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
                            Task newTask = Task(selectedTask, selectedDate, 1);

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
            ),
          ),
        )
      ],
    );
  }
}
