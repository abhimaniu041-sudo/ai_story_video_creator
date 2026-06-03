import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/story_model.dart';
import '../../models/scene_model.dart';

class VideoRenderer {
  Future<String> renderVideo({
    required StoryModel story,
    required List<String> sceneFramePaths,
    required List<String> audioFilePaths,
    required String subtitlePath,
    required String resolution,
    Function(double)? onProgress,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final outputPath = '${dir.path}/${story.id}_output.mp4';

    final resolutionMap = {
      '480p': '854x480',
      '720p': '1280x720',
      '1080p': '1920x1080',
    };
    final res = resolutionMap[resolution] ?? '1280x720';

    // Concat all scene frames
    final concatFile = '${dir.path}/concat.txt';
    final concatContent = sceneFramePaths
        .asMap()
        .entries
        .map((e) {
          final scene = story.scenes[e.key];
          return "file '${e.value}'\nduration ${scene.durationSeconds}";
        })
        .join('\n');
    await File(concatFile).writeAsString(concatContent);

    // Build audio mix command
    final audioInputs = audioFilePaths.map((p) => '-i "$p"').join(' ');
    final audioMix = audioFilePaths.isNotEmpty
        ? '-filter_complex "amix=inputs=${audioFilePaths.length}:duration=longest" -ac 2'
        : '-f lavfi -i anullsrc=r=44100:cl=stereo';

    final command = [
      '-f concat -safe 0 -i "$concatFile"',
      audioInputs,
      audioMix,
      '-vf "scale=$res,subtitles=$subtitlePath:force_style=\'FontSize=18,PrimaryColour=&HFFFFFF&\'"',
      '-c:v libx264 -preset fast -crf 23',
      '-c:a aac -b:a 128k',
      '-movflags +faststart',
      '-y "$outputPath"',
    ].join(' ');

    onProgress?.call(0.1);

    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      onProgress?.call(1.0);
      return outputPath;
    } else {
      final logs = await session.getLogsAsString();
      throw Exception('FFmpeg render failed: $logs');
    }
  }

  Future<String> captureSceneFrame({
    required SceneModel scene,
    required String outputDir,
  }) async {
    // Returns path to rendered scene image/video segment
    return '$outputDir/scene_${scene.id}.png';
  }
}
