import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../models/priority.dart';
import '../screens/add_task_screen.dart';
import '../providers/task_provider.dart';
import '../providers/unplanned_tasks_provider.dart';

class TaskCard extends ConsumerStatefulWidget {
	final Task task;
	final bool isUnplanned;
	final Function(String)? onTaskCompleted;
	final bool isCompleted;

	const TaskCard({
		Key? key,
		required this.task,
		this.isUnplanned = false,
		this.onTaskCompleted,
		this.isCompleted = false,
	}) : super(key: key);

	@override
	ConsumerState<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends ConsumerState<TaskCard> with SingleTickerProviderStateMixin {
	late AnimationController _animationController;
	late Animation<Offset> _slideAnimation;
	late Animation<double> _fadeAnimation;
	bool _isCompleted = false;

	@override
	void initState() {
		super.initState();
		_isCompleted = widget.isCompleted;
		_animationController = AnimationController(
			duration: const Duration(milliseconds: 300),
			vsync: this,
		);

		_slideAnimation = Tween<Offset>(
			begin: Offset.zero,
			end: const Offset(-1.5, 0),
		).animate(CurvedAnimation(
			parent: _animationController,
			curve: Curves.easeOut,
		));

		_fadeAnimation = Tween<double>(
			begin: 1.0,
			end: 0.0,
		).animate(CurvedAnimation(
			parent: _animationController,
			curve: Curves.easeOut,
		));
	}

	@override
	void dispose() {
		_animationController.dispose();
		super.dispose();
	}

	Future<void> _deleteTask() async {
		await _animationController.forward();
		if (widget.isUnplanned) {
			ref.read(unplannedTasksProvider.notifier).removeTask(widget.task);
		} else {
			ref.read(taskProvider.notifier).removeTask(widget.task);
		}
	}

	Future<void> _showDeleteConfirmation(BuildContext context) async {
		return showDialog(
			context: context,
			builder: (BuildContext context) {
				return AlertDialog(
					title: const Text('Delete Task'),
					content: const Text('Are you sure you want to delete this task?'),
					actions: [
						TextButton(
							onPressed: () => Navigator.pop(context),
							child: const Text('Cancel'),
						),
						TextButton(
							onPressed: () {
								Navigator.pop(context);
								_deleteTask();
							},
							child: const Text(
								'Delete',
								style: TextStyle(color: Colors.red),
							),
						),
					],
				);
			},
		);
	}



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
		if (_isCompleted) return;

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
									final updatedTask = widget.task.copyWith(isCompleted: true);
									if (widget.isUnplanned) {
										ref.read(unplannedTasksProvider.notifier).updateTask(widget.task, updatedTask);
									} else {
										ref.read(taskProvider.notifier).updateTask(widget.task, updatedTask);
									}
									setState(() {
										_isCompleted = true;
									});
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
												selectedDate: widget.task.date,
												taskToEdit: widget.task,
											),
										),
									);
									if (editedTask != null) {
										if (widget.isUnplanned) {
											ref.read(unplannedTasksProvider.notifier).updateTask(widget.task, editedTask);
										} else {
											ref.read(taskProvider.notifier).updateTask(widget.task, editedTask);
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
									_showDeleteConfirmation(context);
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
	Widget build(BuildContext context) {
		final priority = widget.task.priority != null
				? TaskPriority.values.firstWhere((e) => e.toString() == widget.task.priority)
				: null;
		final gradientColors = _getPriorityGradient(priority);
		
		return SlideTransition(
			position: _slideAnimation,
			child: FadeTransition(
				opacity: _fadeAnimation,
				child: AnimatedOpacity(
					duration: const Duration(milliseconds: 300),
					opacity: _isCompleted ? 0.6 : 1.0,
					child: IgnorePointer(
						ignoring: _isCompleted,
						child: GestureDetector(
							onTap: () => _showOptionsDialog(context, ref),
				child: Stack(
					children: [
						Container(
							margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
							decoration: BoxDecoration(
								gradient: _isCompleted 
									? LinearGradient(
											colors: [Colors.blue[200]!, Colors.blue[300]!],
											begin: Alignment.topLeft,
											end: Alignment.bottomRight,
										)
									: LinearGradient(
											colors: gradientColors,
											begin: Alignment.topLeft,
											end: Alignment.bottomRight,
										),
								borderRadius: BorderRadius.circular(16),
								boxShadow: [
									BoxShadow(
										color: _isCompleted 
											? Colors.blue[300]!.withOpacity(0.3)
											: gradientColors[0].withOpacity(0.3),
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
														widget.task.title,
														style: const TextStyle(
															fontSize: 18,
															fontWeight: FontWeight.bold,
															color: Colors.black87,
														),
													),
												),
												if (widget.task.time != null)
													Container(
														padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
														decoration: BoxDecoration(
															color: Colors.black.withOpacity(0.1),
															borderRadius: BorderRadius.circular(12),
														),
														child: Text(
															widget.task.time!.format(context),
															style: const TextStyle(
																fontSize: 12,
																fontWeight: FontWeight.w500,
																color: Colors.black87,
															),
														),
													),
											],
										),
										if (widget.task.description.isNotEmpty) ...[
											const SizedBox(height: 8),
											Text(
												widget.task.description,
												style: TextStyle(
													fontSize: 14,
													color: Colors.black87.withOpacity(0.7),
												),
											),
										],
										if (widget.task.subtasks.isNotEmpty) ...[
											const SizedBox(height: 16),
											Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													LinearProgressIndicator(
														value: 0.0,
														backgroundColor: Colors.black12,
														valueColor: AlwaysStoppedAnimation<Color>(
															Colors.black.withOpacity(0.5),
														),
													),
													const SizedBox(height: 12),
													...widget.task.subtasks.map((subtask) => Padding(
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
						if (_isCompleted)
							AnimatedOpacity(
								duration: const Duration(milliseconds: 300),
								opacity: _isCompleted ? 1.0 : 0.0,
								child: Positioned.fill(
									child: ClipRRect(
										borderRadius: BorderRadius.circular(16),
										child: BackdropFilter(
											filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
											child: Container(
												color: Colors.blue[100]!.withOpacity(0.3),
												child: const Center(
													child: Icon(
														Icons.check_circle,
														color: Colors.white,
														size: 40,
													),
												),
											),
										),
									),
								),
							),
					],
				),
			),
      ))));


	}
}