import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../BLoC/about_app_bloc.dart';
import '../BLoC/about_app_event.dart';
import '../BLoC/about_app_state.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AboutBloc()..add(LoadAboutInfoEvent()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1B315E),
          title: const Text(
            'حول التطبيق',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<AboutBloc, AboutState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // شعار أو أيقونة التطبيق
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B315E).withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.apartment_rounded,
                        size: 64,
                        color: Color(0xFF1B315E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // عنوان رئيسي
                  const Center(
                    child: Text(
                      'نظام إدارة صيانة المجمعات السكنية',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B315E),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Center(
                    child: Text(
                      'الإصدار ${state.appVersion}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // بطاقة الرؤية أو النبذة
                  _buildSectionCard(
                    title: 'نُرحب بك في المستقبل الذكي',
                    content:
                    'حيث تقترن الكفاءة وسرعة الاستجابة بالدقة الميدانية. وُلِد هذا التطبيق ليكون الشريك الرقمي الأول لفريق الصيانة في المجمعات السكنية، لتحويل العمليات التشغيلية اليومية إلى منظومة سلسة ومؤتمتة بالكامل.',
                    icon: Icons.lightbulb_outline_rounded,
                  ),
                  const SizedBox(height: 16),

                  // بطاقة الخصائص الرئيسية
                  _buildSectionCard(
                    title: 'المميزات والأركان الرئيسية',
                    content:
                    '• إدارة المهام والتذاكر الذكية ومتابعتها فورياً.\n'
                        '• التوثيق الميداني المتقدم وإرفاق صور (قبل وبعد الإصلاح).\n'
                        '• تتبع دقيق لحالات الطلبات (قيد التنفيذ، بانتظار قطع الغيار، مكتمل).\n'
                        '• لوحة مؤشرات وإحصاءات دقيقة للأداء الفردي والشهري.',
                    icon: Icons.verified_rounded,
                  ),
                  const SizedBox(height: 30),

                  // الحقوق والشركة المنفذة
                  Center(
                    child: Text(
                      'جميع الحقوق محفوظة © ${state.companyName}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ودجت مساعدة لتصميم البطاقات بشكل أنيق
  Widget _buildSectionCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF1B315E), size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B315E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}