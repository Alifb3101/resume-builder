import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:text_app/presentation/provider/location.dart';
import 'package:text_app/presentation/widgets/resume_preview.dart';
import 'package:text_app/presentation/widgets/settings_panel.dart';
import 'provider/providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  void pickColor(BuildContext context, Color currentColor, Function(int) onColorChanged) {
    showDialog(
      context: context,
      builder: (ctx) {
        Color tempColor = currentColor;
        return AlertDialog(
          title: const Text('Pick Background Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (c) => tempColor = c,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  onColorChanged(tempColor.value);
                  Navigator.of(ctx).pop();
                },
                child: const Text('Select')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bgColor = ref.watch(bgColorProvider);
    final accent = ref.watch(AccentProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Resume Builder',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        centerTitle: false,
        elevation: 1,
        backgroundColor: Colors.white,
        actions: [
          Consumer(
            builder: (context, ref, _) {
              final locationAsync = ref.watch(locationProvider);

              return GestureDetector(
                onTap: () async {
                  final notifier = ref.read(locationProvider.notifier);
                  final currentState = ref.read(locationProvider);

                  if (currentState.hasError &&
                      currentState.error.toString().contains('permanently')) {
                    // Open App Settings if permanently denied
                    await notifier.openAppSettings();
                  } else {
                    // Otherwise, refresh location (first-time or denied)
                    await notifier.refreshLocation();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: locationAsync.when(
                    data: (pos) {
                      if (pos == null) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.location_off, color: Colors.red, size: 20),
                            Text('Tap to enable', style: TextStyle(fontSize: 10, color: Colors.red)),
                          ],
                        );
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Lat: ${pos.latitude.toStringAsFixed(5)}', style: const TextStyle(fontSize: 12, color: Colors.black87)),
                          Text('Lng: ${pos.longitude.toStringAsFixed(5)}', style: const TextStyle(fontSize: 12, color: Colors.black87)),
                        ],
                      );
                    },
                    loading: () => const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (e, _) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.location_off, color: Colors.red, size: 20),
                        Text('Tap to enable', style: TextStyle(fontSize: 10, color: Colors.red)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),


        ],
      ),
      body: Row(
        children: [
          ConfigurationPanel(pickColor: pickColor),
          ResumePreview(bgColor: bgColor, ref: ref , accent: accent,),
        ],
      ),
    );
  }
}











