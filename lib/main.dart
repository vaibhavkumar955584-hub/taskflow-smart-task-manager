import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/quote_provider.dart';
import 'providers/task_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/auth_gate.dart';
import 'screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'services/quote_service.dart';
import 'services/task_repository.dart';
import 'themes/taskflow_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TaskFlowBootstrap());
}

class TaskFlowBootstrap extends StatefulWidget {
  const TaskFlowBootstrap({super.key});

  @override
  State<TaskFlowBootstrap> createState() => _TaskFlowBootstrapState();
}

class _TaskFlowBootstrapState extends State<TaskFlowBootstrap> {
  late final Future<void> _startup = _initializeApp();

  Future<void> _initializeApp() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
    } on FirebaseException catch (error) {
      if (error.code != 'duplicate-app') {
        rethrow;
      }
    }
    await NotificationService.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _startup,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            title: 'TaskFlow - Smart Task Manager',
            debugShowCheckedModeBanner: false,
            theme: TaskFlowTheme.light(),
            darkTheme: TaskFlowTheme.dark(),
            home: const SplashScreen(navigateAfterDelay: false),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            title: 'TaskFlow - Smart Task Manager',
            debugShowCheckedModeBanner: false,
            theme: TaskFlowTheme.light(),
            home: StartupErrorScreen(error: snapshot.error),
          );
        }

        return const TaskFlowApp();
      },
    );
  }
}

class StartupErrorScreen extends StatelessWidget {
  const StartupErrorScreen({super.key, required this.error});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.error_outline_rounded,
                  size: 56, color: Colors.redAccent),
              const SizedBox(height: 18),
              const Text(
                'TaskFlow could not start',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Text(
                error?.toString() ?? 'Unknown startup error.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskFlowThemeProvider()),
        ChangeNotifierProvider(
          create: (_) =>
              TaskFlowAuthProvider(AuthService(FirebaseAuth.instance)),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              TaskFlowTaskProvider(TaskRepository(FirebaseFirestore.instance)),
        ),
        ChangeNotifierProvider(create: (_) => QuoteProvider(QuoteService())),
      ],
      child: Consumer<TaskFlowThemeProvider>(
        builder: (context, theme, _) {
          return MaterialApp(
            title: 'TaskFlow - Smart Task Manager',
            debugShowCheckedModeBanner: false,
            themeMode: theme.themeMode,
            theme: TaskFlowTheme.light(),
            darkTheme: TaskFlowTheme.dark(),
            initialRoute: '/',
            routes: {
              '/': (_) => const SplashScreen(),
              '/gate': (_) => const AuthGate(),
            },
          );
        },
      ),
    );
  }
}
