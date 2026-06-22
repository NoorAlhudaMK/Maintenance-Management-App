import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Features/Auth/BLoC/auth_bloc.dart';
import 'Features/Auth/View/login_view.dart';
import 'Features/Technician/BLoC/tech_bloc.dart';
import 'Features/TechnicianTaskDetails/BLoC/task_details_bloc.dart';
import 'Features/TechnicianTasks/BLoC/technician_tasks_bloc.dart';
import 'Features/TechnicianTasks/BLoC/technician_tasks_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  checkUserToken();
  runApp(const MyApp());
}

void checkUserToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {

    String? token = await messaging.getToken();

    if (token != null) {
      print("✅ تم إنشاء معرف الجهاز بنجاح:");
      print("FCM Token: $token"); 
    } else {
      print("❌ فشل الحصول على المعرف.");
    }
  } else {
    print("⚠️ المستخدم رفض إعطاء صلاحية الإشعارات.");
  }
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