import 'story_model.dart';

enum VideoStatus {
  idle,
  generating,
  rendering,
  completed,
  failed,
}

class VideoProjectModel {
  final String id;
  final String userId;
  final StoryModel story;
  final VideoStatus status;
  final String videoPath;
  final String thumbnailPath;
  final int durationSeconds;
  final String resolution;
  final DateTime createdAt;
  final double progress;
  final String currentStep;

  VideoProjectModel({
    required this.id,
    required this.userId,
    required this.story,
    this.status = VideoStatus.idle,
    this.videoPath = '',
    this.thumbnailPath = '',
    this.durationSeconds = 0,
    this.resolution = '720p',
    required this.createdAt,
    this.progress = 0.0,
    this.currentStep = '',
  });

  VideoProjectModel copyWith({
    VideoStatus? status,
    String? videoPath,
    String? thumbnailPath,
    int? durationSeconds,
    double? progress,
    String? currentStep,
  }) {
    return VideoProjectModel(
      id: id,
      userId: userId,
      story: story,
      status: status ?? this.status,
      videoPath: videoPath ?? this.videoPath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      resolution: resolution,
      createdAt: createdAt,
      progress: progress ?? this.progress,
      currentStep: currentStep ?? this.currentStep,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'story': story.toJson(),
      'status': status.name,
      'videoPath': videoPath,
      'thumbnailPath': thumbnailPath,
      'durationSeconds': durationSeconds,
      'resolution': resolution,
      'createdAt': createdAt.toIso8601String(),
      'progress': progress,
      'currentStep': currentStep,
    };
  }
}
