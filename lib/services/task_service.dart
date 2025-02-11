//Firebase Firestore Operations

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'tasks';

  Future<void> createTask(Task task) async {
    try {
      final docRef = await _firestore.collection(_collection).add({
        'title': task.title,
        'description': task.description ?? '',
        'date': task.date != null ? Timestamp.fromDate(task.date!) : null,
        'time': task.time != null
            ? {'hour': task.time!.hour, 'minute': task.time!.minute}
            : null,
        'subtasks': task.subtasks ?? [],
        'priority': task.priority,
        'isUnplanned': task.isUnplanned,
        'isCompleted': task.isCompleted, // Ensure it's stored in Firestore
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      if (task.id.isEmpty) {
        throw Exception('Cannot update task: Invalid task ID');
      }

      final docRef = _firestore.collection(_collection).doc(task.id);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        throw Exception('Cannot update task: Task not found');
      }

      await docRef.update({
        'title': task.title,
        'description': task.description ?? '',
        'date': task.date != null ? Timestamp.fromDate(task.date!) : null,
        'time': task.time != null
            ? {'hour': task.time!.hour, 'minute': task.time!.minute}
            : null,
        'subtasks': task.subtasks ?? [],
        'priority': task.priority,
        'isUnplanned': task.isUnplanned,
        'isCompleted': task.isCompleted,
        'updatedAt': FieldValue.serverTimestamp(),
      });

    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection(_collection).doc(taskId).delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  Stream<List<Task>> getPlannedTasks() {
    return _firestore
        .collection(_collection)
        .where('isUnplanned', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        Map<String, dynamic>? timeMap;
        if (data['time'] != null) {
          timeMap = Map<String, dynamic>.from(data['time']);
        }
        
        return Task(
          id: doc.id,
          title: data['title'] as String? ?? '',
          description: data['description'] as String? ?? '',
          date: data['date'] != null ? (data['date'] as Timestamp).toDate() : DateTime.now(),
          time: timeMap != null
              ? TimeOfDay(hour: timeMap['hour'], minute: timeMap['minute'])
              : null,
          subtasks: (data['subtasks'] as List<dynamic>?)?.cast<String>() ?? [],
          priority: data['priority'] as String?,
          isUnplanned: false,
          isCompleted: data['isCompleted'] as bool? ?? false,
        );
      }).toList();
    });
  }

  Stream<List<Task>> getUnplannedTasks() {
    return _firestore
        .collection(_collection)
        .where('isUnplanned', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        Map<String, dynamic>? timeMap;
        if (data['time'] != null) {
          timeMap = Map<String, dynamic>.from(data['time']);
        }
        
        return Task(
          id: doc.id,
          title: data['title'] as String? ?? '',
          description: data['description'] as String? ?? '',
          date: DateTime.now(),  // Use current date for unplanned tasks
          time: timeMap != null
              ? TimeOfDay(hour: timeMap['hour'], minute: timeMap['minute'])
              : null,
          subtasks: (data['subtasks'] as List<dynamic>?)?.cast<String>() ?? [],
          priority: data['priority'] as String?,
          isUnplanned: true,
          isCompleted: data['isCompleted'] as bool? ?? false,
        );
      }).toList();
    });
  }
}
