import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';

class TaskStatsCard extends StatelessWidget {
  const TaskStatsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    MediaQueryData mediaQuery = MediaQuery.of(context);

    double widthScaleFactor =
        mediaQuery.size.width / 360.0; // Adjust the reference width as needed
    double heightScaleFactor =
        mediaQuery.size.height / 640.0; // Adjust the reference height as needed

    double scaleFactor = widthScaleFactor < heightScaleFactor
        ? widthScaleFactor
        : heightScaleFactor;

    return Card(
      elevation: 5, // Shadow elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0 * scaleFactor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0 * scaleFactor),
            child: Text(
                'Loaded Pending Tasks: ${taskProvider.getPendingTaskCount()}',
                style: TextStyle(fontSize: 15 * scaleFactor)),
          ),
          Padding(
            padding: EdgeInsets.all(8.0 * scaleFactor),
            child: Text(
              'Completed Tasks: ${taskProvider.getCompletedTaskCount()}',
              style: TextStyle(
                fontSize: 15 * scaleFactor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
