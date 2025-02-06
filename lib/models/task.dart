import 'package:flutter/material.dart';

class Task {
	final String id;
	final String title;
	final String description;
	final DateTime date;
	final TimeOfDay? time;
	final List<String> subtasks;
	final String? priority;
	final bool isUnplanned;
	final bool isCompleted;

	Task({
		required this.id,
		required this.title,
		required this.description,
		required this.date,
		this.time,
		this.subtasks = const [],
		this.priority,
		this.isUnplanned = false,
		this.isCompleted = false,
	});

	Task copyWith({
		String? id,
		String? title,
		String? description,
		DateTime? date,
		TimeOfDay? time,
		List<String>? subtasks,
		String? priority,
		bool? isUnplanned,
		bool? isCompleted,
	}) {
		return Task(
			id: id ?? this.id,
			title: title ?? this.title,
			description: description ?? this.description,
			date: date ?? this.date,
			time: time ?? this.time,
			subtasks: subtasks ?? this.subtasks,
			priority: priority ?? this.priority,
			isUnplanned: isUnplanned ?? this.isUnplanned,
			isCompleted: isCompleted ?? this.isCompleted,
		);
	}
}