import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/utils/size_config.dart';
import 'package:school_system/core/utils/theme_manager.dart';

class AiMarkdownBody extends StatelessWidget {
  final String text;

  const AiMarkdownBody({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeManager.isDarkMode;
    final baseFontSize = SizeConfig.getResponsiveFontSize(
      context,
      fontSize: 14,
    );

    return MarkdownBody(
      data: text,
      selectable: true,
      styleSheet: _buildStyleSheet(context, isDark, baseFontSize),
      builders: {
        'pre': _CodeBlockBuilder(isDark: isDark),
      },
    );
  }

  MarkdownStyleSheet _buildStyleSheet(
    BuildContext context,
    bool isDark,
    double baseFontSize,
  ) {
    final textColor = isDark ? Colors.white : const Color(0xff334155);
    final codeBackground =
        isDark ? const Color(0xff1E293B) : const Color(0xffF1F5F9);
    final tableBorderColor =
        isDark ? const Color(0xff334155) : const Color(0xffE2E8F0);

    return MarkdownStyleSheet(
      p: GoogleFonts.cairo(
        fontSize: baseFontSize,
        color: textColor,
        height: 1.6,
      ),
      h1: GoogleFonts.cairo(
        fontSize: baseFontSize * 1.6,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : const Color(0xff1E293B),
        height: 1.4,
      ),
      h2: GoogleFonts.cairo(
        fontSize: baseFontSize * 1.4,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : const Color(0xff1E293B),
        height: 1.4,
      ),
      h3: GoogleFonts.cairo(
        fontSize: baseFontSize * 1.2,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : const Color(0xff1E293B),
        height: 1.4,
      ),
      strong: GoogleFonts.cairo(
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : const Color(0xff1E293B),
      ),
      em: GoogleFonts.cairo(
        fontStyle: FontStyle.italic,
        color: textColor,
      ),
      code: GoogleFonts.firaCode(
        fontSize: baseFontSize * 0.9,
        color: isDark ? const Color(0xff93C5FD) : const Color(0xffDB2777),
        backgroundColor: codeBackground,
      ),
      codeblockDecoration: BoxDecoration(
        color: isDark ? const Color(0xff0F172A) : const Color(0xff1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      codeblockPadding: const EdgeInsets.all(16),
      codeblockAlign: WrapAlignment.start,
      blockquoteDecoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: AppColors.primaryColor,
            width: 3,
          ),
        ),
        color: isDark
            ? AppColors.primaryColor.withValues(alpha: 0.1)
            : AppColors.primaryColor.withValues(alpha: 0.05),
      ),
      blockquotePadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      listBullet: GoogleFonts.cairo(
        fontSize: baseFontSize,
        color: AppColors.primaryColor,
      ),
      listIndent: 20,
      tableBorder: TableBorder.all(color: tableBorderColor, width: 1),
      tableHead: GoogleFonts.cairo(
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      tableBody: GoogleFonts.cairo(color: textColor),
      tableCellsPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: tableBorderColor, width: 1),
        ),
      ),
    );
  }
}

class _CodeBlockBuilder extends MarkdownElementBuilder {
  final bool isDark;

  _CodeBlockBuilder({required this.isDark});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final code = element.textContent.trimRight();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff0F172A) : const Color(0xff1E293B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xff334155),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CodeBlockHeader(code: code, isDark: isDark),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SelectableText(
                code,
                style: GoogleFonts.firaCode(
                  fontSize: 13,
                  color: const Color(0xffE2E8F0),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CodeBlockHeader extends StatefulWidget {
  final String code;
  final bool isDark;

  const _CodeBlockHeader({required this.code, required this.isDark});

  @override
  State<_CodeBlockHeader> createState() => _CodeBlockHeaderState();
}

class _CodeBlockHeaderState extends State<_CodeBlockHeader> {
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: widget.isDark
            ? const Color(0xff1E293B)
            : const Color(0xff334155),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.code_rounded, size: 14, color: Colors.grey[400]),
          const SizedBox(width: 8),
          Text(
            'Code',
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: Colors.grey[400],
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: widget.code));
              if (mounted) {
                setState(() => _copied = true);
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) setState(() => _copied = false);
                });
              }
            },
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _copied ? Icons.check_rounded : Icons.copy_rounded,
                    size: 14,
                    color:
                        _copied ? Colors.green[400] : Colors.grey[400],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _copied ? 'Copied!' : 'Copy',
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      color:
                          _copied ? Colors.green[400] : Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
