import 'package:flutter/material.dart';

import '../constants/taskflow_constants.dart';
import '../constants/taskflow_palette.dart';
import '../models/task_item.dart';
import '../utils/date_formatter.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  final TaskItem task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final muted = task.isCompleted ? 0.55 : 1.0;
    final priorityColor = switch (task.priority) {
      'High' => TaskFlowPalette.coral,
      'Medium' => TaskFlowPalette.sun,
      _ => TaskFlowPalette.aurora,
    };

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 22),
        decoration: BoxDecoration(
          color: TaskFlowPalette.coral,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: AnimatedOpacity(
        opacity: muted,
        duration: const Duration(milliseconds: 220),
        child: Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onEdit,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: task.isCompleted,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    onChanged: (_) => onToggle(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.title, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 6),
                        Text(task.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _Pill(
                              icon: TaskFlowConstants.categoryIcons[task.category] ?? Icons.label_outline,
                              label: task.category,
                              color: TaskFlowPalette.violet,
                            ),
                            _Pill(
                              icon: Icons.flag_outlined,
                              label: task.priority,
                              color: priorityColor,
                            ),
                            _Pill(
                              icon: Icons.event_available_outlined,
                              label: DateFormatter.friendly(task.date),
                              color: TaskFlowPalette.aurora,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Edit task',
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.13),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
        ],
      ),
    );
  }
}
