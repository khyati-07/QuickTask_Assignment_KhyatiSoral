import 'package:flutter/material.dart';
import 'package:quicktask_assignment_2023mt93409/task_model.dart';
import 'package:quicktask_assignment_2023mt93409/task_service.dart';

class AddTaskScreen extends StatefulWidget {
  final Function(Task) addTask;

  AddTaskScreen({required this.addTask});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late String _title;
  late DateTime _dueDate;
  late String _description;
  late bool _completed;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _dueDate = DateTime.now();
    _completed = false;
    _title = '';
    _description = '';
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _dueDate = selectedDate;
      });
    }
  }

  Future<void> _addTask() async {
    if (_title.isEmpty || _description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create the new task
      final newTask = Task(
        title: _title,
        dueDate: _dueDate,
        completed: _completed,
        description: _description,
      );

      // Save the task to the database using TaskService
      final createdTask = await TaskService.createTask(newTask);

      // Notify the parent widget
      widget.addTask(createdTask);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task added successfully!')),
      );

      Navigator.pop(context); // Close the AddTask screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add task: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
              // Blue label for Add Task
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
                        'Add Task',
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
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Task Title',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => _title = value,
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Text('Due Date:'),
                        SizedBox(width: 8.0),
                        TextButton(
                          onPressed: () => _selectDueDate(context),
                          child: Text(
                              '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}'),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onChanged: (value) => _description = value,
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Text('Status:'),
                        SizedBox(width: 8.0),
                        Switch(
                          value: _completed,
                          onChanged: (value) {
                            setState(() {
                              _completed = value;
                            });
                          },
                        ),
                        Text(_completed ? 'Complete' : 'Incomplete'),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Center(
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 24.0),
                        ),
                        onPressed: _addTask,
                        child: Text('Add Task'),
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
