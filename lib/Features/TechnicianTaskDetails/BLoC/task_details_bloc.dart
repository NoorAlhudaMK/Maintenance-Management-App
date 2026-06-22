import 'package:flutter_bloc/flutter_bloc.dart';
import '../../TechnicianTasks/BLoC/technician_tasks_state.dart';
import 'task_details_event.dart';
import 'task_details_state.dart';

class TaskDetailsBloc extends Bloc<TaskDetailsEvent, TaskDetailsState> {
  final List<Map<String, dynamic>> _allMockTasks = [
    {
      "id": "1",
      "reportId": "089-2024#",
      "title": "عطل كهربائي في الوحدة",
      "location": "بناية A، الطابق 2، شقة 3B",
      "time": "منذ 45 دقيقة",
      "status": "جديدة",
      "priority": "طوارئ",
      "residentName": "خالد الأحمدي",
      "phone": "0555-XXX-XXX",
      "image1": "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhcPHDc7YHXVhym-cqRL_jRibQ7JdM9SjpdaS62jS48Lsaf7Xpb8eQoIQN3sBDtiEDGISVdTJwKggrauQTw_ZwZq_0IqD-3HasxkY9xwHwIewyIHqo14waQh0-BvOJa1i4miRt7ArwPu9s/s640/%25D1%2581%25D0%25B2%25D0%25B5%25D1%25822.jpg",
      "image2": "https://i.pinimg.com/originals/e0/6f/6a/e06f6af052b11b85e0e7b5816d58ac71.jpg",
      "description": "يوجد انقطاع متكرر للتيار الكهربائي في المقابس الرئيسية للغرفة، مما أدى لتوقف الأجهزة؛ يرجى فحص لوحة المفاتيح والتأكد من سلامة التوصيلات الداخلية.",
      "isEmergency": true,
      "type": TaskTabStatus.emergency,
    },
    {
      "id": "2",
      "reportId": "089-2025#",
      "title": "تسرب مياه في الحمام",
      "location": "شقة 7A - طابق 4 - بناية C",
      "time": "منذ 2 ساعة",
      "image1": "https://www.jrccrestorationpros.com/images/water-damage-restoration/burst-basin-pipe-leaking-water.jpg",
      "image2": "https://thumbs.dreamstime.com/z/close-up-photo-flooded-floor-kitchen-water-leak-showcasing-interior-design-close-up-photo-flooded-floor-kitchen-292168216.jpg",
      "status": "قيد التنفيذ",
      "isEmergency": false,
      "type": TaskTabStatus.inProgress,
      "priority": "عادي",
      "residentName": "خالد الأحمدي",
      "phone": "0555-XXX-XXX",
      "description": "تسرب مياه في الحمام ناتج عن كسر في المحبس الرئيسي أسفل الحوض، مما تسبب في تضرر الأرضية؛ يرجى استبدال القطع التالفة وفحص العزل لضمان عدم وصول المياه للجدران.",
    },
    {
      "id": "3",
      "reportId": "089-2025#",
      "title": "مشكلة في التكييف",
      "location": "شقة 12F - طابق 6 - بناية B",
      "time": "منذ 3 ساعات",
      "image1": "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhcPHDc7YHXVhym-cqRL_jRibQ7JdM9SjpdaS62jS48Lsaf7Xpb8eQoIQN3sBDtiEDGISVdTJwKggrauQTw_ZwZq_0IqD-3HasxkY9xwHwIewyIHqo14waQh0-BvOJa1i4miRt7ArwPu9s/s640/%25D1%2581%25D0%25B2%25D0%25B5%25D1%25822.jpg",
      "image2": "https://i.pinimg.com/originals/e0/6f/6a/e06f6af052b11b85e0e7b5816d58ac71.jpg",
      "status": "جديدة",
      "isEmergency": false,
      "type": TaskTabStatus.all,
      "priority": "عادي",
      "residentName": "خالد الأحمدي",
      "phone": "0555-XXX-XXX",
      "description": "مشكلة في التكييف تسببت في ضعف التبريد مع صدور ضجيج غير طبيعي من الوحدة الداخلية؛ يرجى فحص الغاز وتنظيف الفلاتر للتأكد من كفاءة التشغيل.",
    },
  ];

  TaskDetailsBloc() : super(const TaskDetailsState()) {
    on<LoadTaskDetails>((event, emit) {
      emit(state.copyWith(isLoading: true));

      final task = _allMockTasks.firstWhere(
            (t) => t['id'] == event.taskId,
        orElse: () => _allMockTasks.first,
      );

      emit(state.copyWith(isLoading: false, taskData: task));
    });
  }
}