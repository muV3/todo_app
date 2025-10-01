import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/util/dialog_box.dart';
import 'package:todo_app/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  // reference to the Hive box
  final _myBox = Hive.box('todoBox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    // if this is the first time the app is opened, create initial data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      // there is already data in the box, load it
      db.loadData();
    }
    super.initState();
  }

  // Controller for the text field in the dialog box
  final TextEditingController _controller = TextEditingController();


  // Function to handle checkbox changes
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.tasks[index][1] = value;
    });
    db.updateDatabase();
  }

  void addNewTask() {
    showDialog(context: context, builder: (context) {
      return DialogBox(
        controller: _controller,
        onSave: saveNewTask,
        onCancel: () => Navigator.of(context).pop(),
        );
    });
  }

  void deleteTask(int index) {
    setState(() {
      db.tasks.removeAt(index);
    });
    db.updateDatabase();
  }

  void saveNewTask() {
    setState(() {
      db.tasks.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown[300],
        appBar: AppBar(
          title: Text(
            'TO DO',
            style: GoogleFonts.merriweather(
                fontSize: 22,
                fontWeight: FontWeight.bold,
            ),
            ),
        backgroundColor: Colors.brown,
        centerTitle: true,
        ),

        // Button to add new task
        floatingActionButton: FloatingActionButton(
          onPressed: addNewTask,
          backgroundColor: Colors.brown,
          elevation: 1,
          child: Icon(Icons.add, color: Colors.white),
        ),

        body: ListView.builder(
          itemCount: db.tasks.length,
          itemBuilder:(context, index) {
            return ToDoTile(
              taskName: db.tasks[index][0],
              isCompleted: db.tasks[index][1],
              onChanged: (value) => checkBoxChanged(value, index),
              deleteFunction: (context) => deleteTask(index),
            );
          },
        ),
    );
  }
}