import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/taskflow_palette.dart';
import '../models/task_filter.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/gradient_app_bar.dart';
import '../widgets/quote_panel.dart';
import '../widgets/stat_tile.dart';
import '../widgets/task_card.dart';
import 'task_editor_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openEditor(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const TaskEditorScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'TaskFlow',
        subtitle: 'Plan clearly. Finish calmly.',
        actions: [
          Consumer<TaskFlowThemeProvider>(
            builder: (context, theme, _) => Switch(
              value: theme.isDarkMode,
              onChanged: theme.toggleTheme,
            ),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () => context.read<TaskFlowAuthProvider>().logout(),
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Task'),
      ),
      body: Consumer<TaskFlowTaskProvider>(
        builder: (context, taskState, _) {
          if (taskState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (taskState.error != null) {
            return EmptyState(
              title: 'Task sync paused',
              message: taskState.error!,
              icon: Icons.cloud_off_outlined,
            );
          }

          final visibleTasks = taskState.visibleTasks;
          return RefreshIndicator(
            onRefresh: taskState.refresh,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        GridView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.4,
                          ),
                          children: [
                            StatTile(
                                label: 'Total',
                                value: taskState.tasks.length,
                                icon: Icons.all_inbox_outlined,
                                color: TaskFlowPalette.violet),
                            StatTile(
                                label: 'Pending',
                                value: taskState.pendingCount,
                                icon: Icons.pending_actions_outlined,
                                color: TaskFlowPalette.sun),
                            StatTile(
                                label: 'Completed',
                                value: taskState.completedCount,
                                icon: Icons.verified_outlined,
                                color: TaskFlowPalette.aurora),
                            StatTile(
                                label: 'High Priority',
                                value: taskState.highPriorityCount,
                                icon: Icons.priority_high_rounded,
                                color: TaskFlowPalette.coral),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const QuotePanel(),
                        const SizedBox(height: 14),
                        TextField(
                          onChanged: taskState.setSearch,
                          decoration: const InputDecoration(
                            hintText: 'Search tasks',
                            prefixIcon: Icon(Icons.search_rounded),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: TaskFilter.values.map((filter) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(filter.label),
                                  selected: taskState.filter == filter,
                                  onSelected: (_) =>
                                      taskState.setFilter(filter),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (visibleTasks.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(
                      title: 'No matching tasks',
                      message:
                          'Add a task or adjust your filters to see your flow.',
                      icon: Icons.playlist_add_check_circle_outlined,
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 96),
                    sliver: SliverList.separated(
                      itemCount: visibleTasks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final task = visibleTasks[index];
                        return TaskCard(
                          task: task,
                          onEdit: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => TaskEditorScreen(task: task)),
                          ),
                          onToggle: () => taskState.toggleCompletion(task),
                          onDelete: () async {
                            await taskState.deleteTask(task.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Task deleted.')),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
