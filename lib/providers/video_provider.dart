import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/video_project_model.dart';

class VideoGenerationState {
  final double progress;
  final String currentStep;
  final VideoStatus status;
  final String? videoPath;
  final String? error;

  const VideoGenerationState({
    this.progress = 0,
    this.currentStep = '',
    this.status = VideoStatus.idle,
    this.videoPath,
    this.error,
  });

  VideoGenerationState copyWith({
    double? progress,
    String? currentStep,
    VideoStatus? status,
    String? videoPath,
    String? error,
  }) {
    return VideoGenerationState(
      progress: progress ?? this.progress,
      currentStep: currentStep ?? this.currentStep,
      status: status ?? this.status,
      videoPath: videoPath ?? this.videoPath,
      error: error ?? this.error,
    );
  }
}

final videoGenerationProvider =
    StateNotifierProvider<VideoGenerationNotifier, VideoGenerationState>(
  (ref) => VideoGenerationNotifier(),
);

class VideoGenerationNotifier extends StateNotifier<VideoGenerationState> {
  VideoGenerationNotifier() : super(const VideoGenerationState());

  void updateProgress(double progress, String step) {
    state = state.copyWith(
      progress: progress,
      currentStep: step,
      status: VideoStatus.generating,
    );
  }

  void setRendering() {
    state = state.copyWith(status: VideoStatus.rendering);
  }

  void setCompleted(String videoPath) {
    state = state.copyWith(
      status: VideoStatus.completed,
      videoPath: videoPath,
      progress: 1.0,
      currentStep: 'Video ready!',
    );
  }

  void setError(String error) {
    state = state.copyWith(
      status: VideoStatus.failed,
      error: error,
    );
  }

  void reset() {
    state = const VideoGenerationState();
  }
}
