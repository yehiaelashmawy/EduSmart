import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/custom_text_field.dart';

class PersonalInformationViewBody extends StatefulWidget {
  const PersonalInformationViewBody({super.key});

  @override
  State<PersonalInformationViewBody> createState() => _PersonalInformationViewBodyState();
}

class _PersonalInformationViewBodyState extends State<PersonalInformationViewBody> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();

  String? _pickedImagePath;

  @override
  void initState() {
    super.initState();
    _resetDefaults();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  void _resetDefaults() {
    _nameController.text = 'Alex Johnson';
    _emailController.text = 'alex.johnson@edusmart.com';
    _phoneController.text = '+1 (555) 123-4567';
    _subjectController.text = 'Mathematics';
    _experienceController.text = '12';
    _pickedImagePath = null;
  }

  void _saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Changes saved successfully!'),
        backgroundColor: AppColors.secondaryColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _pickPhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _pickedImagePath = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar Section
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.transparent,
                      backgroundImage: _pickedImagePath != null
                          ? FileImage(File(_pickedImagePath!)) as ImageProvider
                          : const AssetImage('assets/images/profile_photo.png'),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        onTap: _pickPhoto,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Alex Johnson',
                  style: AppTextStyle.bold16.copyWith(
                    color: AppColors.darkBlue,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Senior Mathematics Educator',
                  style: AppTextStyle.regular14.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          Text(
            'Account Details',
            style: AppTextStyle.bold16.copyWith(
               color: AppColors.darkBlue,
              fontSize: 18,
            ),
          ),
          
          const SizedBox(height: 20),
          
          _buildFieldSection(
            label: 'Full Name',
            controller: _nameController,
            suffixIcon: Icons.edit_outlined,
          ),
          
          const SizedBox(height: 16),
          
          _buildFieldSection(
            label: 'Email Address',
            controller: _emailController,
            suffixIcon: Icons.mail_outline,
          ),
          
          const SizedBox(height: 16),
          
          _buildFieldSection(
            label: 'Phone Number',
            controller: _phoneController,
            suffixIcon: Icons.phone_outlined,
          ),
          
          const SizedBox(height: 16),
          
          _buildFieldSection(
            label: 'Main Subject',
            controller: _subjectController,
            suffixIcon: Icons.school_outlined,
          ),
          
          const SizedBox(height: 16),
          
          _buildFieldSection(
            label: 'Years of Experience',
            controller: _experienceController,
            suffixIcon: Icons.badge_outlined,
          ),
          
          const SizedBox(height: 32),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _resetDefaults();
                });
              },
              child: Text(
                'Reset to Default',
                style: AppTextStyle.semiBold14.copyWith(
                  color: AppColors.primaryColor,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFieldSection({
    required String label,
    required TextEditingController controller,
    required IconData suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.semiBold14.copyWith(
            color: const Color(0xff475569), // Slate 600
            fontSize: 12, 
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: controller,
          hintText: '',
          suffixIcon: Icon(suffixIcon, color: const Color(0xff94A3B8), size: 20),
        ),
      ],
    );
  }
}
