import 'package:flutter/material.dart';

class TaskProvider extends ChangeNotifier {
  final List<String> _tasks = ['Task 1', 'Task 2', 'Task 3', 'Task 4'];

  List<String> get tasks => _tasks;

  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }

  void resetTasks() {
    _tasks.clear();
    _tasks.addAll(['Task 1', 'Task 2', 'Task 3', 'Task 4']);
    notifyListeners();
  }
}
