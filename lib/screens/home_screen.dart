import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gig_task_management_app/models/task.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/date_header.dart';
import '../widgets/custom_bottom_nav.dart';
import 'add_task_screen.dart';
import '../providers/task_provider.dart';
import '../providers/unplanned_tasks_provider.dart';
import 'unplanned_task_screen.dart';

class HomeScreen extends ConsumerWidget {
	const HomeScreen({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final selectedDate = ref.watch(selectedDateProvider);
		final tasks = ref.watch(taskProvider);

		return Scaffold(
			backgroundColor: Colors.white,
			body: SafeArea(
				child: Column(
					children: [
						const CustomAppBar(
							title: 'Tasks',
							backgroundColor: Colors.white,
						),
						DateHeader(
							selectedDate: selectedDate,
							onDateSelected: (date) {
								ref.read(selectedDateProvider.notifier).state = date;
							},
							scrollController: ScrollController(),
							tasksByDate: tasks,
						),

					],
				),
			),
			bottomNavigationBar: CustomBottomNavigationBar(
				selectedIndex: 0,
				onItemSelected: (index) {
					if (index != 0) {
						if (index == 1) {
							Navigator.pushReplacement(
								context,
								MaterialPageRoute(builder: (context) => const UnplannedTaskScreen()),
							);
						}
						// Add other navigation cases as needed
					}
				},
			),
			floatingActionButton: FloatingActionButton(
				onPressed: () async {
					final task = await Navigator.push<Task>(
						context,
						MaterialPageRoute(
							builder: (context) => AddTaskScreen(selectedDate: selectedDate),
						),
					);
					if (task != null) {
						if (task.isUnplanned) {
							// Add to unplanned tasks
							ref.read(unplannedTasksProvider.notifier).addTask(task);
						} else {
							// Add to regular tasks
							ref.read(taskProvider.notifier).addTask(task);
						}
					}
				},
				backgroundColor: Theme.of(context).primaryColor,
				child: const Icon(Icons.add, color: Colors.white),
			),
		);
	}
}
