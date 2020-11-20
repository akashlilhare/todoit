import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoit/models/task_data.dart';

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  final _titleController = TextEditingController();
  DateTime _selectedDate;
  String enteredTask;

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
      child: Container(
        height: 500,
        width: 400,
        child: SingleChildScrollView(
          child: Card(
            elevation: 5,
            child: Container(
              padding: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                        labelText: 'Task', hintText: 'Task Title'),
                    controller: _titleController,
                    keyboardType: TextInputType.text,
                    onChanged: (newValue) {
                      enteredTask = newValue;
                    },
                  ),
                  Container(
                    height: 70,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            _selectedDate == null
                                ? 'No Date Chosen!'
                                : 'Date Selecte : ${DateFormat.yMd().format(_selectedDate)}',
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
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    //  textColor: Theme.of(context).textTheme.title.color,
                    child: Text('Add Task'),
                    onPressed: () {
                      Provider.of<TaskData>(context, listen: false)
                          .addTask(enteredTask, _selectedDate.toString());
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
