import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../screens/add_task_screen.dart';
import '../providers/task_provider.dart';
import 'task_card.dart';

class DateHeader extends ConsumerWidget {
	final DateTime selectedDate;
	final Function(DateTime) onDateSelected;
	final ScrollController scrollController;
	final Map<DateTime, List<Task>> tasksByDate;
	final Function(String)? onTaskCompleted;
	final Map<String, bool>? completedTaskIds;

	const DateHeader({
		Key? key,
		required this.selectedDate,
		required this.onDateSelected,
		required this.scrollController,
		required this.tasksByDate,
		this.onTaskCompleted,
		this.completedTaskIds,
	}) : super(key: key);

	bool _isSameDay(DateTime date1, DateTime date2) {
		return date1.year == date2.year && 
					 date1.month == date2.month && 
					 date1.day == date2.day;
	}

	@override
	Widget build(BuildContext context, WidgetRef ref) {

		return Expanded(
			child: ListView.builder(
				controller: scrollController,
				itemBuilder: (context, index) {
					final date = DateTime.now().add(Duration(days: index));
					final isSelected = _isSameDay(date, selectedDate);
					final tasksForDate = tasksByDate.entries
							.where((entry) => _isSameDay(entry.key, date))
							.expand((entry) => entry.value)
							.toList();
					
					return Column(
						children: [
							Container(
								width: double.infinity,
								padding: const EdgeInsets.symmetric(vertical: 8),
								decoration: BoxDecoration(
									border: Border(
										bottom: BorderSide(
											color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
											width: 2,
										),
									),
								),
								child: Padding(
									padding: const EdgeInsets.symmetric(horizontal: 16),
									child: Row(
										mainAxisAlignment: MainAxisAlignment.spaceBetween,
										children: [
											Text(
												DateFormat('EEE, MMM d').format(date),
												style: TextStyle(
													color: isSelected ? Theme.of(context).primaryColor : Colors.black,
													fontSize: 18,
													fontWeight: FontWeight.bold,
												),
											),//Today
											if (_isSameDay(date, DateTime.now()))
												Container(
													padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
													decoration: BoxDecoration(
														color: Theme.of(context).primaryColor.withOpacity(0.1),
														borderRadius: BorderRadius.circular(12),
													),
													child: Text(
														'Today',
														style: TextStyle(
															color: Theme.of(context).primaryColor,
															fontSize: 12,
															fontWeight: FontWeight.w500,
														),
													),
												),
										],
									),
								),
							),
							Container(
								width: double.infinity,
								padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
								child: InkWell(
									onTap: () async {
										final task = await Navigator.push<Task>(
											context,
											MaterialPageRoute(
												builder: (context) => AddTaskScreen(selectedDate: date),
											),
										);
										if (task != null) {
											ref.read(taskProvider.notifier).addTask(task);
										}
									},
									child: Row(
										children: const [
											Icon(
												Icons.add,
												size: 20,
												color: Colors.black,
											),
											SizedBox(width: 8),
											Text(
												'Add Task',
												style: TextStyle(
													color: Colors.black,
													fontSize: 14,
													fontWeight: FontWeight.w500,
												),
											),
										],
									),
								),
							),
							if (tasksForDate.isNotEmpty)
								...tasksForDate.map((task) => TaskCard(
									task: task,
									onTaskCompleted: onTaskCompleted,
									isCompleted: completedTaskIds?.containsKey(task.id) ?? false,
								)),
						],
					);
				},
			),
		);
	}
}