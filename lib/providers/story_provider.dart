import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/story_model.dart';
import '../services/story_service.dart';
import '../services/ai/ai_manager.dart';

final aiManagerProvider = Provider<AIManager>((ref) => AIManager());

final storyServiceProvider = Provider<StoryService>((ref) {
  return StoryService(aiManager: ref.read(aiManagerProvider));
});

final storyGenerationProvider =
    AsyncNotifierProvider<StoryNotifier, StoryModel?>(StoryNotifier.new);

class StoryNotifier extends AsyncNotifier<StoryModel?> {
  @override
  Future<StoryModel?> build() async => null;

  Future<void> generateStory({
    required String prompt,
    required String language,
    String? fullScript,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(storyServiceProvider);
      return await service.generateStory(
        prompt: prompt,
        language: language,
        fullScript: fullScript,
      );
    });
  }

  void reset() {
    state = const AsyncData(null);
  }
}
