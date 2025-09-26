import 'package:flutter/material.dart';

import '../model/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onToggleDone;

  const TaskCard({super.key, 
  required this.task, 
  required this.onIncrement, 
  required this.onDecrement, 
  required this.onToggleDone});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: ListTile(
        onTap: (){
          Navigator.pushNamed(context, '/detail', arguments: task);
        },
          leading: IconButton(
              onPressed: onToggleDone,
              icon: Icon(
                task.isDone ? Icons.check_box : Icons.check_box_outline_blank,
                color: task.isDone ? Colors.green : Colors.grey,
              )),
          title: Expanded(
              child: Text(
            task.title,
            style: TextStyle(
                fontSize: 12,
                decoration: task.isDone ? TextDecoration.lineThrough : null,
                color: task.isDone ? Colors.green : Colors.black),
          )),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  icon: const Icon(
                    Icons.remove,
                    color: Colors.redAccent,
                  ),
                  onPressed: onDecrement),
              Text("${task.count}"),
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