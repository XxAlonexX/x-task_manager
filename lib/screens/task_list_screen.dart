import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/api_task_stats.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/task_list_item.dart';
import '../widgets/task_stats_card.dart';
import '../providers/task_provider.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.fetchTasks(); //Fetching data from Dummy API

    // Fetching paginated data using scroller
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (taskProvider.hasMoreData) {
          // Fetch more tasks when scrolled
          taskProvider.fetchMoreTasks();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
      ),
      body: Column(
        children: [
          //[FETCHING TOTAL TASK STATS FROM DUMMY API]
          // ApiTaskStats(),

          //[FETCHING TASK STATS WHEN LIST DATA LOADED]
          const TaskStatsCard(),
          //SHOWING TASK LIST ITEM
          TaskItem(_scrollController),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CustomDialog.showAddTaskDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
