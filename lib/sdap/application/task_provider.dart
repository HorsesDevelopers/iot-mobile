import 'package:flutter/material.dart';
import '../domain/models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  final List<TaskModel> _tasks = [
    TaskModel(title: 'Check Filters', description: 'Inspect water filters for debris and clogs.'),
    TaskModel(title: 'Feed Fish', description: 'Distribute feed to ponds 1, 2 and 4.'),
    TaskModel(title: 'Clean Sensors', description: 'Wipe and calibrate dissolved oxygen sensors.'),
    TaskModel(title: 'System Check', description: 'Verify pH and temperature sensors are online.'),
  ];

  List<TaskModel> get tasks => _tasks;

  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }
}
