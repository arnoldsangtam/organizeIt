import 'package:flutter/material.dart';

import '../constants/text_styles.dart';
import '../models/task.dart';

class TaskAlert extends StatelessWidget {
  final String title;
  final Task newTask;
  const TaskAlert({super.key, required this.newTask, required this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: CustomTextStyles.alertTitle,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  'editTask',
                  arguments: newTask,
                  (Route<dynamic> route) => route.settings.name == 'home',
                );
              },
              child: Text(
                'Edit',
                style: CustomTextStyles.alertButton,
              ),
            ),
            const SizedBox(width: 4),
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  'home',
                  (Route<dynamic> route) => route.settings.name == 'home',
                );
              },
              child: Text(
                'Home',
                style: CustomTextStyles.alertButton,
              ),
            ),
            const SizedBox(width: 4),
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  'createTask',
                  (Route<dynamic> route) => route.settings.name == 'home',
                );
              },
              child: Text(
                'Add New',
                style: CustomTextStyles.alertButton,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
