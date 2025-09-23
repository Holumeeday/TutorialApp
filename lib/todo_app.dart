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
    {"title": "Learn Flutter", "count": 0},
    {"title": "Do Assignment", "count": 0},
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("To-Do App")),
        actions: [
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
      body: showTasks
          ? ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 1,
                  child: ListTile(
                      title: Text(tasks[index]['title']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, color: Colors.redAccent,),
                            onPressed: () => decrement(index),
                          ),
                          Text("${tasks[index]["count"]}"),
                          IconButton(
                              onPressed: () => increment(index),
                              icon: const Icon(Icons.add, color: Colors.purpleAccent,))
                        ],
                      )),
                );
              })
          : Center(
              child: Container(
                height: 70,
                width: 130,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purpleAccent),
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Total Task: ${tasks.length}',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.purpleAccent),
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
