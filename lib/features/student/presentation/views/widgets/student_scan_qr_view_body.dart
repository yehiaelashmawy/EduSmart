import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_scanner_border_painter.dart';
import 'package:school_system/features/student/presentation/views/widgets/student_scan_action_item.dart';

class StudentScanQrViewBody extends StatefulWidget {
  final String subject;

  const StudentScanQrViewBody({super.key, required this.subject});

  @override
  State<StudentScanQrViewBody> createState() => _StudentScanQrViewBodyState();
}

class _StudentScanQrViewBodyState extends State<StudentScanQrViewBody> {
  late MobileScannerController _scannerController;
  final ImagePicker _picker = ImagePicker();
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _toggleFlash() {
    _scannerController.toggleTorch();
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
  }

  Future<void> _uploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final BarcodeCapture? capture = await _scannerController.analyzeImage(
          image.path,
        );
        if (!mounted) return;
        if (capture != null && capture.barcodes.isNotEmpty) {
          // Success Feedback
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'QR Code found: ${capture.barcodes.first.rawValue}',
              ),
            ),
          );
        } else {
          // Error Feedback
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No QR Code found in the selected image.'),
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to read image: $e')));
    }
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      debugPrint('Barcode found! ${barcode.rawValue}');
      // Trigger navigation or success action here
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          children: [
            Text(
              'Point your camera',
              style: AppTextStyle.bold24.copyWith(color: AppColors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Position the QR code within the frame to automatically track your attendance for ${widget.subject}.',
              style: AppTextStyle.medium14.copyWith(
                color: AppColors.grey,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Scanner Frame
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: MobileScanner(
                      controller: _scannerController,
                      onDetect: _onDetect,
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    height: 250,
                    child: CustomPaint(
                      painter: StudentScannerBorderPainter(
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),
                  // Mocks the scanning line
                  Container(
                    width: 250,
                    height: 1,
                    color: AppColors.secondaryColor.withValues(alpha: 0.5),
                    margin: const EdgeInsets.only(bottom: 20),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.lightGrey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.filter_center_focus,
                    size: 14,
                    color: AppColors.secondaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'DETECTING...',
                    style: AppTextStyle.bold12.copyWith(
                      color: AppColors.secondaryColor,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // Main Scan Button (Currently passive or triggers internal logic if needed)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Start or Stop the scanner manually if needed
                },
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                label: Text(
                  'Scan QR',
                  style: AppTextStyle.bold16.copyWith(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Bottom Actions (Flash & Upload)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StudentScanActionItem(
                  icon: _isFlashOn
                      ? Icons.flashlight_off_outlined
                      : Icons.flashlight_on_outlined,
                  label: 'Flash',
                  onTap: _toggleFlash,
                ),
                const SizedBox(width: 48),
                StudentScanActionItem(
                  icon: Icons.image_outlined,
                  label: 'Upload',
                  onTap: _uploadImage,
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
