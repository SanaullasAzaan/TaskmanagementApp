import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../models/priority.dart';
import '../screens/add_task_screen.dart';
import '../providers/task_provider.dart';
import '../providers/unplanned_tasks_provider.dart';

class TaskCard extends ConsumerWidget {
	final Task task;
	final bool isUnplanned;
	const TaskCard({
		Key? key,
		required this.task,
		this.isUnplanned = false,
	}) : super(key: key);


	// Get gradient colors based on priority
	List<Color> _getPriorityGradient(TaskPriority? priority) {
		if (priority == null) return [Colors.grey[100]!, Colors.grey[200]!];
		
		switch (priority) {
			case TaskPriority.urgent:
				return [const Color(0xFFFF6B6B), const Color(0xFFFF8585)];
			case TaskPriority.high:
				return [const Color(0xFFFFB347), const Color(0xFFFFCC66)];
			case TaskPriority.medium:
				return [const Color(0xFFFAD02C), const Color(0xFFFFE066)];
			case TaskPriority.low:
				return [const Color(0xFF51CF66), const Color(0xFF69DB7C)];
		}
	}

	Future<void> _showOptionsDialog(BuildContext context, WidgetRef ref) async {
		if (task.isCompleted) return;

		await showDialog(
			context: context,
			builder: (BuildContext dialogContext) {
				return AlertDialog(
					shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(15),
					),
					content: Column(
						mainAxisSize: MainAxisSize.min,
						children: [
							_buildOptionTile(
								dialogContext,
								icon: Icons.done_all,
								color: Colors.green,
								title: 'Mark as Complete',
								onTap: () {
									Navigator.pop(dialogContext);
									final updatedTask = task.copyWith(isCompleted: true);
									if (isUnplanned) {
										ref.read(unplannedTasksProvider.notifier).updateTask(task, updatedTask);
									} else {
										ref.read(taskProvider.notifier).updateTask(task, updatedTask);
									}
								},
							),
							const Divider(height: 1),
							_buildOptionTile(
								dialogContext,
								icon: Icons.edit,
								color: Colors.blue,
								title: 'Edit Task',
								onTap: () async {
									Navigator.pop(dialogContext);
									final editedTask = await Navigator.push<Task>(
										context,
										MaterialPageRoute(
											builder: (context) => AddTaskScreen(
												selectedDate: task.date,
												taskToEdit: task,
											),
										),
									);
									if (editedTask != null) {
										if (isUnplanned) {
											ref.read(unplannedTasksProvider.notifier).updateTask(task, editedTask);
										} else {
											ref.read(taskProvider.notifier).updateTask(task, editedTask);
										}
									}
								},
							),
							const Divider(height: 1),
							_buildOptionTile(
								dialogContext,
								icon: Icons.delete,
								color: Colors.red,
								title: 'Delete Task',
								onTap: () {
									Navigator.pop(dialogContext);
									if (isUnplanned) {
										ref.read(unplannedTasksProvider.notifier).removeTask(task);
									} else {
										ref.read(taskProvider.notifier).removeTask(task);
									}
								},
							),
						],
					),
				);
			},
		);

	}

	Widget _buildOptionTile(
		BuildContext context, {
		required IconData icon,
		required Color color,
		required String title,
		required VoidCallback onTap,
	}) {
		return InkWell(
			onTap: onTap,
			borderRadius: BorderRadius.circular(10),
			child: Padding(
				padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
				child: Row(
					children: [
						Icon(icon, color: color, size: 22),
						const SizedBox(width: 12),
						Text(
							title,
							style: const TextStyle(
								fontSize: 16,
								fontWeight: FontWeight.w500,
							),
						),
					],
				),
			),
		);
	}

	@override
	Widget build(BuildContext context, WidgetRef ref) {
		final priority = task.priority != null
				? TaskPriority.values.firstWhere((e) => e.toString() == task.priority)
				: null;
		final gradientColors = _getPriorityGradient(priority);
		
		return AnimatedOpacity(
			duration: const Duration(milliseconds: 300),
			opacity: task.isCompleted ? 0.6 : 1.0,
			child: GestureDetector(
				onTap: () => _showOptionsDialog(context, ref),
				child: Container(
					decoration: BoxDecoration(
						gradient: task.isCompleted ? null : LinearGradient(
							colors: gradientColors,
							begin: Alignment.topLeft,
							end: Alignment.bottomRight,
						),
						borderRadius: BorderRadius.circular(16),
						boxShadow: [
							BoxShadow(
								color: gradientColors[0].withOpacity(0.3),
								blurRadius: 8,
								offset: const Offset(0, 4),
							),
						],
					),
					child: Padding(
						padding: const EdgeInsets.all(16),
						child: Column(

									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Row(
											children: [
												Expanded(
													child: Text(
														task.title,
														style: const TextStyle(
															fontSize: 18,
															fontWeight: FontWeight.bold,
															color: Colors.black87,
														),
													),
												),
												if (task.time != null)
													Container(
														padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
														decoration: BoxDecoration(
															color: Colors.black.withOpacity(0.1),
															borderRadius: BorderRadius.circular(12),
														),
														child: Text(
															task.time!.format(context),
															style: const TextStyle(
																fontSize: 12,
																fontWeight: FontWeight.w500,
																color: Colors.black87,
															),
														),
													),
											],
										),
										if (task.description.isNotEmpty) ...[
											const SizedBox(height: 8),
											Text(
												task.description,
												style: TextStyle(
													fontSize: 14,
													color: Colors.black87.withOpacity(0.7),
												),
											),
										],
										if (task.subtasks.isNotEmpty) ...[
											const SizedBox(height: 16),
											Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													LinearProgressIndicator(
														value: 0.0, // You can add completed subtasks tracking here
														backgroundColor: Colors.black12,
														valueColor: AlwaysStoppedAnimation<Color>(
															Colors.black.withOpacity(0.5),
														),
													),
													const SizedBox(height: 12),
													...task.subtasks.map((subtask) => Padding(
														padding: const EdgeInsets.only(bottom: 8),
														child: Row(
															children: [
																Container(
																	width: 18,
																	height: 18,
																	decoration: BoxDecoration(
																		border: Border.all(
																			color: Colors.black54,
																			width: 2,
																		),
																		borderRadius: BorderRadius.circular(4),
																	),
																),
																const SizedBox(width: 8),
																Expanded(
																	child: Text(
																		subtask,
																		style: const TextStyle(
																			fontSize: 14,
																			color: Colors.black87,
																		),
																	),
																),
															],
														),
													)),
												],
											),
										],
									],
								),
							),
						),
					),
				);
			
		
	}
}