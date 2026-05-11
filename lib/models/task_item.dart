import 'package:cloud_firestore/cloud_firestore.dart';

class TaskItem {
  TaskItem({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.priority,
    required this.category,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String priority;
  final String category;
  final String status;
  final DateTime createdAt;

  bool get isCompleted => status == 'completed';
  bool get isHighPriority => priority == 'High';

  TaskItem copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? priority,
    String? category,
    String? status,
    DateTime? createdAt,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'priority': priority,
      'category': category,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory TaskItem.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return TaskItem(
      id: doc.id,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      date: _readDate(data['date']),
      priority: data['priority'] as String? ?? 'Medium',
      category: data['category'] as String? ?? 'Personal',
      status: data['status'] as String? ?? 'pending',
      createdAt: _readDate(data['createdAt']),
    );
  }

  static DateTime _readDate(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return DateTime.now();
  }
}
