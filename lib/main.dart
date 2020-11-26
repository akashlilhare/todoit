import 'package:flutter/material.dart';

import './screen/task_screen.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.lightGreen, accentColor: Colors.blueGrey),
      home: TaskScreen(),
    );
  }
}
