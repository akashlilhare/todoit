import 'dart:math';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoit/models/task.dart';
import 'package:todoit/utils/database_helper.dart';
import 'package:todoit/widget/my-dialog.dart';
import 'package:todoit/widget/task-list.dart';
import 'package:todoit/widget/update-dialog-box.dart';
import 'package:todoit/admobId.dart';
class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

final List<Task> _taskList = <Task>[];
var random = new Random();

class _TaskScreenState extends State<TaskScreen> {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      testDevices: <String>[],
      nonPersonalizedAds: true,
      keywords: <String>['Time', 'Study', 'Books', 'Management']);

  // BannerAd createBannerAd = BannerAd(
  //     adUnitId: banner,
  //     size: AdSize.smartBanner,
  //     targetingInfo: targetingInfo,
  //     listener: (MobileAdEvent event) {
  //       print("BannerAd $event");
  //     });

  @override
  void initState() {
    setState(() {
      _readTaskList();
    });

    // FirebaseAdMob.instance
    //     .initialize(appId: interstitial);
    // super.initState();
  }

  @override
  void dispose() {
   // createBannerAd.dispose();
    // createInterstitialAd.dispose();
    super.dispose();
  }

  var db = new DatabaseHelper();

  bool showAd = false;
  _readTaskList() async {
    // createBannerAd..isLoaded().then((value) => showAd = value);
    // createBannerAd
    //   ..load()
    //   ..show();

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
  }

  _updateTask(int id, Task toUpdate, int pos) async {
    // createBannerAd..isLoaded().then((value) => showAd = value);
    // createBannerAd
    //   ..load()
    //   ..show();
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
    if (value == true) {
      va = 0;
      await db.update(va, toUpdate);
    } else if (value == false) {
      va = 1;
      await db.update(va, toUpdate);
    }

    // createBannerAd
    //   ..load()
    //   ..show();
    setState(() {
      _taskList.remove(toUpdate);
      _taskList.insert(pos, Task(toUpdate.taskName, toUpdate.taskData, va));
    });
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    int number;
    setState(() {
      number = 1 + random.nextInt(4);
    });

    String image = "assets/t_$number.gif";

    var size = MediaQuery.of(context).size;
    double deviceHeight = size.height;
    double borderRadius = size.width * 0.036;
    bool isPortrait =
        (MediaQuery.of(context).orientation == Orientation.portrait);
    double fabPadding = isPortrait ? deviceHeight * .07 : deviceHeight * .03;

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: fabPadding),
          child: FloatingActionButton(
            tooltip: "Add New Task",
            child: Icon(
              Icons.add,
              color: Colors.black,
            ),
            backgroundColor: Colors.green,
            onPressed: () async {
              // createBannerAd..isLoaded().then((value) => showAd = value);
              // createBannerAd
              //   ..load()
              //   ..show();
              final newTask = await showDialog(
                  context: context,
                  builder: (context) => MyDialog(
                        ctx: _scaffoldKey,
                      ));
              if (newTask.taskData == null || newTask.taskName == null) return;
              setState(() {
                _taskList.insert(0, newTask);
              });
            },
          ),
        ),
        body: SafeArea(
          child: isPortrait
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.only(
                          top: 20.0,
                          left: 30.0,
                          bottom: 10.0,
                          right: 20.0,
                        ),
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Todo-It',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  if (_taskList.length != 0)
                                    Text(
                                      '${_taskList.length.toString()} Task \nRemaining',
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        )),
                    (_taskList.length == 0)
                        ? Expanded(
                            child: Container(
                            //  color: Colors.black,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  image,
                                  scale: 1,
                                  fit: BoxFit.scaleDown,
                                ),
                                Positioned(
                                  top: 50,
                                  left: 50,
                                  child: Text(
                                    'ye !! no task to do !',
                                    style: TextStyle(
                                        color: Colors.lightGreen,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 30),
                                  ),
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                              ),
                            ),
                          ))
                        : Expanded(
                            child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(borderRadius * 1.5),
                                topLeft: Radius.circular(borderRadius * 1.5),
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
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.only(
                          top: 5.0,
                          left: 30.0,
                          bottom: 5.0,
                          right: 30.0,
                        ),
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Todo-It',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    '${_taskList.length.toString()} Task\n To do',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        )),
                    (_taskList.length == 0)
                        ? Expanded(
                            child: Container(
                            //  color: Colors.black,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  image,
                                  scale: 1,
                                  fit: BoxFit.scaleDown,
                                ),
                                Positioned(
                                  top: 20,
                                  left: 50,
                                  child: Text(
                                    'ye !! no task to do !',
                                    style: TextStyle(
                                        color: Colors.lightGreen,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 30),
                                  ),
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                              ),
                            ),
                          ))
                        : Expanded(
                            child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(borderRadius),
                                topLeft: Radius.circular(borderRadius),
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
        ));
  }
}
