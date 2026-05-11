import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/task_item.dart';

class TaskRepository {
  TaskRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _taskCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('tasks');
  }

  Stream<List<TaskItem>> watchTasks(String userId) {
    return _taskCollection(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(TaskItem.fromSnapshot).toList());
  }

  Future<void> addTask(String userId, TaskItem task) async {
    debugPrint(
      'TaskRepository.addTask userId=$userId taskId=${task.id} '
      'path=users/$userId/tasks/${task.id}',
    );
    try {
      await _taskCollection(userId).doc(task.id).set(task.toMap());
      debugPrint('TaskRepository.addTask saved taskId=${task.id}');
    } on FirebaseException catch (error, stackTrace) {
      debugPrint(
        'TaskRepository.addTask FirebaseException '
        'code=${error.code} message=${error.message}',
      );
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    } catch (error, stackTrace) {
      debugPrint('TaskRepository.addTask failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> updateTask(String userId, TaskItem task) async {
    debugPrint(
      'TaskRepository.updateTask userId=$userId taskId=${task.id} '
      'path=users/$userId/tasks/${task.id}',
    );
    try {
      await _taskCollection(userId).doc(task.id).update(task.toMap());
      debugPrint('TaskRepository.updateTask saved taskId=${task.id}');
    } on FirebaseException catch (error, stackTrace) {
      debugPrint(
        'TaskRepository.updateTask FirebaseException '
        'code=${error.code} message=${error.message}',
      );
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    } catch (error, stackTrace) {
      debugPrint('TaskRepository.updateTask failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> deleteTask(String userId, String taskId) {
    return _taskCollection(userId).doc(taskId).delete();
  }

  Future<void> setCompletion({
    required String userId,
    required String taskId,
    required bool isCompleted,
  }) {
    return _taskCollection(userId).doc(taskId).update({
      'status': isCompleted ? 'completed' : 'pending',
    });
  }

  Future<List<TaskItem>> fetchOnce(String userId) async {
    final snapshot = await _taskCollection(userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map(TaskItem.fromSnapshot).toList();
  }
}
