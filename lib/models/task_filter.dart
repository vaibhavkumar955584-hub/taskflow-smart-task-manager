enum TaskFilter {
  all,
  pending,
  completed,
  highPriority,
}

extension TaskFilterLabel on TaskFilter {
  String get label {
    switch (this) {
      case TaskFilter.all:
        return 'All';
      case TaskFilter.pending:
        return 'Pending';
      case TaskFilter.completed:
        return 'Completed';
      case TaskFilter.highPriority:
        return 'High';
    }
  }
}
