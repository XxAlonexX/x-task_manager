import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/task.dart';
import '../models/taskstats.dart';

class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';
  final int _perPage = 15; // Number of tasks per page

  //FETCHING TASK FROM DUMMY API
  Future<List<Task>> fetchTasks(int current) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/todos?_page=$current&_limit=$_perPage'),
      );
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.map((taskJson) => Task.fromJson(taskJson)).toList();
    } catch (error) {
      throw Exception('Failed to fetch tasks: $error');
    }
  }

  Future<List<Task>> fetchTaskStatsFromAPI() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/todos'));
      final List<dynamic> responseData = json.decode(response.body);

      return responseData.map((taskJson) => Task.fromJson(taskJson)).toList();
    } catch (error) {
      throw Exception('Failed to fetch task stats: $error');
    }
  }

  Future<List<Task>> fetchTaskStatsExisting(List<Task> existingTasks) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/todos'));
      final List<dynamic> responseData = json.decode(response.body);

      final List<Task> newTasks = responseData
          .map((taskJson) => Task.fromJson(taskJson))
          .where((newTask) => !existingTasks
              .any((existingTask) => existingTask.id == newTask.id))
          .toList();

      return newTasks;
    } catch (error) {
      throw Exception('Failed to fetch task stats: $error');
    }
  }

  //ADD TASK TO API - IF NECESSARY
  Future<void> addTask(String title) async {
    final response = await http.post(
      Uri.parse('$baseUrl/todos'),
      body: json.encode({'title': title, 'completed': false}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      print('Task added successfully');
      //implement code for handling data
    } else {
      throw Exception('Failed to add task');
    }
  }

  //UPDATE TASK TO API - IF NECESSARY
  Future<void> updateTaskCompletion(int taskId, bool completed) async {
    final response = await http.put(
      Uri.parse('$baseUrl/todos/$taskId'),
      body: json.encode({'completed': completed}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      print('Task updated successfully');
    } else {
      throw Exception('Failed to update task completion status');
    }
  }
}
