import 'package:flutter/material.dart';

import '../constants/taskflow_palette.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GradientAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
  });

  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(86);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: Navigator.of(context).canPop(),
      toolbarHeight: 86,
      flexibleSpace: Container(decoration: const BoxDecoration(gradient: TaskFlowPalette.appGradient)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          if (subtitle != null)
            Text(
              subtitle!,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
        ],
      ),
      actions: actions,
    );
  }
}
