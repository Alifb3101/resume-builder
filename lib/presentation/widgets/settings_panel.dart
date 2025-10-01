import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/providers.dart';

class ConfigurationPanel extends ConsumerWidget {
  final Function(BuildContext, Color, Function(int)) pickColor;

  const ConfigurationPanel({required this.pickColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontSize = ref.watch(fontSizeProvider);
    final fontColor = ref.watch(fontColorProvider);
    final bgColor = ref.watch(bgColorProvider);
    final accentprovoider = ref.watch(AccentProvider);

    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Colors.grey.shade300)),
      ),
      child: ListView(
        children: [
          const Text(
            'Content Editor',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const Divider(height: 20),
          _InputSection(),
          ElevatedButton.icon(
            onPressed: () {
              final currentName = ref.read(nameInputProvider);
              ref.read(submittedNameProvider.notifier).state = currentName;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Submitting data and generating resume for: $currentName...')),
              );
            },
            icon: const Icon(Icons.send_rounded),
            label: const Text('Generate'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Document Styles',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const Divider(height: 20),
          _StyleControlRow(
            label: 'Font Size',
            control: Slider(
              min: 12,
              max: 24,
              value: fontSize,
              divisions: 12,
              label: fontSize.toStringAsFixed(0),
              activeColor: Colors.deepOrange,
              onChanged: (v) => ref.read(fontSizeProvider.notifier).setFontSize(v),
            ),
          ),
          const SizedBox(height: 16),
          _StyleControlRow(
            label: 'Text Color',
            control: GestureDetector(
              onTap: () => pickColor(context, Color(fontColor), (v) {
                ref.read(fontColorProvider.notifier).setFontColor(v);
              }),
              child: _ColorIndicator(color: Color(fontColor)),
            ),
          ),
          const SizedBox(height: 16),
          _StyleControlRow(
            label: 'Accent Color',
            control: GestureDetector(
              onTap: () => pickColor(context, Color(accentprovoider), (v) {
                ref.read(AccentProvider.notifier).setAccentColor(v);
              }),
              child: _ColorIndicator(color: Color(accentprovoider)),
            ),
          ),
          const SizedBox(height: 16),
          _StyleControlRow(
            label: 'Background Color',
            control: GestureDetector(
              onTap: () => pickColor(context, Color(bgColor), (v) {
                ref.read(bgColorProvider.notifier).setBgColor(v);
              }),
              child: _ColorIndicator(color: Color(bgColor)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorIndicator extends StatelessWidget {
  final Color color;

  const _ColorIndicator({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 2),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.5), blurRadius: 4),
        ],
      ),
    );
  }
}

class _StyleControlRow extends StatelessWidget {
  final String label;
  final Widget control;

  const _StyleControlRow({required this.label, required this.control});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700]),
        ),
        const SizedBox(height: 8),
        control,
      ],
    );
  }
}

class _InputSection extends ConsumerStatefulWidget {
  const _InputSection();

  @override
  ConsumerState<_InputSection> createState() => _InputSectionState();
}

class _InputSectionState extends ConsumerState<_InputSection> {
  late TextEditingController _nameController;
  late TextEditingController _summaryController;

  @override
  void initState() {
    super.initState();
    final initialName = ref.read(nameInputProvider);
    final initialSummary = ref.read(summaryInputProvider);

    _nameController = TextEditingController(text: initialName);
    _summaryController = TextEditingController(text: initialSummary);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Name:', style: TextStyle(fontWeight: FontWeight.w600)),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: 'Your Full Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            isDense: true,
          ),
          onChanged: (value) => ref.read(nameInputProvider.notifier).state = value,
        ),
        const SizedBox(height: 12),
        const Text('Summary:', style: TextStyle(fontWeight: FontWeight.w600)),
        TextFormField(
          controller: _summaryController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'A concise professional statement...',
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            isDense: true,
          ),
          onChanged: (value) => ref.read(summaryInputProvider.notifier).state = value,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}