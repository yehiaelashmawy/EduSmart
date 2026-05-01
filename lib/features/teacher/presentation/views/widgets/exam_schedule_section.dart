import 'package:flutter/material.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/custom_text_field.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/field_label.dart';

class ExamScheduleSection extends StatefulWidget {
  final TextEditingController dateController;
  final TextEditingController startTimeController;
  final TextEditingController durationController;
  final TextEditingController roomController;

  const ExamScheduleSection({
    super.key,
    required this.dateController,
    required this.startTimeController,
    required this.durationController,
    required this.roomController,
  });

  @override
  State<ExamScheduleSection> createState() => _ExamScheduleSectionState();
}

class _ExamScheduleSectionState extends State<ExamScheduleSection> {
  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      setState(() {
        widget.dateController.text =
            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T00:00:00.000Z";
      });
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null && mounted) {
      setState(() {
        final timeStr =
            "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
        if (isStart) {
          widget.startTimeController.text = timeStr;
        } else {
          widget.durationController.text = timeStr;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel(label: 'Exam Date'),
        const SizedBox(height: 8),
        CustomTextField(
          hintText: 'yyyy-mm-ddThh:mm:ss.mmmZ',
          controller: widget.dateController,
          readOnly: true,
          onTap: _pickDate,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FieldLabel(label: 'Start Time'),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: '--:--',
                    controller: widget.startTimeController,
                    readOnly: true,
                    onTap: () => _pickTime(true),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FieldLabel(label: 'Duration (HH:mm)'),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: '--:--',
                    controller: widget.durationController,
                    readOnly: true,
                    onTap: () => _pickTime(false),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const FieldLabel(label: 'Exam Room / Location'),
        const SizedBox(height: 8),
        CustomTextField(
          hintText: 'e.g., Room 102, Hall B, etc.',
          controller: widget.roomController,
        ),
      ],
    );
  }
}
