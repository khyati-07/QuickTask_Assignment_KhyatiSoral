import 'package:flutter/material.dart';
import 'package:quicktask_assignment_2023mt93409/task_model.dart';
import 'package:quicktask_assignment_2023mt93409/task_service.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  EditTaskScreen({required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _dueDateController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _dueDateController = TextEditingController(
        text: widget.task.dueDate?.toIso8601String() ?? '');
  }

  Future<void> _updateTask() async {
    if (_titleController.text.isEmpty || _dueDateController.text.isEmpty) {
      _showSnackBar('Please fill in all fields');
      return;
    }

    final updatedTask = widget.task.copyWith(
      title: _titleController.text,
      dueDate: DateTime.parse(_dueDateController.text),
    );

    try {
      await TaskService.updateTask(updatedTask);
      Navigator.pop(context, updatedTask); // Return the updated task
    } catch (e) {
      _showSnackBar('Failed to update task. Please try again later.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _dueDateController,
              decoration: InputDecoration(labelText: 'Due Date (YYYY-MM-DD)'),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateTask,
              child: Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}
