import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../Features/Reports/BLoC/reports_state.dart';

class PdfReportService {
  static Future<void> generateAndSaveReport(ReportsStatsState state) async {
    final pdf = pw.Document();

    // تحميل خط يدعم العربية (ضروري جداً)
    final arabicFont = await PdfGoogleFonts.almaraiRegular();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl, // دعم العربية
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("تقرير أداء المجمع السكني",
                  style: pw.TextStyle(font: arabicFont,
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text("الفترة: ${state.selectedFilter}",
                  style: pw.TextStyle(font: arabicFont, fontSize: 16)),
              pw.Divider(),
              pw.SizedBox(height: 20),

              // شبكة الإحصائيات في الـ PDF
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _pdfStatCard(
                      "إجمالي البلاغات", "${state.totalReports}", arabicFont),
                  _pdfStatCard(
                      "نسبة الإنجاز", state.completionRate, arabicFont),
                ],
              ),
              pw.SizedBox(height: 30),

              pw.Text("أداء الفنيين:",
                  style: pw.TextStyle(font: arabicFont,
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),

              // جدول الأداء
              // تأكدي من استخراج البيانات مع تحديد الخط لكل خلية
              pw.TableHelper.fromTextArray(
                context: context,
                cellStyle: pw.TextStyle(font: arabicFont, fontSize: 10),
                // ضروري جداً لأسماء الموظفين
                headerStyle: pw.TextStyle(
                    font: arabicFont, fontWeight: pw.FontWeight.bold),
                cellAlignment: pw.Alignment.centerRight,
                data: [
                  ['الفني', 'عدد المهام', 'نسبة الإنجاز'],
                  ...state.teamPerformance.map((tech) =>
                  [
                    tech.name, // سيظهر بشكل صحيح الآن
                    "${tech.tasksCount}",
                    tech.percentage
                  ]),
                ],
              ),

            ],
          );
        },
      ),
    );

    // عرض نافذة الطباعة والحفظ
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'تقرير_${state.selectedFilter}.pdf',
    );
  }

  static pw.Widget _pdfStatCard(String title, String value, pw.Font font) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        children: [
          pw.Text(title, style: pw.TextStyle(font: font, fontSize: 12)),
          pw.Text(value, style: pw.TextStyle(font: font, fontSize: 18, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }
}