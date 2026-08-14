import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_management_app/Data/Repositories/auth_repository.dart';
import 'package:maintenance_management_app/Data/Repositories/tickets_repository.dart';
import 'package:maintenance_management_app/Features/MainPage/BLoC/home_bloc.dart';
import 'package:maintenance_management_app/Features/ManagerIncomingReports/BLoC/incoming_reports_bloc.dart';
import 'Core/CacheManager/cache_manager.dart';
import 'Features/Auth/BLoC/auth_bloc.dart';
import 'Features/Auth/View/login_view.dart';
import 'Features/ManagerIncomingReports/BLoC/incoming_reports_event.dart';
import 'Features/Technician/BLoC/tech_bloc.dart';
import 'Features/TechnicianTaskDetails/BLoC/task_details_bloc.dart';
import 'Features/TechnicianTasks/BLoC/technician_tasks_bloc.dart';
import 'Features/TechnicianTasks/BLoC/technician_tasks_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  checkUserToken();

  String? token = await CacheManager.getToken();

  if (token != null) {
    try {
      await AuthRepository().fetchAndCacheUserProfile(token);
    } catch (e) {
      if (kDebugMode) {
        print("خطأ في تحديث البيانات عند التشغيل: $e");
      }
    }
  }

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
          create: (context) => AuthBloc(authRepository: AuthRepository()),
        ),
        BlocProvider<TechBloc>(create: (context) => TechBloc()),
        BlocProvider<HomeBloc>(create: (context) => HomeBloc()),
        BlocProvider<ReportsBloc>(
          create: (context) =>
              ReportsBloc(repository: TicketsRepository())
                ..add(FetchTicketsEvent()),
        ),
        BlocProvider<TechnicianTasksBloc>(
          create: (context) =>
              TechnicianTasksBloc()..add(LoadTechnicianTasks()),
        ),
        BlocProvider<TaskDetailsBloc>(create: (context) => TaskDetailsBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Cairo', useMaterial3: true),
        home: const LoginView(),
      ),
    );
  }
}
