import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quicktask_assignment_2023mt93409/task_model.dart';

class TaskService {
  static const String _baseUrl = 'https://parseapi.back4app.com';

  static Future<List<Task>> getTasks() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/classes/tasks'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> tasksJson = json.decode(response.body)['results'];
      return tasksJson.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  static Future<Task> createTask(Task task) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/classes/tasks'),
    headers: _headers,
    body: json.encode(task.toJson()),
  );

  if (response.statusCode == 201) {
    final responseBody = json.decode(response.body);
    // Check if the response contains the objectId
    if (responseBody.containsKey('objectId')) {
      // If yes, create a Task object from the response and return it
      return Task(
        objectId: responseBody['objectId'],
        title: task.title,
        dueDate: task.dueDate,
        completed: task.completed,
        description: task.description,
      );
    } else {
      throw Exception('Failed to create task');
    }
  } else {
    throw Exception('Failed to create task');
  }
}
static Future<Task> updateTask(Task task) async {
  final response = await http.put(
    Uri.parse('$_baseUrl/classes/tasks/${task.objectId}'),
    headers: _headers,
    body: json.encode(task.toJson()),
  );

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);
    // Check if the response contains the updatedAt field
    if (responseBody.containsKey('updatedAt')) {
      // If yes, return the updated Task object
      return task.copyWith(
        // You can update other fields if necessary
      );
    } else {
      throw Exception('Failed to update task');
    }
  } else {
    throw Exception('Failed to update task');
  }
}

  static Future<void> deleteTask(String objectId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/classes/tasks/$objectId'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }

  static Map<String, String> get _headers => {
        'X-Parse-Application-Id': '0Vm3pNphvVBZvvr9aW1gtIsENJN1KxD6PfqC2WWB',
        'X-Parse-REST-API-Key': '235DtdXOtK2WppkSOAjkk4sdJbsIlYSOikNA8iFk',
        'Content-Type': 'application/json',
      };
}
