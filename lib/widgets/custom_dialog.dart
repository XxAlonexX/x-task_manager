import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';

class CustomDialog {
  static Future<void> showAddTaskDialog(BuildContext context) async {
    final TextEditingController controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(controller: controller),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final title = controller.text;
                if (title.isNotEmpty) {
                  Provider.of<TaskProvider>(context, listen: false)
                      .addTask(title);
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
