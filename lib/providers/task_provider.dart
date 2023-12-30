import 'package:flutter/material.dart';

import '../services/api_services.dart';
import '../models/task.dart';
import '../models/taskstats.dart';

class TaskProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Task> _tasks = [];
  List<Task> get tasks => [..._tasks];

  int _currentPage = 1; // api pagination page

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasMoreData = true; // Initialize to true
  bool get hasMoreData => _hasMoreData;

  int getPendingTaskCount() {
    return _tasks.where((task) => !task.completed).length;
  }

  int getCompletedTaskCount() {
    return _tasks.where((task) => task.completed).length;
  }

  // Fetching all tasks from dummy api
  Future<void> fetchTasks() async {
    _isLoading = true;
    _tasks = await _apiService.fetchTasks(_currentPage);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMoreTasks() async {
    try {
      if (!_hasMoreData) {
        print("No more data Available return");
        return; // No need to fetch more if no more data is available
      }

      final List<Task> newTasks =
          await _apiService.fetchTasks(_currentPage + 1);
      if (newTasks.isNotEmpty) {
        _tasks.addAll(newTasks);
        _currentPage++;
        notifyListeners();
      } else {
        _hasMoreData = false; // No more data available
        print("No more data Available");
      }
    } catch (error) {
      throw Exception('Failed to fetch more tasks: $error');
    }
  }

  Future<void> addTask(String title) async {
    final newTask = Task(id: _tasks.length + 1, title: title);
    // _tasks.add(newTask);
    _tasks.insert(0, newTask); // inserting new task in top position
    notifyListeners();
  }

  Future<void> updateTaskCompletion(int taskId, bool completed) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex].completed = completed;
      notifyListeners();
    }
  }

  Future<TaskStats> fetchTaskStatsFromAPI() async {
    try {
      final List<Task> tasks = await _apiService.fetchTaskStatsFromAPI();

      int pendingCount = tasks.where((task) => !task.completed).length;
      int completedCount = tasks.where((task) => task.completed).length;

      return TaskStats(
        pendingCount: pendingCount,
        completedCount: completedCount,
      );
    } catch (error) {
      throw Exception('Failed to fetch task stats: $error');
    }
  }

  // [ADDING AND UPDATING TASK FROM API]

  // Future<void> addTask(String title) async {
  //   await _apiService.addTask(title);
  //   await fetchTasks(); // Refresh the task list after adding a new task
  // }
  //
  // Future<void> updateTaskCompletion(int taskId, bool completed) async {
  //   await _apiService.updateTaskCompletion(taskId, completed);
  //   await fetchTasks(); // Refresh the task list after updating task completion
  // }
}
