import 'package:flutter/material.dart';

class TaskFlowPalette {
  const TaskFlowPalette._();

  static const aurora = Color(0xFF27C2A5);
  static const coral = Color(0xFFFF6B5F);
  static const ink = Color(0xFF17202A);
  static const mist = Color(0xFFF4F7FB);
  static const navy = Color(0xFF243B53);
  static const sun = Color(0xFFFFC857);
  static const violet = Color(0xFF6C63FF);
  static const cloud = Color(0xFFFFFFFF);

  static const appGradient = LinearGradient(
    colors: [aurora, violet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
