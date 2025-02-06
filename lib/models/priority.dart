import 'package:flutter/material.dart';

enum TaskPriority {
	urgent,
	high,
	medium,
	low,
}

class PriorityHelper {
	static const Map<TaskPriority, Color> priorityColors = {
		TaskPriority.urgent: Colors.red,
		TaskPriority.high: Colors.orange,
		TaskPriority.medium: Colors.yellow,
		TaskPriority.low: Colors.green,
	};

	static const Map<TaskPriority, String> priorityNames = {
		TaskPriority.urgent: 'Urgent',
		TaskPriority.high: 'High',
		TaskPriority.medium: 'Medium',
		TaskPriority.low: 'Low',
	};
}