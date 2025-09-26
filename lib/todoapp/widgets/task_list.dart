import 'package:basicpractices/todoapp/widgets/task_card.dart';
import 'package:flutter/material.dart';

import '../model/task_model.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(int) onIncrement;
  final Function(int) onDecrement;
  final Function(int) onToggleDone;
  const TaskList({
  super.key, 
  required this.tasks, 
  required this.onIncrement, 
  required this.onDecrement, 
  required this.onToggleDone});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index){
          return TaskCard(
            task: tasks[index], 
            onIncrement: ()=> onIncrement(index), 
            onDecrement: ()=> onDecrement(index), 
            onToggleDone:()=> onToggleDone(index)
            );
        }
        ),
    );
  }
}