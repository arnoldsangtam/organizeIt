import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  // get instance of users hive box
  static var box = Hive.box<User>('users');
  static List users = box.values.toList();

  //get a hive instance of Current user
  User? getCurrentUser() {
    for (int i = 0; i < users.length; i++) {
      if (users[i].isLogin) {
        dynamic currentUser = box.getAt(i);
        return currentUser;
      }
    }
    return null;
  }

  //check it user has task for today - Will be use to display message under
  // Hello Username in homepage
  bool hasTask(String date) {
    dynamic user = getCurrentUser();

    if (user.taskList == null || user.taskList.isEmpty) {
      return false;
    } else {
      for (Task task in user.taskList) {
        if (task.date == date) return true;
      }
      return false;
    }
  }

  //get category task count
  String taskCount(String category, String date) {
    if (hasTask(date)) {
      dynamic task = getTaskList(date);
      if (task != null) {
        List<Task> categoryTasks = task
            .where((task) => task.category.toLowerCase() == category)
            .toList();
        return categoryTasks.length.toString();
      } else {
        return '0';
      }
    } else {
      return '0';
    }
  }

  //get today task list
  List<Task> getTaskList(String date) {
    if (hasTask(date)) {
      dynamic user = getCurrentUser();
      List<Task> tasks =
          user.taskList.where((task) => task.date == date).toList();
      //sort the list with start Time
      tasks.sort((a, b) => DateFormat('hh:mm a')
          .parse(a.startTime)
          .compareTo(DateFormat('hh:mm a').parse(b.startTime)));
      return tasks;
    } else {
      List<Task> tasks = [];
      return tasks;
    }
  }

  //get all dates that has task
  List<String> getDatesWithTask() {
    dynamic user = getCurrentUser();
    if (user.taskList.isNotEmpty) {
      List<Task> tasks = user.taskList;
      List<String> dates = tasks.map<String>((task) => task.date).toList();
      //notifyListeners();
      return dates;
    } else {
      //notifyListeners();
      return [];
    }
  }

  //add task if it doesn't exist
  bool addTask(Task task) {
    dynamic user = getCurrentUser();
    if (user != null) {
      if (user.taskList.contains(task)) {
        return false;
      } else {
        user.taskList.add(task);
        user.save();
        notifyListeners();
        return true;
      }
    } else {
      return false;
    }
  }

  //update task
  void updateTask(Task oldTask, Task newTask) {
    dynamic user = getCurrentUser();
    if (user != null) {
      final int index = user.taskList.indexOf(oldTask);
      if (index != -1) {
        user.taskList[index] = newTask;
        user.save();
        notifyListeners();
      }
    }
  }

  //toggle task completed
  void toggle(Task task) {
    dynamic user = getCurrentUser();
    if (user != null) {
      final int index = user.taskList.indexOf(task);
      user.taskList[index].isCompleted = !user.taskList[index].isCompleted;
      user.save();
      notifyListeners();
    }
  }

  //delete task from Hive
  void deleteTask(Task task) {
    dynamic user = getCurrentUser();
    if (user != null) {
      final int index = user.taskList.indexOf(task);
      user.taskList.removeAt(index);
      user.save();
      notifyListeners();
    }
  }

  //update last task ID of current user
  void updateLastID(int id) {
    dynamic user = getCurrentUser();
    user.lasID = id;
    user.save();
  }

  //refresh
  void refresh() => notifyListeners();
}
