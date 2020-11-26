class Task {
  String _taskName;
  String _taskDate;
  int _isDone;
  int _id;

  Task(this._taskName, this._taskDate, this._isDone);

  Task.map(dynamic obj) {
    this._taskName = obj['taskName'];
    this._taskDate = obj['taskDate'];
    this._isDone = obj['isDone'];
    this._id = obj['id'];
  }

  String get taskName => _taskName;
  String get taskData => _taskDate;
  int get isDone => _isDone;
  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["taskName"] = _taskName;
    map["taskDate"] = _taskDate;
    map["isDone"] = _isDone;
    if (id != null) {
      map["id"] = _id;
    }
    return map;
  }

  Task.fromMap(Map<String, dynamic> map) {
    this._taskName = map["taskName"];
    this._taskDate = map["taskDate"];
    this._isDone = map["isDone"];
    this._id = map["id"];
  }
}
