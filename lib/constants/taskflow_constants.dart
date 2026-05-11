import 'package:flutter/material.dart';

class TaskFlowConstants {
  const TaskFlowConstants._();

  static const developerName = 'Vaibhav Kumar';
  static const developerRole = 'Aspiring Software Developer';
  static const appTitle = 'TaskFlow';
  static const appSubtitle = 'Smart Task Manager';

  static const categories = ['Personal', 'Work', 'Study', 'Health'];
  static const priorities = ['Low', 'Medium', 'High'];

  static const categoryIcons = <String, IconData>{
    'Personal': Icons.person_outline,
    'Work': Icons.work_outline,
    'Study': Icons.school_outlined,
    'Health': Icons.favorite_border,
  };
}
