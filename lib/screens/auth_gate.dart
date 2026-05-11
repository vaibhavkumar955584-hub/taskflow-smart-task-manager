import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<TaskFlowAuthProvider>();
    return StreamBuilder(
      stream: auth.authChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        final user = snapshot.data;
        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.read<TaskFlowTaskProvider>().clearUser();
            }
          });
          return const LoginScreen();
        }
        context.read<TaskFlowTaskProvider>().bindUser(user.uid);
        return const HomeScreen();
      },
    );
  }
}
