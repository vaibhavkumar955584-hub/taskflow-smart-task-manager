import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/task_filter.dart';
import '../models/task_item.dart';
import '../services/task_repository.dart';

class TaskFlowTaskProvider extends ChangeNotifier {
  TaskFlowTaskProvider(this._repository);

  final TaskRepository _repository;
  final _uuid = const Uuid();

  StreamSubscription<List<TaskItem>>? _taskSubscription;
  List<TaskItem> _tasks = [];
  TaskFilter _filter = TaskFilter.all;
  String _searchTerm = '';
  bool _isLoading = true;
  String? _error;
  String? _activeUserId;

  List<TaskItem> get tasks => _tasks;
  TaskFilter get filter => _filter;
  String get searchTerm => _searchTerm;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<TaskItem> get visibleTasks {
    final normalizedSearch = _searchTerm.trim().toLowerCase();
    return _tasks.where((task) {
      final filterMatch = switch (_filter) {
        TaskFilter.all => true,
        TaskFilter.pending => !task.isCompleted,
        TaskFilter.completed => task.isCompleted,
        TaskFilter.highPriority => task.isHighPriority,
      };
      final searchMatch = normalizedSearch.isEmpty ||
          task.title.toLowerCase().contains(normalizedSearch) ||
          task.description.toLowerCase().contains(normalizedSearch) ||
          task.category.toLowerCase().contains(normalizedSearch);
      return filterMatch && searchMatch;
    }).toList();
  }

  int get completedCount => _tasks.where((task) => task.isCompleted).length;
  int get pendingCount => _tasks.where((task) => !task.isCompleted).length;
  int get highPriorityCount =>
      _tasks.where((task) => task.isHighPriority).length;

  void bindUser(String userId) {
    if (_activeUserId == userId) {
      return;
    }
    _activeUserId = userId;
    _isLoading = true;
    _error = null;
    notifyListeners();

    _taskSubscription?.cancel();
    _taskSubscription = _repository.watchTasks(userId).listen(
      (tasks) {
        _tasks = tasks;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (_) {
        _error = 'Could not load your tasks right now.';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void clearUser() {
    _activeUserId = null;
    _tasks = [];
    _isLoading = false;
    _error = null;
    _taskSubscription?.cancel();
    _taskSubscription = null;
    notifyListeners();
  }

  void setFilter(TaskFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void setSearch(String value) {
    _searchTerm = value;
    notifyListeners();
  }

  Future<void> refresh() async {
    final userId = _activeUserId;
    if (userId == null) {
      return;
    }
    try {
      _tasks = await _repository.fetchOnce(userId);
      _error = null;
    } catch (_) {
      _error = 'Refresh failed. Check your connection.';
    }
    notifyListeners();
  }

  Future<void> saveTask({
    TaskItem? existingTask,
    required String title,
    required String description,
    required DateTime date,
    required String priority,
    required String category,
  }) async {
    final userId = _requireUser();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw StateError('You must be logged in before saving a task.');
    }
    if (currentUser.uid != userId) {
      throw StateError(
        'Signed-in user does not match task owner. authUid=${currentUser.uid}, taskUserId=$userId',
      );
    }
    debugPrint(
      'TaskFlowTaskProvider.saveTask userId=$userId '
      'isNew=${existingTask == null}',
    );
    final now = DateTime.now();
    final task = TaskItem(
      id: existingTask?.id ?? _uuid.v4(),
      title: title.trim(),
      description: description.trim(),
      date: date,
      priority: priority,
      category: category,
      status: existingTask?.status ?? 'pending',
      createdAt: existingTask?.createdAt ?? now,
    );

    try {
      if (existingTask == null) {
        await _repository.addTask(userId, task);
      } else {
        await _repository.updateTask(userId, task);
      }
      _error = null;
    } on FirebaseException catch (error) {
      _error = _friendlyFirestoreMessage(error);
      debugPrint(
        'TaskFlowTaskProvider.saveTask FirebaseException '
        'code=${error.code} message=${error.message}',
      );
      rethrow;
    } catch (error) {
      _error = error.toString();
      debugPrint('TaskFlowTaskProvider.saveTask failed: $error');
      rethrow;
    }
  }

  Future<void> deleteTask(String taskId) {
    return _repository.deleteTask(_requireUser(), taskId);
  }

  Future<void> toggleCompletion(TaskItem task) {
    return _repository.setCompletion(
      userId: _requireUser(),
      taskId: task.id,
      isCompleted: !task.isCompleted,
    );
  }

  String _requireUser() {
    final userId = _activeUserId;
    if (userId == null) {
      throw StateError(
          'No signed-in user is attached to TaskFlowTaskProvider.');
    }
    return userId;
  }

  String _friendlyFirestoreMessage(FirebaseException error) {
    switch (error.code) {
      case 'permission-denied':
        return 'Firestore denied the write. Check rules for users/{uid}/tasks.';
      case 'unavailable':
        return 'Firestore is unavailable. Check your connection and try again.';
      case 'not-found':
        return 'Firestore database or document path was not found.';
      case 'failed-precondition':
        return error.message ??
            'Firestore needs an index or project setup change.';
      default:
        return error.message ?? 'Firestore error: ${error.code}';
    }
  }

  @override
  void dispose() {
    _taskSubscription?.cancel();
    super.dispose();
  }
}
