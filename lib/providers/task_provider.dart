//state management

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';

class TaskNotifier extends StateNotifier<Map<DateTime, List<Task>>> {
	TaskNotifier() : super({});

	void addTask(Task task) {
		final existingTasks = state[task.date]?.toList() ?? <Task>[];
		state = {
			...state,
			task.date: [...existingTasks, task],
		};
	}

	void updateTask(Task oldTask, Task newTask) {
		final updatedState = Map<DateTime, List<Task>>.from(state);
		
		// Remove the old task from its date
		if (updatedState.containsKey(oldTask.date)) {
			updatedState[oldTask.date] = updatedState[oldTask.date]!
					.where((t) => t.id != oldTask.id)
					.toList();
			
			// Remove date key if no tasks remain
			if (updatedState[oldTask.date]!.isEmpty) {
				updatedState.remove(oldTask.date);
			}
		}

		// Add the new task to its date
		if (!updatedState.containsKey(newTask.date)) {
			updatedState[newTask.date] = [];
		}
		updatedState[newTask.date]!.add(newTask);

		state = updatedState;
	}

	void removeTask(Task task) {
		final tasks = state[task.date]?.toList() ?? <Task>[];
		state = {
			...state,
			task.date: tasks.where((t) => t.id != task.id).toList(),
		};
	}

	List<Task> getTasksForDate(DateTime date) {
		return state[date]?.toList() ?? <Task>[];
	}
}

final taskProvider = StateNotifierProvider<TaskNotifier, Map<DateTime, List<Task>>>(
	(ref) => TaskNotifier(),
);

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());