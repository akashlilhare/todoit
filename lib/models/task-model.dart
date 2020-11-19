class Task {
  final String name;
  bool isDone;
  final String date;

  Task({
    this.name,
    this.date,
    this.isDone = false,
  });

  void toggleDone() {
    isDone = !isDone;
  }
}
