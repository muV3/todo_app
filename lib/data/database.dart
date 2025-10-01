import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List tasks = [];
  // reference to the Hive box
  final _myBox = Hive.box("todoBox");

  // method to run if the app is opened for the first time
  void createInitialData() {
    tasks = [
      ["Welcome to ToDo App", false],
    ];
  }

  // load the data from database
  void loadData() {
    tasks = _myBox.get("TODOLIST");
  }

  // update the database
  void updateDatabase() {
    _myBox.put("TODOLIST", tasks);
  }
}