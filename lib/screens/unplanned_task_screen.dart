import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gig_task_management_app/providers/unplanned_tasks_provider.dart';
import '../widgets/unplanned_app_bar.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/task_card.dart';
import '../widgets/image_text_container.dart';
import '../models/task.dart';
import 'add_task_screen.dart';
import '../services/task_service.dart';

class UnplannedTaskScreen extends ConsumerWidget {
  const UnplannedTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TaskService _taskService = TaskService();
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const UnplannedAppBar(),
            Expanded(
              child: StreamBuilder<List<Task>>(
                stream: _taskService.getUnplannedTasks(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final tasks = snapshot.data ?? [];

                  if (tasks.isEmpty) {
                    return Center(
                      child: ImageTextContainer(
                        imagePath: 'assets/images/taskplan.png',
                        text: 'No unplanned tasks yet\nAdd your task! by clicking',
                        imageSize: size.width * 0.35,
                        textStyle: TextStyle(
                          fontSize: (size.width * 0.04).clamp(14.0, 18.0),
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(size.width * 0.04),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: size.height * 0.012),
                        child: TaskCard(
                          task: tasks[index],
                          isUnplanned: true,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: 1,
        onItemSelected: (index) {
          if (index != 1) {
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          }
        },
      ),
      floatingActionButton: SizedBox(
        width: size.width * 0.15,
        height: size.width * 0.15,
        child: FloatingActionButton(
          onPressed: () async {
            final task = await Navigator.push<Task>(
              context,
              MaterialPageRoute(
                builder: (context) => AddTaskScreen(
                  selectedDate: DateTime.now(),
                ),
              ),
            );
            if (task != null) {
              await _taskService.createTask(task); // Ensure task is saved in Firestore
              ref.read(unplannedTasksProvider.notifier).addTask(task);
            }
          },
          backgroundColor: theme.primaryColor,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: size.width * 0.07,
          ),
        ),
      ),
    );
  }
}
