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
  late TextEditingController _descriptionController;
  DateTime? _selectedDueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description ?? '');
    _selectedDueDate = widget.task.dueDate;
  }

  Future<void> _selectDueDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDueDate = pickedDate;
      });
    }
  }

  Future<void> _updateTask() async {
    if (_titleController.text.isEmpty || _selectedDueDate == null) {
      _showSnackBar('Please fill in all fields');
      return;
    }

    final updatedTask = widget.task.copyWith(
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: _selectedDueDate,
    );

    try {
      await TaskService.updateTask(updatedTask);
      Navigator.pop(context, updatedTask);
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
      body: Container(
        color: Colors.yellow[100],
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blue label for Edit Task
              Container(
                width: double.infinity,
                color: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Stack(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Center(
                      child: Text(
                        'Edit Task',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Task Title field
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Task Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Description field
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 5,
                    ),
                    SizedBox(height: 20),
                    Text('Due Date:'),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedDueDate != null
                                ? _selectedDueDate!
                                .toLocal()
                                .toString()
                                .split(' ')[0]
                                : 'Select Due Date',
                          ),
                        ),
                        IconButton(
                          onPressed: _selectDueDate,
                          icon: Icon(Icons.calendar_today),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Green background
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 24.0),
                        ),
                        onPressed: _updateTask,
                        child: Text('Update Task'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
