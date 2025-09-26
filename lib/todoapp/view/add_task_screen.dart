import 'package:basicpractices/todoapp/model/task_model.dart';
import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  void _submitTask(BuildContext context){
    if(_formkey.currentState!.validate()){
      final newTask = Task(title: _controller.text);

      Navigator.pop(context, newTask);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: "Task Title"),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return "Please enter a task"; 
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: ()=> _submitTask(context),
                 child: const Text("Add Task")
                 )
            ],
          )
          ),
        ),
    );
  }
}