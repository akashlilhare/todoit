import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoit/widget/task-list.dart';

class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool show = false;
    return Scaffold(
        backgroundColor: Colors.lightGreen,
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          backgroundColor: Colors.lightGreen,
          onPressed: () {
            showDialog(context: context, builder: (context) => MyDialog());
          },
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                top: 60.0,
                left: 30.0,
                bottom: 30.0,
                right: 30.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.list,
                      size: 25,
                      color: Colors.lightGreen,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Todo-It',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '12 Tasks',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            show
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
                      child: TaskList(),
                    ),
                  )
          ],
        ));
  }
}

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    Navigator.pop(context);
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
  }

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
                    decoration:
                        InputDecoration(labelText: 'Title', hintText: 'select'),
                    controller: _titleController,
                    keyboardType: TextInputType.text,
                    onSubmitted: (_) => _submitData(),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Amount'),
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => _submitData(),
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
                            style: Theme.of(context).textTheme.title,
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
                                  color: Theme.of(context).accentColor,
                                ),
                                onPressed: _presentDatePicker,
                                enableFeedback: true,
                                disabledColor: Theme.of(context).accentColor,
                                focusColor: Colors.purple,
                              ),
                              // Text('Choose Date',style: Theme.of(context).textTheme.title,),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  RaisedButton(
                    color: Theme.of(context).accentColor,
                    textColor: Theme.of(context).textTheme.title.color,
                    child: Text('Add Transaction'),
                    onPressed: _submitData,
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
