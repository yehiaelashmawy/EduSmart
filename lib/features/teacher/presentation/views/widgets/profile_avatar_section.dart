import 'dart:io';
import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/helper/shared_prefs_helper.dart';
import 'package:school_system/core/helper/url_helper.dart';

class ProfileAvatarSection extends StatelessWidget {
  const ProfileAvatarSection({
    super.key,
    required this.name,
    required this.title,
    this.pickedImagePath,
    this.networkImageUrl,
    required this.onPickPhoto,
  });

  final String name;
  final String title;
  final String? pickedImagePath;
  final String? networkImageUrl;
  final VoidCallback onPickPhoto;

  Widget _buildPlaceholder() {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person_rounded,
        size: 80,
        color: AppColors.primaryColor.withValues(alpha: 0.4),
      ),
    );
  }

  Widget _buildAvatar() {
    final token = SharedPrefsHelper.token;

    final headers = (token != null && token.isNotEmpty)
        ? {'Authorization': 'Bearer $token'}
        : <String, String>{};

    final String url = UrlHelper.getFullImageUrl(networkImageUrl);

    if (pickedImagePath != null) {
      return ClipOval(
        child: Image.file(
          File(pickedImagePath!),
          width: 130,
          height: 130,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        ),
      );
    }

    if (url.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          url,
          headers: headers,
          width: 130,
          height: 130,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildPlaceholder();
          },
        ),
      );
    }

    return _buildPlaceholder();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              _buildAvatar(),
              Positioned(
                bottom: 0,
                right: 4,
                child: GestureDetector(
                  onTap: onPickPhoto,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 3),
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: AppTextStyle.bold16.copyWith(
              color: AppColors.darkBlue,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyle.regular14.copyWith(color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}
