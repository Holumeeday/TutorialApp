import 'package:flutter/material.dart';

class TaskList extends StatelessWidget {
  final List<Map<String, dynamic>> tasks;
  final Function(int) onIncrement;
  final Function(int) onDecrement;
  final Function(int) onToggle;

  const TaskList({
    super.key,
    required this.tasks,
    required this.onIncrement,
    required this.onDecrement,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return TaskCard_(
              isDone: tasks[index]["isDone"],
              title: tasks[index]['title'],
              count: tasks[index]['count'],
              onDecrement: () => onDecrement(index),
              onIncrement: () => onIncrement(index),
              onToggleDone:() => onToggle(index) ,
            );
          }),
    );
  }
}

class TaskCard_ extends StatelessWidget {
  final String title;
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool isDone;
  final VoidCallback onToggleDone;

  const TaskCard_({
    super.key,
    required this.title,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
    required this.isDone,
    required this.onToggleDone
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ListTile(
        leading: IconButton(onPressed: onToggleDone,
         icon: Icon(isDone ? Icons.check_box : Icons.check_box_outline_blank, color: isDone? Colors.green: Colors.grey,)),
          title: Expanded(child: Text(title, style: TextStyle(fontSize: 12, decoration: isDone ? TextDecoration.lineThrough : null, color: isDone? Colors.green : Colors.black),)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              IconButton(
                  icon: const Icon(
                    Icons.remove,
                    color: Colors.redAccent,
                  ),
                  onPressed:  onDecrement),
              Text("$count"),
              IconButton(
                  onPressed: onIncrement,
                  icon: const Icon(
                    Icons.add,
                    color: Colors.green,
                  ))
            ],
          )),
    );
  }
}
