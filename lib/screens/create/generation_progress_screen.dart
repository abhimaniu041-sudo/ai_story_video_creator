import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/constants.dart';
import '../../providers/story_provider.dart';
import '../../providers/video_provider.dart';
import '../../services/voice/voice_service.dart';
import '../../services/subtitle/subtitle_service.dart';
import '../../services/music/music_service.dart';
import '../player/video_player_screen.dart';

class GenerationProgressScreen extends ConsumerStatefulWidget {
  final String prompt;
  final String? script;
  final String language;
  final String resolution;

  const GenerationProgressScreen({
    super.key,
    required this.prompt,
    this.script,
    required this.language,
    required this.resolution,
  });

  @override
  ConsumerState<GenerationProgressScreen> createState() =>
      _GenerationProgressScreenState();
}

class _GenerationProgressScreenState
    extends ConsumerState<GenerationProgressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startGeneration());
  }

  Future<void> _startGeneration() async {
    final videoNotifier = ref.read(videoGenerationProvider.notifier);
    final storyNotifier = ref.read(storyGenerationProvider.notifier);

    try {
      // Step 1: Generate Story
      videoNotifier.updateProgress(0.1, 'Story generate ho rahi hai...');
      await storyNotifier.generateStory(
        prompt: widget.prompt,
        language: widget.language,
        fullScript: widget.script,
      );

      final storyState = ref.read(storyGenerationProvider);
      final story = storyState.value;
      if (story == null) throw Exception('Story generation failed');

      // Step 2: Generate Voice
      videoNotifier.updateProgress(0.3, 'Awaaz generate ho rahi hai...');
      final voiceService = VoiceService();
      await voiceService.initialize(widget.language);

      // Step 3: Generate Subtitles
      videoNotifier.updateProgress(0.5, 'Subtitles ban rahe hain...');
      final subtitleService = SubtitleService();
      final srtPath = await subtitleService.generateSRT(
        scenes: story.scenes,
        dialogues: story.dialogues,
      );

      // Step 4: Render Animation
      videoNotifier.updateProgress(0.7, 'Animation render ho raha hai...');
      await Future.delayed(const Duration(seconds: 2)); // Animation render time

      // Step 5: Music
      videoNotifier.updateProgress(0.85, 'Music add ho raha hai...');
      await Future.delayed(const Duration(seconds: 1));

      // Step 6: Final Export
      videoNotifier.updateProgress(0.95, 'Video export ho rahi hai...');
      await Future.delayed(const Duration(seconds: 2));

      videoNotifier.setCompleted('demo_video_path.mp4');

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => VideoPlayerScreen(story: story),
          ),
        );
      }
    } catch (e) {
      videoNotifier.setError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(videoGenerationProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.movie_creation_rounded,
                color: AppColors.primary,
                size: 80,
              ),
              const SizedBox(height: 24),
              const Text(
                'Aapki Video Ban Rahi Hai',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.currentStep,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 40),
              LinearProgressIndicator(
                value: state.progress,
                backgroundColor: AppColors.surface,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 12),
              Text(
                '${(state.progress * 100).round()}%',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (state.error != null) ...[
                const SizedBox(height: 24),
                Text(
                  'Error: ${state.error}',
                  style: const TextStyle(color: AppColors.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error),
                  child: const Text('Wapas Jao'),
                ),
              ],
              const SizedBox(height: 40),
              _buildStepsList(state.progress),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepsList(double progress) {
    final steps = [
      ('Story Generate', 0.1),
      ('Characters & Scenes', 0.25),
      ('Awaaz (Voice)', 0.3),
      ('Subtitles', 0.5),
      ('Animation Render', 0.7),
      ('Music Add', 0.85),
      ('Video Export', 0.95),
    ];

    return Column(
      children: steps.map((step) {
        final isDone = progress >= step.$2;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(
                isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isDone ? AppColors.success : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                step.$1,
                style: TextStyle(
                  color: isDone ? Colors.white : AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
