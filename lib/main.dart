import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Features/Auth/BLoC/auth_bloc.dart';
import 'Features/Auth/View/login_view.dart';
import 'Features/Technician/BLoC/tech_bloc.dart';
import 'Features/TechnicianTaskDetails/BLoC/task_details_bloc.dart';
import 'Features/TechnicianTasks/BLoC/technician_tasks_bloc.dart';
import 'Features/TechnicianTasks/BLoC/technician_tasks_event.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<TechBloc>(
          create: (context) => TechBloc(),
        ),
        BlocProvider<TechnicianTasksBloc>(
          create: (context) => TechnicianTasksBloc()..add(LoadTechnicianTasks()),
        ),
        BlocProvider<TaskDetailsBloc>(
          create: (context) => TaskDetailsBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Cairo',
          useMaterial3: true,
        ),
        home: const LoginView(),
      ),
    );
  }
}