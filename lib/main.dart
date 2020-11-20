import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoit/models/task_data.dart';
import 'package:todoit/screen/task_screen.dart';

import './models/task_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.lightGreen, accentColor: Colors.blueGrey),
        home: TaskScreen(),
      ),
    );
  }
}
