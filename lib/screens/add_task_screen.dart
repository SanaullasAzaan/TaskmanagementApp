import 'package:flutter/material.dart';
import '../widgets/add_task_app_bar.dart';
import '../widgets/task_card.dart';
import 'package:intl/intl.dart';
import '../models/priority.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class AddTaskScreen extends StatefulWidget {
	final DateTime selectedDate;
	final Task? taskToEdit;

	const AddTaskScreen({
		Key? key,
		required this.selectedDate,
		this.taskToEdit,
	}) : super(key: key);

	@override
	State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
	final TaskService _taskService = TaskService();
	


	final TextEditingController _titleController = TextEditingController();
	final TextEditingController _descriptionController = TextEditingController();
	final TextEditingController _subtaskController = TextEditingController();
	final List<String> _subtasks = [];
	final FocusNode _titleFocus = FocusNode();
	final FocusNode _descriptionFocus = FocusNode();
	DateTime? _selectedDate;

	@override
	void initState() {
		super.initState();
		_selectedDate = widget.selectedDate;
		
		// Pre-fill data if editing
		if (widget.taskToEdit != null) {
			_titleController.text = widget.taskToEdit!.title;
			_descriptionController.text = widget.taskToEdit!.description;
			_selectedDate = widget.taskToEdit!.date;
			_selectedTime = widget.taskToEdit!.time;
			_subtasks.addAll(widget.taskToEdit!.subtasks);
			if (widget.taskToEdit!.priority != null) {
				_selectedPriority = TaskPriority.values.firstWhere(
					(e) => e.toString() == widget.taskToEdit!.priority,
				);
			}
		}
	}
	TimeOfDay? _selectedTime;
	TaskPriority? _selectedPriority;

	Future<void> _selectDate(BuildContext context) async {
		final bool? isUnplanned = await showDialog<bool>(
			context: context,
			builder: (BuildContext context) {
				return AlertDialog(
					title: const Text('Select Date Type'),
					content: Column(
						mainAxisSize: MainAxisSize.min,
						children: [
							ListTile(
								leading: const Icon(Icons.calendar_today),
								title: const Text('Pick a specific date'),
								onTap: () => Navigator.pop(context, false),
							),
							ListTile(
								leading: const Icon(Icons.calendar_view_day),
								title: const Text('No specific date'),
								subtitle: const Text('Task will be added to unplanned tasks'),
								onTap: () => Navigator.pop(context, true),
							),
						],
					),
				);
			},
		);

		if (isUnplanned == true) {
			setState(() {
				_selectedDate = null;  // null represents unplanned task
			});
		} else if (isUnplanned == false) {
			final DateTime? picked = await showDatePicker(
				context: context,
				initialDate: _selectedDate ?? DateTime.now(),
				firstDate: DateTime.now(),
				lastDate: DateTime(2101),
			);
			if (picked != null && picked != _selectedDate) {
				setState(() {
					_selectedDate = picked;
				});
			}
		}
	}

	Future<void> _selectTime(BuildContext context) async {
		final TimeOfDay? picked = await showTimePicker(
			context: context,
			initialTime: _selectedTime ?? TimeOfDay.now(),
		);
		if (picked != null && picked != _selectedTime) {
			setState(() {
				_selectedTime = picked;
			});
		}
	}

	void _showAddChecklistDialog() {
		showModalBottomSheet(
			context: context,
			isScrollControlled: true,
			backgroundColor: Colors.transparent,
			builder: (BuildContext context) {
				return Padding(
					padding: EdgeInsets.only(
						bottom: MediaQuery.of(context).viewInsets.bottom,
					),
					child: Container(
						padding: const EdgeInsets.all(16),
						decoration: const BoxDecoration(
							color: Colors.white,
							borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
						),
						child: Column(
							mainAxisSize: MainAxisSize.min,
							children: [
								Row(
									children: [
										Expanded(
											child: TextField(
												controller: _subtaskController,
												decoration: const InputDecoration(
													hintText: 'Add subtask',
													border: InputBorder.none,
												),
												autofocus: true,
											),
										),
										IconButton(
											icon: const Icon(Icons.add),
											onPressed: () {
												if (_subtaskController.text.isNotEmpty) {
													setState(() {
														_subtasks.add(_subtaskController.text);
													});
													_subtaskController.clear();
													Navigator.pop(context);
												}
											},
										),
									],
								),
							],
						),
					),
				);
			},
		);
	}


	Future<void> _showPriorityDialog() async {
		await showModalBottomSheet(
			context: context,
			isScrollControlled: true,
			backgroundColor: Colors.transparent,
			builder: (BuildContext context) {
				return TweenAnimationBuilder<double>(
					tween: Tween(begin: 1, end: 0),
					duration: const Duration(milliseconds: 300),
					curve: Curves.easeOut,
					builder: (context, value, child) {
						return Transform.translate(
							offset: Offset(0, value * 400),
							child: child,
						);
					},
					child: Container(
						padding: const EdgeInsets.all(24),
						decoration: const BoxDecoration(
							color: Colors.white,
							borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
						),
						child: Column(
							mainAxisSize: MainAxisSize.min,
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								const Text(
									'Select Priority',
									style: TextStyle(
										fontSize: 18,
										fontWeight: FontWeight.bold,
									),
								),
								const SizedBox(height: 20),
								...TaskPriority.values.map((priority) => InkWell(
									onTap: () {
										setState(() {
											_selectedPriority = priority;
										});
										Navigator.pop(context);
									},
									child: Padding(
										padding: const EdgeInsets.symmetric(vertical: 12),
										child: Row(
											children: [
												Icon(
													Icons.flag,
													color: PriorityHelper.priorityColors[priority],
													size: 24,
												),
												const SizedBox(width: 12),
												Text(
													PriorityHelper.priorityNames[priority]!,
													style: const TextStyle(
														fontSize: 16,
														fontWeight: FontWeight.w500,
													),
												),
											],
										),
									),
								)).toList(),
							],
						),
					),
				);
			},
		);
	}

	Future<void> _saveTask() async {
		if (_titleController.text.isEmpty) return;

		try {
			final taskService = TaskService();
			final task = Task(
				id: widget.taskToEdit?.id ?? '',  // Empty for new tasks
				title: _titleController.text,
				description: _descriptionController.text,
				date: _selectedDate ?? DateTime.now(),
				time: _selectedTime,
				subtasks: _subtasks,
				priority: _selectedPriority?.toString(),
				isUnplanned: _selectedDate == null,
			);

			if (widget.taskToEdit != null) {
				await taskService.updateTask(task);
			} else {
				await taskService.createTask(task);
			}

			if (mounted) {
				ScaffoldMessenger.of(context).showSnackBar(
					const SnackBar(content: Text('Task saved successfully!')),
				);
				Navigator.pop(context);
			}
		} catch (e) {
			if (mounted) {
				ScaffoldMessenger.of(context).showSnackBar(
					SnackBar(content: Text('Failed to save task: $e')),
				);
			}
		}
	}







	@override
	void dispose() {
		_titleController.dispose();
		_descriptionController.dispose();
		_subtaskController.dispose();
		_titleFocus.dispose();
		_descriptionFocus.dispose();
		super.dispose();
	}

	void _unfocusAll() {
		_titleFocus.unfocus();
		_descriptionFocus.unfocus();
	}

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onTap: _unfocusAll,
			child: Scaffold(
				backgroundColor: Colors.white,
				appBar: const AddTaskAppBar(),
				body: SingleChildScrollView(
					padding: const EdgeInsets.all(16),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [

										TextField(
											controller: _titleController,
											focusNode: _titleFocus,
											textInputAction: TextInputAction.next,
											onSubmitted: (_) {
												FocusScope.of(context).requestFocus(_descriptionFocus);
											},
											style: const TextStyle(
												fontSize: 20,
												fontWeight: FontWeight.w600,
												color: Colors.black,
											),
											decoration: const InputDecoration(
												border: InputBorder.none,
												hintText: 'Task Title',
												hintStyle: TextStyle(
													color: Colors.black,
													fontSize: 20,
													fontWeight: FontWeight.w600,
												),
											),
										),
										const SizedBox(height: 20),
										TextField(
											controller: _descriptionController,
											focusNode: _descriptionFocus,
											textInputAction: TextInputAction.done,
											onSubmitted: (_) {
												_unfocusAll();
											},
											maxLines: null,
											style: const TextStyle(
												fontSize: 16,
												color: Colors.black87,
											),
											decoration: const InputDecoration(
												border: InputBorder.none,
												hintText: 'Description',
												hintStyle: TextStyle(
													color: Colors.grey,
													fontSize: 16,
												),
											),
										),
										const SizedBox(height: 20),
										Row(
											children: [
												const Icon(
													Icons.calendar_today,
													color: Colors.black,
													size: 24,
												),
												const SizedBox(width: 16),
												TextButton(
													onPressed: () => _selectDate(context),
													style: TextButton.styleFrom(
														padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
														backgroundColor: Colors.grey[200],
														shape: RoundedRectangleBorder(
															borderRadius: BorderRadius.circular(8),
														),
													),
													child: Text(
														_selectedDate == null
																? 'No specific date'
																: DateFormat('MMM dd, yyyy').format(_selectedDate!),
														style: const TextStyle(
															color: Colors.black,
															fontSize: 14,
															fontWeight: FontWeight.w500,
														),
													),
												),
												const SizedBox(width: 12),
												TextButton(
													onPressed: () => _selectTime(context),
													style: TextButton.styleFrom(
														padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
														backgroundColor: Colors.grey[200],
														shape: RoundedRectangleBorder(
															borderRadius: BorderRadius.circular(8),
														),
													),
													child: Text(
														_selectedTime != null
																? _selectedTime!.format(context)
																: 'Add time',
														style: const TextStyle(
															color: Colors.black,
															fontSize: 14,
															fontWeight: FontWeight.w500,
														),
													),
												),
											],
										),
										const SizedBox(height: 16),
										TextButton(
											onPressed: _showPriorityDialog,
											style: TextButton.styleFrom(
												padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
												backgroundColor: Colors.grey[200],
												shape: RoundedRectangleBorder(
													borderRadius: BorderRadius.circular(8),
												),
											),
											child: Row(
												mainAxisSize: MainAxisSize.min,
												children: [
													Icon(
														Icons.flag,
														size: 20,
														color: _selectedPriority != null 
																? PriorityHelper.priorityColors[_selectedPriority!]
																: Colors.black,
													),
													const SizedBox(width: 8),
													Text(
														_selectedPriority != null 
																? PriorityHelper.priorityNames[_selectedPriority!]!
																: 'Set Priority',
														style: const TextStyle(
															color: Colors.black,
															fontSize: 14,
															fontWeight: FontWeight.w500,
														),
													),
												],
											),
										),
										const SizedBox(height: 12),
										GestureDetector(
											onTap: _showAddChecklistDialog,
											child: Row(
												children: const [
													Icon(
														Icons.check_box_outlined,
														size: 20,
														color: Colors.black,
													),
													SizedBox(width: 8),
													Text(
														'Add Checklist',
														style: TextStyle(
															color: Colors.black,
															fontSize: 14,
															fontWeight: FontWeight.w500,
														),
													),
												],
											),
										),
										const SizedBox(height: 24),


										TextButton(
											onPressed: () {
												Navigator.pop(context);
											},
											style: TextButton.styleFrom(
												padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
												backgroundColor: Colors.grey[200],
												shape: RoundedRectangleBorder(
													borderRadius: BorderRadius.circular(8),
												),
											),
											child: Row(
												mainAxisSize: MainAxisSize.min,
												children: const [
													Icon(
														Icons.delete_outline,
														size: 20,
														color: Colors.black,
													),
													SizedBox(width: 8),
													Text(
														'Discard',
														style: TextStyle(
															color: Colors.black,
															fontSize: 14,
															fontWeight: FontWeight.w500,
														),
													),
												],
											),
										),

									],
								),
							),
							floatingActionButton: FloatingActionButton(
								onPressed: _saveTask,
								backgroundColor: Theme.of(context).primaryColor,
								child: const Icon(Icons.check, color: Colors.white),
							),
						),
					);
				}

}