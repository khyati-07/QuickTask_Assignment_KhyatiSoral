import 'package:flutter/material.dart';
import 'package:quicktask_assignment_2023mt93409/add_task_screen.dart';
import 'package:quicktask_assignment_2023mt93409/edit_task_screen.dart';
import 'package:quicktask_assignment_2023mt93409/task_model.dart';
import 'package:quicktask_assignment_2023mt93409/task_service.dart';
import 'package:intl/intl.dart';

class TaskManagementScreen extends StatefulWidget {
  @override
  _TaskManagementScreenState createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen> {
  late List<Task> _tasks = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tasks = await TaskService.getTasks();
      setState(() {
        _tasks = tasks;
      });
    } catch (e) {
      print('Error loading tasks: $e');
      _showSnackBar('Failed to load tasks. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleTaskStatus(Task task) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final updatedTask = task.copyWith(completed: !task.completed);
      await TaskService.updateTask(updatedTask);
      setState(() {
        _tasks[_tasks.indexWhere((t) => t.objectId == task.objectId)] = updatedTask;
      });
    } catch (e) {
      print('Error updating task status: $e');
      _showSnackBar('Failed to update task status. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showTaskDetails(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Task Details'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Title: ${task.title}'),
            SizedBox(height: 8),
            Text('Description: ${task.description ?? 'No description'}'),
            SizedBox(height: 8),
            Text('Due Date: ${_formatDate(task.dueDate!)}'),
            SizedBox(height: 8),
            Text('Status: ${task.completed ? 'Complete' : 'Incomplete'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _editTask(Task task) async {
    final updatedTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(task: task),
      ),
    );

    if (updatedTask != null) {
      setState(() {
        _tasks[_tasks.indexWhere((t) => t.objectId == updatedTask.objectId)] = updatedTask;
      });
      _showSnackBar('Task edited successfully');
    }
  }

  void _deleteTask(Task task) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await TaskService.deleteTask(task.objectId!);
      setState(() {
        _tasks.remove(task);
      });
    } catch (e) {
      print('Error deleting task: $e');
      _showSnackBar('Failed to delete task. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
          ? Center(child: Text('No tasks available.'))
          : SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Text(
                'Task Management',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              color: Colors.yellow[100],
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Title')),
                  DataColumn(label: Text('Due Date')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Action')),
                ],
                rows: _tasks.map((task) {
                  return DataRow(
                    cells: [
                      DataCell(Text(task.title)),
                      DataCell(Text(_formatDate(task.dueDate!))),
                      DataCell(
                        Row(
                          children: [
                            Text(task.completed ? 'Complete' : 'Incomplete'),
                            SizedBox(width: 8),
                            IconButton(
                              icon: Icon(
                                task.completed ? Icons.toggle_on : Icons.toggle_off,
                                color: task.completed ? Colors.green : Colors.grey,
                              ),
                              onPressed: () => _toggleTaskStatus(task),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.visibility),
                              onPressed: () => _showTaskDetails(task),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _editTask(task),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteTask(task),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // When a new task is added, reload the tasks after it's added.
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(
                addTask: (task) {
                  setState(() {
                    _tasks.add(task);
                  });
                  _showSnackBar('Task added successfully');
                },
              ),
            ),
          );
          if (newTask != null) {
            _loadTasks();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
