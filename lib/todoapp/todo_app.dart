import 'package:flutter/material.dart';

import 'model/task_model.dart';
import 'widgets/task_list.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  bool showTasks = true;
  late Future<List<Task>> futureTask;
  List<Task> tasks=[];

  @override
  void initState() {
    super.initState();
    futureTask = loadTask();
    
  }

  Future<List<Task>> loadTask() async{
    await Future.delayed(const Duration(seconds: 4));

    return [
      Task(title: "Learn Flutter"),
      Task(title: "Do Assignment"),
      Task(title: "Follow up with Godwin"),
      Task(title: "Cook my meal"),
      Task(title: "Set up meeting"),
      Task(title: "See Flutter tutorial"),
      Task(title: "Test my application"),
      Task(title: "Asses my work"),
    ];
  }


  void addTask() async{
    final newTask = await Navigator.pushNamed(context, '/add');

    if (newTask != null && newTask is Task){
      setState(() {
        tasks.add(newTask);
      });
    }
  }

  void increment(int index) {
    setState(() {
      tasks[index].count++;
    });
  }

  void decrement(int index) {
    setState(() {
      if (tasks[index].count > 0) {
        tasks[index].count--;
      }
    });
  }

  void toggleDone(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
  child: Column(
    children: [
      // ✅ Header row always visible
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'To-Do',
            style: TextStyle(fontSize: 23),
          ),
          Row(
            children: [
              const SizedBox(
                width: 40,
                child: CircleAvatar(
                  radius: 50,
                  child: Text(
                    "AO",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                ),
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
          ),
        ],
      ),

      const SizedBox(height: 20),

      // 
      Expanded(
        child: FutureBuilder<List<Task>>(
          future: futureTask,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              if (tasks.isEmpty) {
                tasks = snapshot.data!;
              }

              return 
              TaskList(
                tasks: tasks, 
                onIncrement: increment, 
                onDecrement: decrement, 
                onToggleDone: toggleDone
                );
            }
          },
        ),
      ),
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