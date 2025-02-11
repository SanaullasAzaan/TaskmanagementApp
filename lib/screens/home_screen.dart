import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gig_task_management_app/models/task.dart';
import 'package:gig_task_management_app/services/task_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/date_header.dart';
import '../widgets/custom_bottom_nav.dart';
import 'add_task_screen.dart';
import '../providers/task_provider.dart';
import '../providers/unplanned_tasks_provider.dart';
import 'unplanned_task_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
	const HomeScreen({Key? key}) : super(key: key);

	@override
	ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
	late AnimationController _blurAnimationController;
	Map<String, bool> _completedTaskIds = {};

	@override
	void initState() {
		super.initState();
		_blurAnimationController = AnimationController(
			duration: const Duration(milliseconds: 500),
			vsync: this,
		);
	}

	@override
	void dispose() {
		_blurAnimationController.dispose();
		super.dispose();
	}

	void onTaskCompleted(String taskId) {
		setState(() {
			_completedTaskIds[taskId] = true;
		});
		_blurAnimationController.forward().then((_) {
			// After animation completes, you might want to remove the task or update UI
			Future.delayed(const Duration(milliseconds: 500), () {
				setState(() {
					_completedTaskIds.remove(taskId);
				});
			});
		});
	}

	Map<DateTime, List<Task>> _groupTasksByDate(List<Task> tasks) {
		final Map<DateTime, List<Task>> grouped = {};
		for (var task in tasks) {
			final dateKey = DateTime(task.date.year, task.date.month, task.date.day);
			if (!grouped.containsKey(dateKey)) {
				grouped[dateKey] = [];
			}
			grouped[dateKey]!.add(task);
		}
		return grouped;
	}

	@override
	Widget build(BuildContext context) {
		final selectedDate = ref.watch(selectedDateProvider);
		final TaskService _taskService = TaskService();

		return Scaffold(
			backgroundColor: Colors.white,
			appBar: const CustomAppBar(
				title: 'Tasks',
				backgroundColor: Colors.white,
			),
			body: SafeArea(
				child: Column(
					children: [
						Expanded(
              //Displaying Firestore Data
							child: StreamBuilder<List<Task>>(
								stream: _taskService.getPlannedTasks(),
								builder: (context, snapshot) {
									if (snapshot.hasError) {
										return Center(child: Text('Error: ${snapshot.error}'));
									}

									if (snapshot.connectionState == ConnectionState.waiting) {
										return const Center(child: CircularProgressIndicator());
									}

									final tasks = snapshot.data ?? [];
									final tasksByDate = _groupTasksByDate(tasks);

									if (tasks.isEmpty) {
										return const Center(
											child: Text('No tasks yet. Add your first task!'),
										);
									}

									return DateHeader(
										selectedDate: selectedDate,
										onDateSelected: (date) {
											ref.read(selectedDateProvider.notifier).state = date;
										},
										scrollController: ScrollController(),
										tasksByDate: tasksByDate,
										onTaskCompleted: onTaskCompleted,
										completedTaskIds: _completedTaskIds,
									);
								},
							),
						),
					],
				),
			),
			bottomNavigationBar: CustomBottomNavigationBar(
				selectedIndex: 0,
				onItemSelected: (index) {
					if (index == 1) {
						Navigator.pushReplacement(
							context,
							MaterialPageRoute(builder: (context) => const UnplannedTaskScreen()),
						);
					}
				},
			),
			floatingActionButton: FloatingActionButton(
				onPressed: () async {
					await Navigator.push(
						context,
						MaterialPageRoute(
							builder: (context) => AddTaskScreen(selectedDate: selectedDate),
						),
					);
				},
				backgroundColor: Theme.of(context).primaryColor,
				child: const Icon(Icons.add, color: Colors.white),
			),
		);
	}
}

