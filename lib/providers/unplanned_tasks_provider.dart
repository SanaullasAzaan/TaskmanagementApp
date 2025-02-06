import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';

class UnplannedTasksNotifier extends StateNotifier<List<Task>> {
	UnplannedTasksNotifier() : super([]);

	void addTask(Task task) {
		state = [...state, task];
	}

	void removeTask(Task task) {
		state = state.where((t) => t.id != task.id).toList();
	}

	void updateTask(Task oldTask, Task newTask) {
		state = state.map((task) => task.id == oldTask.id ? newTask : task).toList();
	}

	List<Task> getTasksForDate(DateTime date) {
		return state.where((task) => 
			task.date.year == date.year && 
			task.date.month == date.month && 
			task.date.day == date.day
		).toList();
	}
}

final unplannedTasksProvider = StateNotifierProvider<UnplannedTasksNotifier, List<Task>>(
	(ref) => UnplannedTasksNotifier(),
);
