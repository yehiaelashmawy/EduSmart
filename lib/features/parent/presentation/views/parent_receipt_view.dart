import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:school_system/core/api/api_service.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:school_system/features/parent/data/models/receipt_model.dart';
import 'package:school_system/features/parent/data/repos/parent_dashboard_repo.dart';
import 'package:school_system/features/parent/presentation/manager/parent_receipts_cubit/parent_receipts_cubit.dart';
import 'package:school_system/features/parent/presentation/manager/parent_receipts_cubit/parent_receipts_state.dart';

class ParentReceiptView extends StatelessWidget {
  static const routeName = 'parent_receipt_view';
  final String? receiptNumber;

  const ParentReceiptView({super.key, this.receiptNumber});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ParentReceiptsCubit(ParentDashboardRepo(ApiService()))
            ..fetchReceipts(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FC),
        appBar: AppBar(
          titleSpacing: 12,
          title: Text(
            'Receipt',
            style: AppTextStyle.bold20.copyWith(
              color: AppColors.secondaryColor,
            ),
          ),
          centerTitle: false,
          backgroundColor: const Color(0xFFF8F9FC),
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.secondaryColor),
        ),
        body: BlocBuilder<ParentReceiptsCubit, ParentReceiptsState>(
          builder: (context, state) {
            if (state is ParentReceiptsFailure) {
              return Center(child: Text(state.error.errorMessage));
            }

            final bool isLoading = state is ParentReceiptsLoading;
            final response = state is ParentReceiptsSuccess
                ? state.response
                : _getMockResponse();

            final receipt = _getSelectedReceipt(response, receiptNumber);

            return Skeletonizer(
              enabled: isLoading,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildTopBanner(response.latestPaymentDate),
                    const SizedBox(height: 16),
                    if (receipt != null)
                      _buildReceiptCard(context, receipt)
                    else
                      const Center(child: Text('Receipt not found')),
                    const SizedBox(height: 24),
                    _buildHelpCard(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  ReceiptItemModel? _getSelectedReceipt(
    ReceiptListResponseModel response,
    String? number,
  ) {
    if (response.items.isEmpty) return null;
    if (number == null) return response.items.first;
    return response.items.firstWhere(
      (element) => element.receiptNumber == number,
      orElse: () => response.items.first,
    );
  }

  Widget _buildTopBanner(String date) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LAST PAYMENT DATE',
                style: AppTextStyle.bold12.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _formatDate(date),
                style: AppTextStyle.bold24.copyWith(color: Colors.white),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.calendar_today, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptCard(BuildContext context, ReceiptItemModel receipt) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        receipt.title,
                        style: AppTextStyle.bold24.copyWith(
                          color: const Color(0xFF1A1D1E),
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        receipt.status.toUpperCase(),
                        style: AppTextStyle.bold12.copyWith(
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Transaction ID:\n#${receipt.transactionId}',
                  style: AppTextStyle.medium14.copyWith(
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                _buildDetailRow(
                  icon: Icons.payments_outlined,
                  title: 'Amount',
                  value: '\$${receipt.amount.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 24),
                _buildDetailRow(
                  icon: Icons.calendar_month_outlined,
                  title: 'Date',
                  value: _formatDate(receipt.paymentDate),
                ),
                const SizedBox(height: 24),
                _buildDetailRow(
                  icon: Icons.credit_card_outlined,
                  title: 'Payment Method',
                  value:
                      '${receipt.paymentMethod} **** ${receipt.cardLastFour}',
                ),
                const SizedBox(height: 24),
                _buildDetailRow(
                  icon: Icons.person,
                  title: 'Child\'s Name',
                  value: receipt.studentName,
                  isAvatar: true,
                ),
                const SizedBox(height: 32),
                Row(
                  children: List.generate(
                    30,
                    (index) => Expanded(
                      child: Container(
                        color: index % 2 == 0
                            ? Colors.grey.shade300
                            : Colors.transparent,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildActionButton(
                      context,
                      icon: Icons.download_outlined,
                      label: 'Download',
                      onTap: () => _handleDownload(receipt),
                    ),
                    _buildActionButton(
                      context,
                      icon: Icons.print_outlined,
                      label: 'Print',
                      onTap: () => _handlePrint(receipt),
                    ),
                    _buildActionButton(
                      context,
                      icon: FontAwesomeIcons.whatsapp,
                      label: 'Whatsapp',
                      iconColor: const Color(0xFF25D366),
                      onTap: () => _handleWhatsapp(receipt),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDownload(ReceiptItemModel receipt) async {
    try {
      final pdf = await _generatePdf(receipt);
      final bytes = await pdf.save();
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/Receipt-${receipt.receiptNumber}.pdf');
      await file.writeAsBytes(bytes);
      // ignore: deprecated_member_use
      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'School Payment Receipt - ${receipt.receiptNumber}');
    } catch (e) {
      debugPrint('Download error: $e');
    }
  }

  Future<void> _handlePrint(ReceiptItemModel receipt) async {
    try {
      final pdf = await _generatePdf(receipt);
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      debugPrint('Print error: $e');
    }
  }

  Future<void> _handleWhatsapp(ReceiptItemModel receipt) async {
    try {
      final message =
          '''
📄 *School Receipt: ${receipt.receiptNumber}*
--------------------------
*Child:* ${receipt.studentName}
*Fee:* ${receipt.title}
*Amount:* \$${receipt.amount.toStringAsFixed(2)}
*Date:* ${_formatDate(receipt.paymentDate)}
*Method:* ${receipt.paymentMethod}
*Transaction ID:* ${receipt.transactionId}
--------------------------
_Thank you for your payment!_
''';
      final url = 'whatsapp://send?text=${Uri.encodeComponent(message)}';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        // Fallback to web link
        final webUrl = 'https://wa.me/?text=${Uri.encodeComponent(message)}';
        await launchUrl(Uri.parse(webUrl));
      }
    } catch (e) {
      debugPrint('WhatsApp error: $e');
    }
  }

  Future<pw.Document> _generatePdf(ReceiptItemModel receipt) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.cairoRegular();
    final boldFont = await PdfGoogleFonts.cairoBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(32),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'EduPro Academy',
                          style: pw.TextStyle(
                            font: boldFont,
                            fontSize: 24,
                            color: PdfColors.blue900,
                          ),
                        ),
                        pw.Text(
                          'Official Payment Receipt',
                          style: pw.TextStyle(
                            font: font,
                            fontSize: 14,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Receipt #: ${receipt.receiptNumber}',
                          style: pw.TextStyle(font: boldFont, fontSize: 12),
                        ),
                        pw.Text(
                          'Date: ${_formatDate(receipt.paymentDate)}',
                          style: pw.TextStyle(font: font, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 40),
                pw.Divider(thickness: 2, color: PdfColors.blue900),
                pw.SizedBox(height: 20),
                pw.Text(
                  'BILLING DETAILS',
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 12,
                    color: PdfColors.blue900,
                  ),
                ),
                pw.SizedBox(height: 10),
                _buildPdfRow(
                  'Student Name',
                  receipt.studentName,
                  font,
                  boldFont,
                ),
                _buildPdfRow('Payment for', receipt.title, font, boldFont),
                _buildPdfRow('Category', receipt.category, font, boldFont),
                pw.SizedBox(height: 20),
                pw.Divider(color: PdfColors.grey300),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'TOTAL PAID',
                      style: pw.TextStyle(font: boldFont, fontSize: 16),
                    ),
                    pw.Text(
                      '\$${receipt.amount.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        font: boldFont,
                        fontSize: 20,
                        color: PdfColors.green800,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 40),
                pw.Text(
                  'TRANSACTION INFO',
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 12,
                    color: PdfColors.blue900,
                  ),
                ),
                pw.SizedBox(height: 10),
                _buildPdfRow(
                  'Transaction ID',
                  receipt.transactionId,
                  font,
                  boldFont,
                ),
                _buildPdfRow(
                  'Payment Method',
                  '${receipt.paymentMethod} (**** ${receipt.cardLastFour})',
                  font,
                  boldFont,
                ),
                _buildPdfRow('Status', receipt.status, font, boldFont),
                pw.Spacer(),
                pw.Divider(color: PdfColors.grey300),
                pw.SizedBox(height: 10),
                pw.Center(
                  child: pw.Text(
                    'This is a computer generated document. No signature required.',
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 10,
                      color: PdfColors.grey500,
                    ),
                  ),
                ),
                pw.Center(
                  child: pw.Text(
                    'EduPro Academy - 123 Education Lane, Learning City',
                    style: pw.TextStyle(
                      font: font,
                      fontSize: 10,
                      color: PdfColors.grey500,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
    return pdf;
  }

  pw.Widget _buildPdfRow(
    String label,
    String value,
    pw.Font font,
    pw.Font boldFont,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(
                font: font,
                fontSize: 12,
                color: PdfColors.grey700,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(font: boldFont, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    bool isAvatar = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.secondaryColor, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyle.bold12.copyWith(
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyle.bold16.copyWith(
                  color: const Color(0xFF1A1D1E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required dynamic icon,
    required String label,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return Material(
      color: AppColors.primaryColor.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 90,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              icon is IconData
                  ? Icon(
                      icon,
                      color: iconColor ?? AppColors.secondaryColor,
                      size: 24,
                    )
                  : FaIcon(
                      icon,
                      color: iconColor ?? AppColors.secondaryColor,
                      size: 24,
                    ),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTextStyle.bold12.copyWith(
                  color: AppColors.secondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.help_outline,
              color: AppColors.secondaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need help with this?',
                  style: AppTextStyle.bold16.copyWith(
                    color: const Color(0xFF1A1D1E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Contact our bursar office for payment inquiries.',
                  style: AppTextStyle.medium14.copyWith(
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final dateTime = DateTime.parse(date);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
    } catch (e) {
      return date.split('T').first;
    }
  }

  ReceiptListResponseModel _getMockResponse() {
    return ReceiptListResponseModel(
      totalReceipts: 1,
      totalAmount: 1200,
      latestPaymentDate: '2023-10-24T00:00:00',
      page: 1,
      pageSize: 20,
      items: [
        ReceiptItemModel(
          receiptNumber: 'RCP-123',
          invoiceNumber: 'INV-123',
          title: 'Tuition Fee Placeholder',
          category: 'Tuition',
          amount: 1200,
          paymentDate: '2023-10-15T00:00:00',
          paymentMethod: 'Credit Card',
          studentName: 'Student Name Placeholder',
          cardLastFour: '1234',
          transactionId: 'TXN-123',
          status: 'Completed',
        ),
      ],
    );
  }
}
