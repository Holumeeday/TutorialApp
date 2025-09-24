import 'package:flutter/material.dart';

class Total_taskscore extends StatelessWidget {
  const Total_taskscore({
    super.key,
    required this.tasks,
  });

  final List<Map<String, dynamic>> tasks;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 70,
        width: 130,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.deepPurpleAccent),
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Total Task: ${tasks.length}',
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.deepPurpleAccent),
            ),
          ),
        ),
      ),
    );
  }
}
