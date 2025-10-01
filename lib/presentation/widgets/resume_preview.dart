import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/resume_entity.dart';
import '../provider/providers.dart';

class ResumePreview extends StatelessWidget {
  final int bgColor;
  final int accent;
  final WidgetRef ref;

  const ResumePreview({required this.bgColor, required this.ref , required this.accent});

  @override
  Widget build(BuildContext context) {
    final fontSize = ref.watch(fontSizeProvider);
    final fontColor = ref.watch(fontColorProvider);
    final submittedName = ref.watch(submittedNameProvider);

    final accentColor = Color(accent);
    final textColor = Color(fontColor);

    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
          child: Container(
            width: 700,
            constraints: const BoxConstraints(minHeight: 1000),
            decoration: BoxDecoration(
              color: Color(bgColor),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: ref.watch(resumeFutureProvider(submittedName)).when(
                data: (resume) {
                  final currentSummary = ref.watch(summaryInputProvider);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        resume.name,
                        style: TextStyle(
                          fontSize: fontSize * 2,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _ContactInfo(icon: Icons.phone, text: resume.phone, fontSize: fontSize),
                          _DividerDot(color: accentColor),
                          _ContactInfo(icon: Icons.email, text: resume.email, fontSize: fontSize),
                          _DividerDot(color: accentColor),
                          _ContactInfo(icon: Icons.location_on, text: resume.address, fontSize: fontSize),
                          if (resume.twitter.isNotEmpty) ...[
                            _DividerDot(color: accentColor),
                            _ContactInfo(icon: Icons.link, text: '${resume.twitter}', fontSize: fontSize),
                          ]
                        ],
                      ),

                      const SizedBox(height: 30),
                      _SectionHeader(
                        title: 'Professional Summary',
                        color: accentColor,
                        fontSize: fontSize,
                      ),
                      const SizedBox(height: 10),
                      SelectableText(
                        currentSummary,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: textColor,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 30),
                      _SectionHeader(
                        title: 'Technical Skills',
                        color: accentColor,
                        fontSize: fontSize,
                      ),
                      const SizedBox(height: 15),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: resume.skills
                            .map((skill) => Chip(
                          label: Text(skill),
                          backgroundColor: accentColor.withOpacity(0.1),
                          labelStyle: TextStyle(
                            color: accentColor,
                            fontWeight: FontWeight.w600,
                            fontSize: fontSize * 0.9,
                          ),
                          side: BorderSide(color: accentColor.withOpacity(0.4)),
                        ))
                            .toList(),
                      ),

                      const SizedBox(height: 30),
                      _SectionHeader(
                        title: 'Projects',
                        color: accentColor,
                        fontSize: fontSize,
                      ),
                      const SizedBox(height: 15),
                      Column(
                        children: resume.projects
                            .map((p) => _ProjectEntry(
                          project: p,
                          accentColor: accentColor,
                          textColor: textColor,
                          fontSize: fontSize,
                        ))
                            .toList(),
                      ),
                    ],
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(50.0),
                    child: CircularProgressIndicator(color: Colors.deepOrange),
                  ),
                ),
                error: (e, _) => Text(
                  'Error loading resume data: $e',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;
  final double fontSize;

  const _SectionHeader({
    required this.title,
    required this.color,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: fontSize * 1.1,
            fontWeight: FontWeight.bold,
            color: color,
            letterSpacing: 1.3,
          ),
        ),
        Container(
          height: 2,
          width: 80,
          margin: const EdgeInsets.only(top: 4, bottom: 8),
          color: color,
        ),
      ],
    );
  }
}

class _ContactInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  final double fontSize;

  const _ContactInfo({
    required this.icon,
    required this.text,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: fontSize * 0.95, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Expanded(
            child: SelectableText(
              text,
              style: TextStyle(
                fontSize: fontSize * 0.95,
                color: Colors.grey[800],
              ),
              maxLines: 1,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}



class _DividerDot extends StatelessWidget {
  final Color color;
  const _DividerDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Text("•", style: TextStyle(color: color, fontWeight: FontWeight.bold));
  }
}

class _ProjectEntry extends StatelessWidget {
  final ProjectEntity project;
  final Color accentColor;
  final Color textColor;
  final double fontSize;

  const _ProjectEntry({
    required this.project,
    required this.accentColor,
    required this.textColor,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Dates
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              SelectableText(
                project.title,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              SelectableText(
                "${project.startDate} - ${project.endDate}",
                style: TextStyle(
                  fontSize: fontSize * 0.9,
                  color: accentColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SelectableText(
            project.description,
            style: TextStyle(
              fontSize: fontSize * 0.95,
              color: textColor,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
