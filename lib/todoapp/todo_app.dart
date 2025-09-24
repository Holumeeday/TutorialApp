import 'package:basicpractices/todoapp/tasklist.dart';
import 'package:basicpractices/todoapp/total_taskscore.dart';
import 'package:flutter/material.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  bool showTasks = true;

  // Task list
  List<Map<String, dynamic>> tasks = [
    {"title": "Learn Flutter", "count": 0, "isDone": false},
    {"title": "Do Assignment", "count": 0, "isDone": false},
    {"title": "Follow up with Godwin", "count": 0, "isDone": false},
    {"title": "Cook my meal", "count": 0, "isDone": false},
    {"title": "Set up meeting", "count": 0, "isDone": false},
    {"title": "See Flutter tutorial", "count": 0, "isDone": false},
    {"title": "Test my application", "count": 0, "isDone": false},
    {"title": "Asses my work", "count": 0, "isDone": false},
  ];

  void addTask() {
    setState(() {
      tasks.add({"title": "New Task ${tasks.length + 1}", "count": 0});
    });
  }

  void increment(int index) {
    setState(() {
      tasks[index]["count"]++;
    });
  }

  void decrement(int index) {
    setState(() {
      if (tasks[index]["count"] > 0) {
        tasks[index]["count"]--;
      }
    });
  }

  void toggleDone(int index) {
    setState(() {
      tasks[index]["isDone"] = !tasks[index]["isDone"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'To-Do',
                  style: TextStyle(
                    fontSize: 23,
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: CircleAvatar(
                          radius: 50,
                          child: Text(
                            "AO",
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: Colors.deepPurpleAccent),
                          )),
                    ),
                    Switch(
                      value: showTasks,
                      onChanged: (value) {
                        setState(() {
                          showTasks = value;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
            showTasks
                ? TaskList(
                    onToggle: toggleDone,
                    tasks: tasks,
                    onIncrement: increment,
                    onDecrement: decrement)
                : Total_taskscore(tasks: tasks),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
