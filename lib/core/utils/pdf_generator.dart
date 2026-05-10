import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:school_system/features/teacher/data/models/submission_model.dart';
import 'package:school_system/features/teacher/data/models/exam_submission_model.dart';

class PdfGenerator {
  static Future<String> generateSubmissionsPdf({
    required String title,
    String? subtitle,
    required List<SubmissionModel> submissions,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              if (subtitle != null) ...[
                pw.SizedBox(height: 8),
                pw.Text(
                  subtitle,
                  style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
                ),
              ],
              pw.SizedBox(height: 8),
              pw.Text(
                'Generated on: ${DateTime.now().toLocal().toString().split('.')[0]}',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 24),

              // Table
              pw.TableHelper.fromTextArray(
                context: context,
                border: pw.TableBorder.all(color: PdfColors.grey300),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.blue800,
                ),
                cellHeight: 30,
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.center,
                  2: pw.Alignment.centerRight,
                  3: pw.Alignment.centerRight,
                },
                headers: ['Student Name', 'Status', 'Score', 'Feedback'],
                data: submissions.map((s) {
                  return [
                    s.studentName,
                    s.status,
                    s.grade != null ? '${s.grade}%' : 'N/A',
                    s.feedback ?? '',
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    // Save PDF
    final directory = await getTemporaryDirectory();
    final fileName = '${title.replaceAll(' ', '_').toLowerCase()}_results.pdf';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    return file.path;
  }
  
  static Future<String> generateExamSubmissionsPdf({
    required String title,
    String? subtitle,
    required List<ExamSubmissionModel> submissions,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              if (subtitle != null) ...[
                pw.SizedBox(height: 8),
                pw.Text(
                  subtitle,
                  style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
                ),
              ],
              pw.SizedBox(height: 8),
              pw.Text(
                'Generated on: ${DateTime.now().toLocal().toString().split('.')[0]}',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 24),

              pw.TableHelper.fromTextArray(
                context: context,
                border: pw.TableBorder.all(color: PdfColors.grey300),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.blue800,
                ),
                cellHeight: 30,
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.center,
                  2: pw.Alignment.centerRight,
                  3: pw.Alignment.centerRight,
                },
                headers: ['Student Name', 'Status', 'Score', 'Feedback'],
                data: submissions.map((s) {
                  return [
                    s.studentName,
                    s.status,
                    s.isGraded ? s.score.toString() : 'N/A',
                    s.feedback ?? '',
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    final directory = await getTemporaryDirectory();
    final fileName = '${title.replaceAll(' ', '_').toLowerCase()}_exam_results.pdf';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(await pdf.save());

    return file.path;
  }

  // Keep old method for backward compatibility if needed, but updated to use the new logic
  static Future<String> generateExamResultsPdf() async {
    return generateSubmissionsPdf(
      title: 'Exam Results',
      subtitle: 'Mathematics • Grade 10 - A',
      submissions: [], // This was static anyway
    );
  }
}
