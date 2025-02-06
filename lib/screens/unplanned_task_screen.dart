import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/unplanned_app_bar.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/task_card.dart';
import '../models/task.dart';
import 'add_task_screen.dart';
import '../providers/unplanned_tasks_provider.dart';

class UnplannedTaskScreen extends ConsumerWidget {
	const UnplannedTaskScreen({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final tasks = ref.watch(unplannedTasksProvider);

		return Scaffold(
			backgroundColor: Colors.white,
			body: SafeArea(
				child: Column(
					children: [
						const UnplannedAppBar(),
						
						Expanded(
							child: tasks.isEmpty
									? const Center(
											child: Text(
												'No tasks yet',
												style: TextStyle(
													fontSize: 16,
													color: Colors.grey,
												),
											),
										)
									: ListView.builder(
											itemCount: tasks.length,
											padding: const EdgeInsets.all(16),
											itemBuilder: (context, index) {
												return TaskCard(
													task: tasks[index],
													isUnplanned: true,
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
			floatingActionButton: FloatingActionButton(
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
						ref.read(unplannedTasksProvider.notifier).addTask(task);
					}
				},
				backgroundColor: Theme.of(context).primaryColor,
				child: const Icon(Icons.add, color: Colors.white),
			),
		);
	}
}
