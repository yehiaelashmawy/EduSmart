import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class PdfGenerator {
  static Future<String> generateExamResultsPdf() async {
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
                'Exam Results',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Mathematics • Grade 10 - A',
                style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
              ),
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
                },
                headers: ['Student Name', 'Status', 'Score'],
                data: [
                  ['Alex Johnson', 'Graded', '92%'],
                  ['Maria Santos', 'Graded', '88%'],
                  ['Ryan Kim', 'Graded', '85%'],
                  ['Liam Wilson', 'Not Turned In', 'N/A'],
                  ['Chloe Park', 'Submitted', 'Pending'],
                  ['David Brown', 'Graded', '78%'],
                ],
              ),
            ],
          );
        },
      ),
    );

    // Save PDF
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/exam_results.pdf');
    await file.writeAsBytes(await pdf.save());

    return file.path;
  }
}
