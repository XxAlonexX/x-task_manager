import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_bytetrek/providers/task_provider.dart';

class TaskItem extends StatelessWidget {
  final ScrollController _scrollController;

  const TaskItem(this._scrollController, {super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: taskProvider.tasks.length +
            (taskProvider.hasMoreData
                ? 1
                : 0), // +1 for the loading indicator if there's more data
        itemBuilder: (context, index) {
          if (index < taskProvider.tasks.length) {
            final task = taskProvider.tasks[index];
            return Card(
              elevation: 3, // Shadow elevation
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                tileColor: task.completed ? Colors.green[100] : null,
                title: Text(task.title),
                leading: Checkbox(
                  value: task.completed,
                  onChanged: (value) {
                    taskProvider.updateTaskCompletion(task.id, value ?? false);
                  },
                ),
              ),
            );
          } else if (taskProvider.hasMoreData) {
            // Display a loading indicator
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            print('no more data for shrink');
            return const SizedBox
                .shrink(); // No more data and no loading indicator needed
          }
        },
      ),
    );
  }
}
