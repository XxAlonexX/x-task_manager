import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../models/taskstats.dart';

class ApiTaskStats extends StatelessWidget {
  const ApiTaskStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TaskStats>(
      future: Provider.of<TaskProvider>(context).fetchTaskStatsFromAPI(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('API Pending: ${snapshot.data!.pendingCount}'),
                Text('API Completed: ${snapshot.data!.completedCount}'),
              ],
            ),
          );
        } else {
          return const Text('No data available.');
        }
      },
    );
  }
}
